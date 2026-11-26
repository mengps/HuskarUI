---
name: qmlpreviewer
description: Preview or visually verify QML on Linux and Windows with the Qt 6 qml runtime. Use for live previews and screenshots of QML items or windows.
---

# QML Previewer

Use the QML file the user names or the active editor file. Resolve the path against the workspace. For a component that needs required properties, resources, or application context, use the project's normal entry point or a temporary QML wrapper that supplies those dependencies.

Use the `qml` executable (`qml.exe` on Windows) from the project's Qt 6 kit. Qt 6.8's `qmlscene` warns that it is deprecated and points to `qml`. Pass the kit executable with `--qml` when it is outside PATH or when several kits are installed.

## Capture a preview

Run the [preview script](preview_qml.py) with the QML file. Capture requires Python 3 and the kit's `QtTest` QML module. Pass `-I` once per QML import directory as needed. For the HuskarUI build, point it at `build/HuskarUI/qml` and make the matching shared libraries available through the environment when necessary.

Linux example:

```sh
python3 .agents/skills/qmlpreviewer/preview_qml.py /path/to/Page.qml \
  --qml /path/to/Qt/6.x/gcc_64/bin/qml \
  -I build/HuskarUI/qml
```

Windows example in PowerShell:

```powershell
python .agents/skills/qmlpreviewer/preview_qml.py C:\project\Page.qml `
  --qml C:\Qt\6.x\msvc2022_64\bin\qml.exe `
  -I build\HuskarUI\qml
```

The script prints the saved PNG path. Pick a destination with `-o preview.png`, or use `--delay-ms` when the page needs more time to load. It copies the image to the clipboard when available using `wl-copy` on Wayland, `xclip` on X11, or Windows PowerShell. The PNG is still available if clipboard copying fails. Use `--no-clipboard` for file-only output.

Linux without a display uses offscreen rendering automatically. Use `--headless` to request offscreen software rendering explicitly. For GPU effects, use the desktop Qt backend and verify the result there.

## Open a live preview

Run the kit executable directly with the QML file and any needed import paths. Use this for interaction or when the capture dependencies are unavailable.

```sh
/path/to/Qt/6.x/gcc_64/bin/qml -I build/HuskarUI/qml /path/to/Page.qml
```

Inspect the rendered UI and report the file, any visible issues, and the relevant Qt error if the preview fails.
