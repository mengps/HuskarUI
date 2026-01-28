[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusTheme



<br/>

## 代码演示

### 示例 1

通过 `HusTheme.installThemePrimaryColorBase()` 方法设置全局主题的主基础颜色，主基础颜色影响所有颜色的生成。

```qml
HusTheme.installThemePrimaryColorBase('#ff0000');
```

---

### 示例 2

通过 `HusTheme.installThemePrimaryFontSizeBase()` 方法设置全局主题的主基础字体大小，主基础字体大小影响所有字体大小的生成。

```qml
HusTheme.installThemePrimaryFontSizeBase(32);
```

---

### 示例 3

通过 `HusTheme.installThemePrimaryFontFamiliesBase()` 方法设置全局主题的主基础字体族字符串，该字符串可以是多个字体名，用逗号分隔，主题引擎将自动选择该列表中在本平台支持的字体。

```qml
HusTheme.installThemePrimaryFontFamiliesBase(''Microsoft YaHei UI', BlinkMacSystemFont, 'Segoe UI', Roboto');
```

---

### 示例 4

通过 `HusTheme.installThemePrimaryRadiusBase()` 方法设置圆角半径基础大小。

```qml
HusTheme.installThemePrimaryRadiusBase(6);
```

---

### 示例 5

通过 `HusTheme.installThemePrimaryAnimationBase()` 方法设置动画基础速度。

```qml
HusTheme.installThemePrimaryAnimationBase(100, 200, 300);
```

---

### 示例 6

通过 `HusTheme.installSizeHintRatio()` 方法设置尺寸提示比率。

已有的尺寸将会覆盖，没有的将添加为新尺寸。


```qml
HusTheme.installSizeHintRatio('normal', 2.0);
HusTheme.installSizeHintRatio('veryLarge', 5.0);
```

---

### 示例 7

通过 `HusTheme.animationEnabled` 属性开启/关闭全局动画，关闭动画资源占用更低。

```qml
HusTheme.animationEnabled = true;
```

