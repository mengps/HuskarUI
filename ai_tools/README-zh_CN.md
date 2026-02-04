# HuskarUI Expert 技能

本技能为 AI 智能体提供 HuskarUI 库的专家知识和工具，使其能够直接从代码库元数据中查询组件文档、属性和示例。

## 先决条件

本技能依赖于项目中存在的以下文件：
- `ai_tools/HuskarUIExpert/query_metainfo.py`: 用于查询元数据的 Python 脚本。
- `ai_tools/HuskarUIExpert/guide.metainfo.json`: 包含组件文档的元数据文件。

请确保这些文件位于项目根目录下，或者相应地调整 `SKILL.md` 中的路径。

## 安装指南

### 1. Gemini CLI

Gemini CLI 支持 Agent Skills 标准。

1.  如果目录不存在，请先创建：
    ```bash
    mkdir -p .gemini/skills
    ```
2.  将 `HuskarUIExpert` 目录链接或复制到 `.gemini/skills`：
    *   **Windows (PowerShell):**
        ```powershell
        New-Item -ItemType Junction -Path .gemini/skills/HuskarUIExpert -Target .\ai_tools\HuskarUIExpert
        ```
    *   **Linux/macOS:**
        ```bash
        ln -s ./ai_tools/HuskarUIExpert .gemini/skills/HuskarUIExpert
        ```
3.  重启 Gemini CLI，技能将自动加载。

### 2. Claude Code (Anthropic)

Claude Code 也使用 Agent Skills 标准。

1.  创建技能目录：
    ```bash
    mkdir -p .claude/skills
    ```
2.  链接或复制 `HuskarUIExpert` 目录：
    *   **Windows (PowerShell):**
        ```powershell
        New-Item -ItemType Junction -Path .claude/skills/HuskarUIExpert -Target .\ai_tools\HuskarUIExpert
        ```
    *   **Linux/macOS:**
        ```bash
        ln -s ./ai_tools/HuskarUIExpert .claude/skills/HuskarUIExpert
        ```
3.  Claude Code 将自动检测到 `SKILL.md`。

### 3. Trae / Cursor / VS Code Copilot

大多数基于 IDE 的智能体（Trae, Cursor, Copilot）目前不像 CLI 智能体那样自动从特定目录加载 `SKILL.md` 文件，但你仍然可以使用此技能：

#### 方案 A: 项目上下文（推荐用于 Trae/Cursor）
1.  打开 `ai_tools/HuskarUIExpert/SKILL.md` 文件。
2.  将其添加到当前的聊天上下文中（通常通过引用文件 `@SKILL.md`）。
3.  AI 现在将理解如何使用 `query_metainfo.py` 脚本来查找 HuskarUI 组件。

#### 方案 B: 全局规则
1.  复制 `SKILL.md` 的内容（不包括顶部的 YAML frontmatter 元数据）。
2.  将其粘贴到项目的自定义指令或规则文件中：
    *   **Trae:** `.traerules`（如果支持）或“项目设置 > 规则”。
    *   **Cursor:** `.cursorrules`。
    *   **VS Code Copilot:** `.github/copilot-instructions.md`。

## 使用方法

安装完成后，你可以向 AI 提问。除了基础的组件查询，你还可以让 AI 帮助你完成更复杂的任务。

### 1. 基础查询
*   “如何使用 HusAvatar 组件？”
*   “给我展示 HusButton 的属性。”
*   “查找与‘导航’相关的组件。”
*   “列出所有可用的 HuskarUI 组件。”

### 2. 场景化开发示例
你可以结合具体的开发场景，让 AI 提供完整的代码实现：

*   **创建应用框架**
    > “使用 HuskarUI 创建一个包含侧边栏导航和顶部标题栏的后台管理应用框架。”

*   **创建功能页面**
    > “使用 HuskarUI 创建一个用户个人资料页面，包含头像（HusAvatar）、用户名输入框（HusTextField）和保存按钮（HusButton）。”

*   **实现特定交互**
    > “如何使用 HuskarUI 实现一个带有确认对话框的删除按钮？请给出完整代码。”

AI 将自动使用配置的 Python 工具（或 `grep` 回退方案）从 `ai_tools/HuskarUIExpert/guide.metainfo.json` 中检索准确信息，并结合上下文生成符合规范的代码。
