---
name: "HuskarUI"
description: "Expert on HuskarUI components. Queries metadata for documentation and examples. Works with or without Python."
---

# HuskarUI Expert

This skill provides comprehensive knowledge about the HuskarUI library by querying `guide.metainfo.json`. Note that `guide.metainfo.json` and the helper script `query_metainfo.py` are typically located in `ai_tools/HuskarUIExpert/`, but they may also be found in the same directory as this SKILL file.

## Capabilities

1.  **Component Lookup**: Get detailed documentation, properties, and code examples.
2.  **Search**: Find components by keywords.
3.  **Listing**: List all available components.

## Usage Strategy

**CRITICAL**: The metadata file `guide.metainfo.json` is large (~500KB). **DO NOT** try to read the whole file at once.

### Method 1: Python Tool (Preferred)
Use this method if the environment supports Python.

**Lookup/Search:**
```bash
# Note: Adjust paths if the tool files are located elsewhere
python ai_tools/HuskarUIExpert/query_metainfo.py ai_tools/HuskarUIExpert/guide.metainfo.json <ComponentName_or_Keyword>
```

**List All:**
```bash
# Note: Adjust paths if the tool files are located elsewhere
python ai_tools/HuskarUIExpert/query_metainfo.py ai_tools/HuskarUIExpert/guide.metainfo.json list
```

### Method 2: Manual Fallback (No Python)
Use this method if `python` command fails or is not available.

**1. Locate Component:**
Use `grep` to find the line number of the component definition.
```bash
# Note: Adjust paths if guide.metainfo.json is located elsewhere
grep -n "\"name\": \"<ComponentName>\"" ai_tools/HuskarUIExpert/guide.metainfo.json
```

**2. Read Content:**
Use the `Read` tool with `offset` (the line number found above) and `limit` (e.g., 200 lines) to extract the component's JSON object.
*Note: Do not read from line 1 unless necessary.*

**3. Search (Manual):**
```
grep -i "<keyword>" ai_tools/HuskarUIExpert/guide.metainfo.json
```

### Advanced: Source Code Verification
If the documentation in `guide.metainfo.json` is unclear or if you suspect it might be outdated/incomplete:

1.  Look for the `"sources"` field in the component's metadata (retrieved via Method 1 or 2).
2.  Read the actual source file (e.g., `src/imports/HusAvatar.qml`) using the `Read` tool.
3.  Verify properties, signals, and implementation details directly from the code to minimize errors.

## Coding Guidelines

### QML Style Guide
Based on project conventions (e.g., `src/imports/HusAvatar.qml`):

1.  **Imports**:
    - Order: `QtQuick` -> `QtQuick.*` -> `HuskarUI.Basic`.
    - Use `import QtQuick.Templates as T` when inheriting from templates.

2.  **Naming**:
    - **Components**: PascalCase (e.g., `HusButton`).
    - **Properties/Functions**: camelCase (e.g., `iconSource`, `calcBestSize`).
    - **Private Members**: Prefix with double underscore (e.g., `__iconImpl`, `__bg`).
    - **IDs**: camelCase, descriptive (e.g., `control`, `titleText`).

3.  **Formatting**:
    - **Indentation**: 4 spaces.
    - **Quotes**: Single quotes `'string'` preferred for properties.
    - **Braces**: Egyptian style (opening brace on the same line).

4.  **Structure**:
    - `id` first.
    - Property declarations.
    - `implicitWidth` / `implicitHeight`.
    - Visual properties (font, color).
    - Child objects / Components.

5.  **Best Practices**:
    - **Performance**:
        - Use `Loader` for conditional complex sub-components to improve performance.
        - Avoid binding loops (circular dependencies in property bindings).
    - **JavaScript**:
        - Use `let` or `const` instead of `var` to avoid scope hoisting issues.
        - Use strict equality `===` and `!==` instead of `==` and `!=`.
        - Avoid global variables; encapsulate logic in stateless JavaScript libraries (`.js`/`.mjs` files) imported as stateless modules `.pragma library`.
        - Use arrow functions `() => {}` for short callbacks to preserve lexical `this` (if supported by the Qt version).
        - Prefer `Qt.binding(function() { ... })` when imperatively assigning bindings.

### C++ Style Guide
Based on `.clang-format`:

- **Style**: LLVM-based.
- **Standard**: C++17 or newer.
- **Indentation**: 4 spaces.
- **Pointer Alignment**: Right (`Type *ptr`).
- **Column Limit**: 100 characters.
- **Access Modifiers**: Indented by -4 spaces (align with class definition).
