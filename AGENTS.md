# 仓库规范

## 项目概况

HuskarUI 是一套参考 Ant Design 的 Qt Quick/QML 组件库（MIT）。README 与 CI 以 Qt >= 6.7 为准（CMake 最低查找 6.5），C++ 标准 17。仓库同时包含组件库与 Gallery 演示/文档程序。

- `src/` → QML 模块 `HuskarUI.Basic`：`src/imports/*.qml` 是全部 `Hus*` 组件；`src/cpp/` 是 C++ 支撑库与 QML 单例（`HusTheme`、`HusApp`、`HusApi`、`HusRouter`、`HusThemeFunctions`）。
- `src_impl/` → QML 模块 `HuskarUI.Impl`：`HusWindowAgent`，基于 qwindowkit 的无边框窗口实现。
- `3rdparty/` 下有两个 git submodule：`qwindowkit`、`QR-Code-generator`。

## 构建

先确保子模块已拉取：`git clone --recursive`，已有仓库执行 `git submodule update --init --recursive`。

本机 Qt 装在 `/home/mengpengsheng/Qt`（6.7.3、6.8.9）。Ninja（CI 同款）：

```sh
cmake -DCMAKE_PREFIX_PATH=/home/mengpengsheng/Qt/6.8.9/gcc_64 -G Ninja -B build -S .
cmake --build build --config Release --target all install --parallel
```

Visual Studio generator 则把构建目标换成 `ALL_BUILD INSTALL`。Windows 上使用 Ninja 需要在 MSVC 开发者环境（`vcvars64`）中运行。

- 安装默认写入 Qt SDK（`INSTALL_HUSKARUI_IN_DEFAULT_LOCATION=ON`）：头文件到 `include/HuskarUI`，库到 `bin`/`lib`，QML 插件到 `qml/HuskarUI/Basic` 与 `qml/HuskarUI/Impl`。改安装位置：`-DINSTALL_HUSKARUI_IN_DEFAULT_LOCATION=OFF -DHUSKARUI_INSTALL_DIRECTORY=<dir>`。
- Gallery 可执行文件输出到 `bin/<BuildType>/`；运行前需已 `install`，或保证 `HuskarUIBasic` / `HuskarUIImpl` 库在加载路径中。
- 常用选项：`BUILD_HUSKARUI_GALLERY`（默认 ON）、`BUILD_HUSKARUI_STATIC_LIBRARY`（默认 OFF）、`BUILD_HUSKARUI_ON_DESKTOP_PLATFORM`（桌面平台默认 ON，关闭后不构建 qwindowkit）。
- 版本号在根 `CMakeLists.txt` 的 `HUSKARUI_VERSION_MAJOR/MINOR/PATCH/TWEAK`。

消费方用法：`find_package(HuskarUI REQUIRED)` 后 `target_link_libraries(<target> HuskarUI::Basic)`，QML 中 `import HuskarUI.Basic`。

## 验证

- 仓库没有自动化测试，也没有 clang-format / qmllint 配置。CI（`.github/workflows/`）只做构建，覆盖 Windows MSVC、Linux GCC、macOS Clang 及 Qt 6.7.3–6.10.3。
- 修改后至少要构建通过。UI 改动应运行 Gallery 验证，或用 `.agents/skills/qmlpreviewer` 的 Qt 6 `qml` 截图流程单独预览 QML 文件。

## 架构

### 组件与 C++ 注册

- 组件文件为 `src/imports/*.qml`，优先继承 `QtQuick.Templates`（如 `T.Button`）。CMake 通过 `hus_get_dir_sources` glob `imports/*.qml`，新增 QML 文件无需改 `src/CMakeLists.txt`（但需重新运行一次 CMake 配置才会被 glob 到）；如需在 Qt Designer 中显示，再补 `src/designer/huskaruibasic.metainfo`。
- C++ 类型通过 `QML_ELEMENT` / `QML_SINGLETON` + `QML_NAMED_ELEMENT` 注册，导出宏为 `HUSKARUI_EXPORT`（静态库构建时为空）。
- Qt 版本条件编译集中在 `src/CMakeLists.txt`：Qt >= 6.10 使用私有模块；`QQuickDoubleSpinBox` 仅在 Qt < 6.11 且存在私有头时编译；TreeModel 仅在 LabsQmlModels 私有头可用时编译。

### 主题系统

- `src/resources/theme/Index.json` 定义全局 token（`__init__` / `__vars__` / `__style__`），值形如 `"#f5f5f5|#181818"`（浅色|深色），支持 `$genColor`、`$alpha`、`@token` 等表达式；每个组件的 `<Component>.json` 引用全局 token。
- 主题 JSON 通过 `qt_add_resources` 编入 `:/HuskarUI/theme`。
- `HusTheme` C++ 单例把每份 JSON 暴露为 `HusTheme.<Component>` 的 `QVariantMap`。组件中惯用 `property var themeSource: HusTheme.HusButton`，再读取 `themeSource.colorText` 等 token。
- **新增带主题的组件需同步三处**：新增 `src/resources/theme/<Component>.json`；在 `src/cpp/theme/hustheme.h` 添加 `HUS_PROPERTY_READONLY(QVariantMap, <Component>)`；在 `hustheme.cpp` 的 `initializeComponentPropertyHash()` 添加 `ADD_COMPONENT_PROPERTY(<Component>)`。
- 自定义主题使用 `HusTheme.installIndexTheme()` / `installComponentTheme()`，Gallery 的 `CustomTheme` 是现成示例。

### Gallery 与文档流水线

- Gallery 既是演示程序也是文档源：`gallery/qml/Examples/<Category>/Exp<Component>.qml` 中的 `DocDescription`、`Description`、`ThemeToken`、`CodeBox` 文本就是组件文档与示例代码。
- 新增或修改示例页面时，要在 `gallery/qml/Global.qml` 的 `galleryModel` 中注册，并把 QML 文件加入 `gallery/CMakeLists.txt` 的 `QML_FILES`。
- `python utils/main.py` 会**删除并重建** `docs/`，从 Examples 重新提取文档，同时更新 `.agents/skills/huskarui/guide.metainfo.json`。不要手改 `docs/`（会被覆盖）：应修改示例中的文档块后重新生成。脚本依赖 `loguru`。
- 文档内部链接写作 `[文字](internal://ComponentName)`，生成器会转换成相对路径。
- `utils/extract_docs.py` 的 `sources_table` 把每个组件映射到源文件。新增组件后要补这一项，否则生成的文档没有源文件引用。

### AI 组件查询

写 HuskarUI 代码前先用技能元数据查组件，不要凭记忆猜 API：

```sh
python .agents/skills/huskarui/query_metainfo.py .agents/skills/huskarui/guide.metainfo.json list
python .agents/skills/huskarui/query_metainfo.py .agents/skills/huskarui/guide.metainfo.json HusButton --exact
python .agents/skills/huskarui/query_metainfo.py .agents/skills/huskarui/guide.metainfo.json button
```

`guide.metainfo.json` 很大，始终通过脚本查询，不要整份读取。

## 代码约定

- QML import 顺序：`QtQuick` → `QtQuick.*` → `HuskarUI.Basic`；继承模板时使用 `import QtQuick.Templates as T`。
- 组件名 PascalCase，属性/函数/id camelCase，内部对象 id 可用双下划线前缀（`__`）；4 空格缩进；优先 `let`/`const`，使用 `===`/`!==`。
- QML 组件根对象只声明公开接口。内部状态、派生属性和辅助函数放在 `QtObject { id: __private }` 中，通过 `__private.xxx` 使用。根对象上带 `__` 前缀的属性仍可被外部访问。
- 枚举常量命名形如 `Type_Default`、`Shape_Circle`。
- 源文件保留 MIT 许可头。
