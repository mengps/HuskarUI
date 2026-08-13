[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusImagePreviewPanel 图片预览面板


用于预览的图片的基本面板，提供常用的图片变换(平移/缩放/翻转/旋转)操作。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **sourceDelegate: Component** 预览源项目代理(可以是 `Image/AnimatedImage/Video` 等)，必须提供 `sourceSize` 属性，代理可访问属性：

  - `sourceUrl: url` 源url

- **prevDelegate: Component** 前一幅按钮代理。

- **nextDelegate: Component** 后一幅按钮代理。

- **indicatorDelegate: Component** 索引指示器代理。

- **operationDelegate: Component** 操作区域代理。


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
scaleMin | real | 1.0 | 最小缩放值
scaleMax | real | 5.0 | 最大缩放值
scaleStep | real | 0.5 | 缩放步长
currentScale | real(readonly) | - | 当前缩放值
currentRotation | real(readonly) | - | 当前旋转(角度)值
currentIndex | int | - | 当前图片索引
count | int(readonly) | - | 当前图片数量
minViewHeight | real | height | 最小视图高度
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角
borderBg | [HusBorder](../General/HusBorder.md) | - | 背景边框

<br/>

### {items}支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
url | url | 必选 | 图片源

<br/>

### 支持的函数：

- `get(index: int): Object` 获取 `index` 处的模型数据 

- `set(index: int, object: Object)` 设置 `index` 处的模型数据为 `object` 

- `setProperty(index: int, propertyName: string, value: any)` 设置 `index` 处的模型数据属性名 `propertyName` 值为 `value` 

- `move(from: int, to: int, count: int = 1)` 将 `count` 个模型数据从 `from` 位置移动到 `to` 位置 

- `insert(index: int, object: Object)` 插入图片项 `object` 到 `index` 处 

- `append(object: Object)` 在末尾添加图片项 `object` 

- `remove(index: int, count: int = 1)` 删除 `index` 处 `count` 个模型数据 

- `zoomIn()` 中心放大 

- `zoomOut()` 中心缩小 

- `flipX()` 水平翻转 

- `flipY()` 垂直翻转 

- `rotate(angle: real)` 顺时针旋转 `angle` 度 

- `toCenter()` 回到中心 

- `resetTransform()` 重置所有变换 

- `incrementCurrentIndex()` 当前索引增1 

- `decrementCurrentIndex()` 当前索引减1 


<br/>

### 支持的信号：

- `clicked(inImage: bool)` 点击时发出

  - `inImage` 指针坐标是否在图像内

- `doubleClicked(inImage: bool)` 双击时发出

  - `inImage` 点击坐标是否在图像内


<br/>

## 代码演示

### 示例 1 - 基本用法

基本用法在 [HusImage](./HusImage.md) 中已有示例。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusImagePreviewPanel {
        id: imagePreview
        width: parent.width
        height: 500
        items: [
            { url: 'https://gw.alipayobjects.com/zos/antfincdn/LlvErxo8H9/photo-1503185912284-5271ff81b9a8.webp' },
            { url: 'https://gw.alipayobjects.com/zos/antfincdn/cV16ZqzMjW/photo-1473091540282-9b846e7965e3.webp' },
            { url: 'https://gw.alipayobjects.com/zos/antfincdn/x43I27A55%26/photo-1438109491414-7198515b166b.webp' },
        ]
    }
}
```

---

### 示例 2 - 高级用法

可以通过 `sourceDelegate` 将预览项替换为其他组件。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusImagePreviewPanel {
        id: gifPreviewPanel
        width: parent.width
        height: 500
        sourceDelegate: AnimatedImage {
            source: sourceUrl
            fillMode: Image.PreserveAspectFit
            onStatusChanged: {
                if (status == Image.Ready)
                    gifPreviewPanel.resetTransform();
            }
        }
        items: [
            { url: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif' },
            { url: 'https://gw.alipayobjects.com/zos/rmsportal/SQOZVQVIossbXpzDmihu.gif' },
            { url: 'https://gw.alipayobjects.com/zos/rmsportal/OkIXkscKxywYLSrilPIf.gif' },
        ]
    }
}
```

