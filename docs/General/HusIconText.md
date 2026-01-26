[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusIconText 图标文本


语义化的图标文本或图标。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusText](./HusText.md) }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
empty | bool(readonly) | - | 指示图标是否为空(iconSource == 0或'')
iconSource | int丨string | 0丨'' | 图标源(来自 HusIcon)或图标链接
iconSize | int | - | 图标大小
colorIcon | color | - | 图标颜色
contentDescription | string | '' | 内容描述(提高可用性)

**注意** 双色风格图标使用需要多个<Path{1~N}>图标覆盖使用


<br/>

