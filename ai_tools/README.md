# HuskarUI Expert Skill

This skill provides expert knowledge and tools for the HuskarUI library, enabling AI agents to query component documentation, properties, and examples directly from the codebase metadata.

## Prerequisites

This skill relies on the following files being present in your project:
- `ai_tools/HuskarUIExpert/query_metainfo.py`: The Python script used to query metadata.
- `ai_tools/HuskarUIExpert/guide.metainfo.json`: The metadata file containing component documentation.

Ensure these files are in your project root or adjust the paths in `SKILL.md` accordingly.

## Installation

### 1. Gemini CLI

Gemini CLI supports the Agent Skills standard.

1.  Create the skills directory if it doesn't exist:
    ```bash
    mkdir -p .gemini/skills
    ```
2.  Link or copy the `HuskarUIExpert` directory to `.gemini/skills`:
    *   **Windows (PowerShell):**
        ```powershell
        New-Item -ItemType Junction -Path .gemini/skills/HuskarUIExpert -Target .\ai_tools\HuskarUIExpert
        ```
    *   **Linux/macOS:**
        ```bash
        ln -s ./ai_tools/HuskarUIExpert .gemini/skills/HuskarUIExpert
        ```
3.  Restart Gemini CLI. The skill will be auto-loaded.

### 2. Claude Code (Anthropic)

Claude Code also uses the Agent Skills standard.

1.  Create the skills directory:
    ```bash
    mkdir -p .claude/skills
    ```
2.  Link or copy the `HuskarUIExpert` directory:
    *   **Windows (PowerShell):**
        ```powershell
        New-Item -ItemType Junction -Path .claude/skills/HuskarUIExpert -Target .\ai_tools\HuskarUIExpert
        ```
    *   **Linux/macOS:**
        ```bash
        ln -s ./ai_tools/HuskarUIExpert .claude/skills/HuskarUIExpert
        ```
3.  Claude Code will automatically detect the `SKILL.md`.

### 3. Trae / Cursor / VS Code Copilot

Most IDE-based agents (Trae, Cursor, Copilot) do not yet automatically load `SKILL.md` files from a specific directory in the same way CLI agents do, but you can still use this skill:

#### Option A: Project Context (Recommended for Trae/Cursor)
1.  Open the `SKILL.md` file.
2.  Add it to your current chat context (usually by referencing the file `@SKILL.md`).
3.  The AI will now understand how to use the `query_metainfo.py` script to look up HuskarUI components.

#### Option B: Global Rules
1.  Copy the content of `SKILL.md` (excluding the YAML frontmatter at the top).
2.  Paste it into your project's custom instructions or rules file:
    *   **Trae:** `.traerules` (if supported) or Project Settings > Rules.
    *   **Cursor:** `.cursorrules`.
    *   **VS Code Copilot:** `.github/copilot-instructions.md`.

## Usage

Once installed, you can ask the AI questions. Beyond basic component lookups, you can ask the AI to help with more complex tasks.

### 1. Basic Lookups
*   "How do I use the HusAvatar component?"
*   "Show me the properties for HusButton."
*   "Find components related to 'navigation'."
*   "List all available HuskarUI components."

### 2. Scenario-Based Examples
You can combine specific development scenarios and ask the AI for complete code implementations:

*   **Create App Skeleton**
    > "Create a dashboard app skeleton using HuskarUI with a sidebar navigation and a top header."

*   **Create Functional Pages**
    > "Create a user profile page using HuskarUI, including an avatar (HusAvatar), a username input (HusTextField), and a save button (HusButton)."

*   **Implement Interactions**
    > "How do I implement a delete button with a confirmation dialog using HuskarUI? Please provide the full code."

The AI will automatically use the configured Python tool (or `grep` fallback) to retrieve accurate information from `ai_tools/HuskarUIExpert/guide.metainfo.json` and generate code that follows the project's standards.
