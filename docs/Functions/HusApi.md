[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusApi 内置API 


提供一系列实用接口。

* **模块 { HuskarUI.Basic }**

* **继承自 { QObject }**


<br/>

### 支持的函数：

- `clamp(value: real, min: real, max: real): real`

    将一个值限制在指定的范围内。

- `setWindowStaysOnTopHint(window: Window, hint: bool)`

    将指定窗口 `window` 置顶。

- `setWindowState(window: Window, state: int)`

    设置 `window` 的窗口状态为 `state`。

- `setPopupAllowAutoFlip(popup: Popup, allowVerticalFlip: bool = true, allowHorizontalFlip: bool = true)`

    设置 `Popup` 弹窗是否允许超过窗口外时自动翻转(水平翻转/垂直翻转)。

- `getClipbordText(): string`

    获取当前剪切板内容。

- `setClipbordText(text: string): bool`

    设置当前剪切板内容为 `text`。

- `readFileToString(fileName: string)`

    读取 `fileName` 文件内容为字符串。

- `getWeekNumber(dateTime: date): int`

    获取 `dateTime` 指定的日期的周数。

- `dateFromString(dateTime：date, format: string): date`

    将字符串日期 `dateTime` 以 `format` 格式化并返回日期。

- `openLocalUrl(local: string)`

    打开本地Url `local`。


<br/>

