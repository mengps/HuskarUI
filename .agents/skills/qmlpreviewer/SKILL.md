---
name: "QmlPreviewer"
description: "Auto-detects the active QML file from editor context, runs qmlscene, and copies the rendered image to the clipboard by default. Invoke proactively when the agent needs to preview or visually verify a QML UI."
---

# QML Previewer

Use this skill whenever the agent needs to preview or visually verify a QML UI. Prefer the clipboard capture flow by default, and fall back to launching `qmlscene` directly when capture is unavailable or unsuitable.

## When To Use

Invoke this skill proactively when any of the following is true:

1. The agent needs to preview the active QML file to understand the visual result.
2. The agent needs to visually verify QML changes it just made or reviewed.
3. The agent needs screenshot-based evidence to inspect layout, rendering, clipping, or missing assets.
4. The agent needs to confirm whether a QML page loads successfully.
5. Visual verification is needed even if the user did not explicitly ask for a preview.

## Capabilities

1. **Auto Detection**: Resolve the active QML file from editor context.
2. **Clipboard Preview**: Run the capture script and copy the rendered result to the clipboard.
3. **Direct Launch**: Fall back to `qmlscene` when clipboard capture is unavailable or unsuitable.
4. **Visual Verification**: Report whether the page loads and whether obvious visual problems are present.
5. **Failure Reporting**: Surface path issues, launch failures, and runtime errors.

## Critical Rules

These rules are always enforced. Follow them in this order.

### File Resolution

- **Prefer the active editor file when it is a `.qml` file.**
- **If multiple files are open, use the focused editor tab.**
- **If editor context is missing, search for the most relevant recently edited `.qml` file.**
- **If auto-detection still fails, ask the user once for the QML file path.**

### Preview Execution

- **Use the clipboard capture flow by default.**
- **Pass absolute paths only** for both `qmlscene.exe` and the QML file.
- **Use the direct `qmlscene` launch only as a fallback** when capture is unavailable or unsuitable.
- **Do not silently skip preview.** If preview cannot run, explain why.

### Reporting

- **Report whether the QML page loads successfully.**
- **Report obvious layout or rendering issues** such as clipping, blank content, missing assets, or unexpected sizing.
- **Include runtime or terminal errors** when QML fails to launch.
- **Be explicit about which flow was used**: clipboard capture or direct launch.

## Execution Workflow

1. Resolve the QML file path from editor context.
2. Validate that the QML file path is absolute and exists.
3. Resolve the absolute path to `qmlscene.exe`.
4. Run the default clipboard capture flow:

```powershell
& "<SKILL_DIR>\capture_qmlscene_to_clipboard.ps1" -QmlScenePath "<qmlscene.exe>" -QmlFilePath "<auto-detected absolute QML file path>"
```

5. If clipboard capture is unavailable or unsuitable, launch the page directly:

```powershell
& "<qmlscene.exe>" "<auto-detected absolute QML file path>" --maximized
```

6. Inspect the clipboard image or live preview.
7. Report load status, visible issues, and any runtime failures.

## Fallback Workflow

Use this fallback order:

1. If clipboard capture fails, verify both paths and retry only if the failure is clearly path-related.
2. If capture remains unsuitable, launch the page directly with `qmlscene`.
3. If auto-detection fails, ask once for the QML file path, then continue.
4. If QML cannot load, capture terminal or runtime error output and include it in the report.

## Response Policy

When using this skill in an answer:

1. State which QML file was previewed.
2. State which execution flow was used.
3. Report whether the page loaded successfully.
4. Summarize obvious visual findings.
5. Include launch or runtime errors when present.
6. State what blocked verification if preview could not be completed.

## Quick Reference

```powershell
# Default clipboard capture flow
& "<SKILL_DIR>\capture_qmlscene_to_clipboard.ps1" -QmlScenePath "<qmlscene.exe>" -QmlFilePath "<absolute QML file path>"

# Direct qmlscene fallback
& "<qmlscene.exe>" "<absolute QML file path>" --maximized
```

## Current Skill Context

The skill currently depends on:

```text
<SKILL_DIR>\SKILL.md
<SKILL_DIR>\capture_qmlscene_to_clipboard.ps1
```

The capture script currently supports:

- Required `-QmlScenePath`
- Required `-QmlFilePath`
- Optional `-StartupDelayMs`
- Optional `-WindowPollTimeoutMs`
- Optional `-WindowPollIntervalMs`
- Optional `-KeepOpen`

## Detailed References

- `capture_qmlscene_to_clipboard.ps1` - default preview and clipboard capture entrypoint
- `qmlscene.exe` - fallback runtime for direct QML preview
