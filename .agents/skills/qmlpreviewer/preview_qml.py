#!/usr/bin/env python3
"""Render a QML Item or Window to PNG with the Qt 6 qml runtime."""

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


WINDOWS_CLIPBOARD = """
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
$image = [System.Drawing.Image]::FromFile($env:QML_PREVIEW_IMAGE)
try {
    $data = New-Object System.Windows.Forms.DataObject
    $data.SetImage($image)
    [System.Windows.Forms.Clipboard]::SetDataObject($data, $true, 5, 120)
}
finally {
    $image.Dispose()
}
"""


def clipboard_command():
    if sys.platform == "win32" and shutil.which("powershell.exe"):
        return ["powershell.exe", "-NoProfile", "-NonInteractive", "-STA",
                "-Command", WINDOWS_CLIPBOARD]

    if sys.platform.startswith("linux"):
        if os.environ.get("WAYLAND_DISPLAY") and shutil.which("wl-copy"):
            return ["wl-copy", "--type", "image/png"]
        if os.environ.get("DISPLAY") and shutil.which("xclip"):
            return ["xclip", "-selection", "clipboard", "-t", "image/png", "-i"]

    return None


def copy_preview(path):
    command = clipboard_command()
    if command is None:
        return False

    env = dict(os.environ, QML_PREVIEW_IMAGE=str(path))
    try:
        with path.open("rb") as image:
            result = subprocess.run(command, stdin=image, stdout=subprocess.DEVNULL,
                                    env=env, timeout=5, check=False)
        return result.returncode == 0
    except (OSError, subprocess.TimeoutExpired):
        return False


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", type=Path, help="QML file to preview")
    parser.add_argument("--qml", help="Qt 6 qml executable (qml or qml.exe)")
    parser.add_argument("-I", dest="import_paths", action="append", default=[], type=Path,
                        help="QML import directory, repeatable")
    parser.add_argument("-o", "--output", type=Path, help="PNG output path")
    parser.add_argument("--delay-ms", type=int, default=750,
                        help="wait after showing the QML window (default: 750 ms)")
    parser.add_argument("--headless", action="store_true", help="use offscreen software rendering")
    parser.add_argument("--no-clipboard", action="store_true", help="only save the PNG")
    args = parser.parse_args()

    source = args.file.resolve()
    if source.suffix.lower() != ".qml" or not source.is_file():
        parser.error(f"QML file not found: {source}")
    if args.delay_ms < 0:
        parser.error("--delay-ms must be nonnegative")
    output = args.output.resolve() if args.output else None
    if output and output.suffix.lower() != ".png":
        parser.error("--output must end in .png")

    if args.qml:
        runtime = shutil.which(args.qml)
    else:
        runtime = shutil.which("qml6") or shutil.which("qml-qt6") or shutil.which("qml")
    if runtime is None:
        parser.error("Qt 6 qml was not found. Pass the SDK executable with --qml.")

    env = os.environ.copy()
    has_display = env.get("DISPLAY") or env.get("WAYLAND_DISPLAY")
    linux_without_display = sys.platform.startswith("linux") and not has_display
    if args.headless:
        env.update(QT_QPA_PLATFORM="offscreen", QT_QUICK_BACKEND="software")
    elif linux_without_display and not env.get("QT_QPA_PLATFORM"):
        env["QT_QPA_PLATFORM"] = "offscreen"
        env.setdefault("QT_QUICK_BACKEND", "software")

    command = [runtime]
    for path in args.import_paths:
        command.extend(["-I", str(path.resolve())])
    command.append(str(Path(__file__).resolve().with_name("Capture.qml")))

    try:
        with tempfile.TemporaryDirectory(prefix="qml-preview-render-") as temporary:
            captured = Path(temporary) / "preview.png"
            subprocess.run(
                [*command, "--", source.as_uri(), str(captured), str(args.delay_ms)],
                env=env, timeout=args.delay_ms / 1000 + 15, check=True,
            )
            if not captured.is_file():
                raise RuntimeError("qml exited before producing a screenshot")
            if output is None:
                output = Path(tempfile.mkdtemp(prefix="qml-preview-")) / "preview.png"
            shutil.copyfile(captured, output)
    except subprocess.CalledProcessError as error:
        print(f"qml exited with status {error.returncode}", file=sys.stderr)
        return 1
    except subprocess.TimeoutExpired:
        print("Timed out while waiting for a QML screenshot.", file=sys.stderr)
        return 1
    except (OSError, RuntimeError) as error:
        print(f"QML preview failed: {error}", file=sys.stderr)
        return 1

    print(f"PNG: {output}")
    if not args.no_clipboard and (has_display or sys.platform == "win32"):
        if copy_preview(output):
            print("Image copied to clipboard")
        else:
            print("Clipboard unavailable; the PNG is saved above.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
