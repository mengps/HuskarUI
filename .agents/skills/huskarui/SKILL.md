---
name: "HuskarUI"
description: "Queries HuskarUI metadata with Python and guides HuskarUI-first QML/C++ code. Invoke when choosing components, checking examples, or generating HuskarUI UI."
---

# HuskarUI

Use this skill when the agent needs HuskarUI component knowledge or must generate HuskarUI-first UI. Treat Python query results as the primary source of truth. Use source files only for verification. The skill always works from `query_metainfo.py` and `guide.metainfo.json` in `<SKILL_DIR>`.

## When To Use

Invoke this skill proactively when any of the following is true:

1. The agent needs to identify which HuskarUI component matches a requested control, pattern, or interaction.
2. The agent needs examples, documentation, or usage guidance for a HuskarUI component.
3. The user asks for HuskarUI-first QML code such as a page, dialog, toolbar, form, navigation area, or card.
4. The agent needs to decide whether a visible control should use HuskarUI or native QtQuick.
5. The agent needs to search the HuskarUI component set before proposing an implementation.

## Capabilities

1. **List**: Return component titles for discovery.
2. **Lookup**: Return documentation and embedded examples for an exact component name.
3. **Search**: Return candidate components for a keyword or UI role.
4. **Component Mapping**: Map generic UI requests to HuskarUI components before code generation.
5. **HuskarUI-first Guidance**: Choose HuskarUI controls over native QtQuick when a suitable component exists.

## Critical Rules

These rules always apply. Follow them in this order.

### Metadata

- **Always use Python first.** Query metadata before answering from memory.
- **Never read the full `guide.metainfo.json` directly.** Use `query_metainfo.py`.
- **Use exact lookup for known component names.** Do not guess APIs or examples.
- **Use keyword search for generic UI needs.** Search by role such as `button`, `dialog`, `avatar`, `table`, `navigation`.

### Component Selection

- **Prefer HuskarUI for visible controls.** Buttons, inputs, avatars, dialogs, tables, navigation, and common widgets should map to HuskarUI first.
- **Use native QtQuick only when HuskarUI has no suitable component** or when the need is clearly low-level layout, animation, or primitives.
- **Do not mix HuskarUI and native controls for the same role without a clear reason.**
- **Say explicitly when no HuskarUI component fits** before falling back to native QtQuick.

### Code Generation

- **Base generated code on metadata results, not assumptions.**
- **Use Python-returned examples as the primary usage reference.**
- **For generic UI requests, map each requested role to a HuskarUI component before writing code.**
- **Prefer composition from existing HuskarUI components over custom controls.**

## Query Workflow

1. Work from `<SKILL_DIR>` and use `query_metainfo.py` with `guide.metainfo.json`.
2. Select the query mode that matches the request:
   - `list` when you need discovery or want to browse the component set.
   - `<ComponentName> --exact` when the component name is already known.
   - `<keyword>` when the request describes a generic UI role or interaction.
3. Run the Python query before answering from memory.
4. Use the returned title, documentation, and examples as the primary basis for the answer.
5. For UI generation, map the requested UI roles to HuskarUI components first.
6. Compose the code from those components.
7. If the results are empty or insufficient, say that explicitly and fall back to the minimum native QtQuick needed.

## Verification Workflow

Use source verification only when at least one of these is true:

1. The Python output is ambiguous.
2. The examples do not cover the requested usage.
3. The user asks for implementation-level behavior.
4. The metadata appears stale or incomplete.

When verification is needed:

1. Identify the target component through Python first.
2. Read only the source file or section that is needed to verify the specific point in question.
3. Confirm the exact behavior, API detail, or implementation constraint being discussed.
4. Answer from the verified implementation.
5. State explicitly that source verification was required.

## Coding Guidelines

### QML

- **Import order:** `QtQuick` -> `QtQuick.*` -> `HuskarUI.Basic`.
- **Use `QtQuick.Templates as T`** when inheriting from templates.
- **Names:** Components in PascalCase; properties, functions, and ids in camelCase.
- **Private members:** Prefix with double underscore.
- **Indentation:** 4 spaces.
- **Structure:** `id`, properties, implicit size, visual properties, child objects.
- **Prefer `let` and `const`** over `var`.
- **Use strict equality** with `===` and `!==`.
- **Avoid binding loops.**
- **Use `Loader` for conditional heavy subtrees** when appropriate.

## Response Policy

When answering with this skill:

1. Start from Python query results, not from memory.
2. Name the HuskarUI component or candidate components that best match the request.
3. Summarize the most relevant documentation and examples returned by the query.
4. When implementation is requested, generate HuskarUI-first code based on those results.
5. State explicitly when the answer depends on source verification.
6. State explicitly when no suitable HuskarUI component was found and native QtQuick is used as the fallback.

## Quick Reference

```powershell
# List all components
python <SKILL_DIR>/query_metainfo.py <SKILL_DIR>/guide.metainfo.json list

# Exact lookup
python <SKILL_DIR>/query_metainfo.py <SKILL_DIR>/guide.metainfo.json HusAvatar --exact

# Search by keyword or UI role
python <SKILL_DIR>/query_metainfo.py <SKILL_DIR>/guide.metainfo.json button
python <SKILL_DIR>/query_metainfo.py <SKILL_DIR>/guide.metainfo.json navigation
python <SKILL_DIR>/query_metainfo.py <SKILL_DIR>/guide.metainfo.json table
```

## Skill Inputs

The skill always works from these files in `<SKILL_DIR>`:

```text
<SKILL_DIR>/query_metainfo.py
<SKILL_DIR>/guide.metainfo.json
```

The Python helper supports:

- Listing all component titles.
- Exact component lookup by title.
- Keyword search across component titles and documentation.
- Returning documentation and embedded QML examples.

## Detailed References

- `query_metainfo.py` - metadata query entrypoint
- `guide.metainfo.json` - metadata database, accessed through Python only
- Repository source files - selective verification only when Python output is ambiguous or insufficient
