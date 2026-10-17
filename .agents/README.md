# Agent Skills

This directory provides two agent skills for this repository:

- `huskarui`: Query HuskarUI component documentation, properties, and examples from repository metadata via Python.
- `qmlpreviewer`: Preview the currently edited QML file with `qmlscene` and capture the running screenshot to the clipboard.

## Prerequisites

### huskarui

- `.agents/skills/huskarui/query_metainfo.py`
- `.agents/skills/huskarui/guide.metainfo.json`
- Python available on your system (`python`)

### qmlpreviewer

- `qmlscene.exe` absolute path (Qt)

## Installation

Copy (or symlink/junction) these folders into your agent's skills directory (the directory your agent scans for `SKILL.md`):

- `.agents/skills/huskarui`
- `.agents/skills/qmlpreviewer`

## Usage

Once installed, you can ask the AI questions. Beyond basic component lookups, you can ask the AI to help with more complex tasks.

### huskarui examples

Users only need to describe what they want to build or learn. They do not need to explicitly mention the `HuskarUI` skill.

* "How do I use the avatar component on a profile page?"
* "What properties does the HusButton support?"
* "Create a dashboard page with a sidebar and top header."
* "Build a user profile form with avatar, username input, and a save button."
* "Implement a delete action with a confirmation dialog and provide the full code."

When the request is about HuskarUI components, properties, examples, or page generation, the AI should proactively invoke the `HuskarUI` skill. It should use `.agents/skills/huskarui/query_metainfo.py` to retrieve accurate information from `.agents/skills/huskarui/guide.metainfo.json` and then generate code that follows the project's standards.

### qmlpreviewer examples

Users only need to ask for a preview or visual check. They do not need to explicitly mention the `QmlPreviewer` skill.

*   "Preview the current page."
*   "Check whether the current QML layout looks correct."
*   "Visually verify the QML changes I just made."

When the request involves previewing the current QML file, taking a screenshot, or visually checking a QML UI, the AI should proactively invoke the `QmlPreviewer` skill.
