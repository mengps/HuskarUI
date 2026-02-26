[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusLiquidGlass 液态玻璃 


液态玻璃/折射效果，灵感来源于 Apple WWDC 2025 液态玻璃 (Liquid Glass) 设计风格。

* **模块 { HuskarUI.Basic }**

* **继承自 { Item }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
--------|------|:------: | ---
sourceItem | Item | - | 源项目
sourceRect | rect | - | 源矩形大小
refraction | real | 0.026 | 折射强度
bevelDepth | real | 0.119 | 斜面深度
bevelWidth | real | 0.057 | 斜面宽度
frost | real | 0.0 | 磨砂程度
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角
animated | bool | true | 是否启用动态高光（Lissajous 运动）
specularIntensity | real | 1.0 | 高光强度
tiltX | real | 0.0 | 水平倾斜角度
tiltY | real | 0.0 | 垂直倾斜角度
magnify | real | 1.0 | 放大倍数


<br/>

## 代码演示

### 示例 1 - 基本液态玻璃

通过 `sourceItem` 属性设置需要该效果的项目，**注意** `HusLiquidGlass` 不能为 `sourceItem` 的子项。

通过 `refraction` 控制折射强度。

通过 `frost` 控制磨砂程度。

```qml
import QtQuick
import HuskarUI.Basic

Rectangle {
    width: 400
    height: 400

    HusIconText {
        id: source
        iconSize: 400
        iconSource: HusIcon.BugOutlined
        colorIcon: HusTheme.Primary.colorPrimary
    }

    HusLiquidGlass {
        x: 100
        y: 100
        width: 200
        height: 200
        sourceItem: source
        refraction: 0.026
        frost: 0.0
        radiusBg: HusRadius { all: 16 }
    }
}
```

### 示例 2 - 磨砂玻璃

通过增大 `frost` 值实现磨砂效果。

```qml
import QtQuick
import HuskarUI.Basic

Rectangle {
    width: 400
    height: 400

    HusIconText {
        id: source
        iconSize: 400
        iconSource: HusIcon.BugOutlined
        colorIcon: HusTheme.Primary.colorPrimary
    }

    HusLiquidGlass {
        x: 100
        y: 100
        width: 200
        height: 200
        sourceItem: source
        frost: 3.0
        bevelDepth: 0.052
        radiusBg: HusRadius { all: 24 }
    }
}
```

### 示例 3 - 倾斜与放大

通过 `tiltX` / `tiltY` 模拟倾斜折射。

通过 `magnify` 实现放大镜效果。

```qml
import QtQuick
import HuskarUI.Basic

Rectangle {
    width: 400
    height: 400

    HusIconText {
        id: source
        iconSize: 400
        iconSource: HusIcon.BugOutlined
        colorIcon: HusTheme.Primary.colorPrimary
    }

    HusLiquidGlass {
        x: 100
        y: 100
        width: 200
        height: 200
        sourceItem: source
        tiltX: 15
        tiltY: -10
        magnify: 1.5
        radiusBg: HusRadius { all: 20 }
    }
}
```


<br/>

## 属性详解

### refraction

折射强度。控制光线经过玻璃边缘时的偏折程度。值为 0 时无折射效果，推荐范围 0.01 ~ 0.05。默认值 0.026 与 liquidGL 一致。

### bevelDepth / bevelWidth

斜面参数。`bevelDepth` 控制边缘凸起折射的强度（使用 `pow(edge, 10)` 的十次幂创造极窄的高折射外圈），`bevelWidth` 控制斜面渐变区域的宽度。默认值 `bevelDepth=0.119`、`bevelWidth=0.057` 与 liquidGL 一致，产生明显的"玻璃覆盖感"。

### frost

磨砂程度。使用 Poisson-disk 随机采样模拟真实的磨砂玻璃。值为 0 时为透明玻璃（仅折射），推荐磨砂值 1.0 ~ 5.0。

### animated

是否启用动态高光。默认为 true，两个虚拟光源做 Lissajous 运动，模拟环境光在玻璃表面的反射。

### specularIntensity

镜面高光强度。高光以加法混合叠加到最终颜色上。设为 0 可完全关闭高光。

### tiltX / tiltY

倾斜角度。影响折射偏移方向和高光位置。可用于模拟用户手持设备时的角度变化。

### magnify

放大倍数。1.0 为原始大小，> 1.0 放大，< 1.0 缩小。使用 UV 缩放实现，边缘做了柔和过渡处理。
