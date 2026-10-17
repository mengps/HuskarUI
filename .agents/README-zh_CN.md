# Agent Skills（智能体技能）

本目录为本仓库提供了两个智能体技能：

- **`huskarui`**：通过 Python 从仓库元数据中查询 HuskarUI 组件的文档、属性和示例。
- **`qmlpreviewer`**：使用 `qmlscene` 预览当前编辑的 QML文件，并捕获运行截图到剪贴板。

## 前置条件

### huskarui

- `.agents/skills/huskarui/query_metainfo.py`
- `.agents/skills/huskarui/guide.metainfo.json`
- 系统中已安装 Python (`python`)

### qmlpreviewer

- `qmlscene.exe` 的绝对路径 (Qt)

## 安装

将这些文件夹复制（或创建符号链接/联结）到你的智能体的 skills 目录中（即你的智能体扫描 `SKILL.md` 文件的目录）：

- `.agents/skills/huskarui`
- `.agents/skills/qmlpreviewer`

## 使用方法

安装完成后，你可以向 AI 提问。除了基本的组件查找外，你还可以要求 AI 协助完成更复杂的任务。

### huskarui 示例

用户只需要描述他们想要构建或学习什么。他们不需要明确提及“HuskarUI”技能。

* “如何在个人资料页面上使用头像组件？”
* “HusButton支持哪些属性？”
* “创建一个带有侧边栏和顶部标题的仪表盘页面。”
* “使用头像、用户名输入和保存按钮创建一个用户配置文件表单。”
* “使用确认对话框执行删除操作，并提供完整代码。”    

当请求涉及HuskarUI组件、属性、示例或页面生成时，AI应主动调用“HuskarUI”技能。它应该使用`.agents/skills/huskarui/query_metainfo.py`从`.agents/skills/huskarui/guide.metainfo.json`中检索准确的信息，然后生成符合项目标准的代码。

### qmlpreviewer 示例

用户只需要求预览或视觉检查。他们不需要明确提及“QmlPreviewer”技能。

* “预览当前页面。”
* “检查当前QML布局是否正确。”
* “可视化验证我刚才所做的QML更改。”

当请求涉及预览当前QML文件、截图或视觉检查QML UI时，AI应该主动调用“QmlPreviewer”技能。

