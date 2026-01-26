[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSpace 间距


布局并设置组件之间的间距/圆角。

* **模块 { HuskarUI.Basic }**

* **继承自 { Loader }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
type | enum | HusSpace.Type_Compact | 间距类型(来自 HusSpace)
layout | string | '' | 布局类型
autoCombineRadius | bool | true | 是否自动组合圆角
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角

其他属性来自 **Row/RowLayout/Column/ColumnLayout/Grid/GridLayout** 


**注意** 覆盖问题请使用 `z: active ? 1 : 0` 或类似的方案解决


**注意** 自动组合圆角无法正确处理 Repeater 创建的项，此时应关闭 `autoCombineRadius` 并手动设置圆角


<br/>

## 代码演示

### 示例 1 - 基本用法

通过 `layout` 属性设置实例化布局(设置一次)，设置完成后和原生布局一样使用即可。

`layout` 支持的值有：'Row' 'RowLayout' 'Column' 'ColumnLayout' 'Grid' 'GridLayout' 


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    Row {
        HusText {
            width: 120
            anchors.verticalCenter: parent.verticalCenter
            text: 'ButtonType: '
        }
        HusRadioBlock {
            id: buttonTypeRadio
            initCheckedIndex: 0
            model: [
                { label: 'Default', value: HusButton.Type_Default },
                { label: 'Outlined', value: HusButton.Type_Outlined },
                { label: 'Dashed', value: HusButton.Type_Dashed },
                { label: 'Primary', value: HusButton.Type_Primary },
                { label: 'Filled', value: HusButton.Type_Filled },
            ]
        }
    }

    Row {
        HusText {
            width: 120
            anchors.verticalCenter: parent.verticalCenter
            text: 'LayoutDirection: '
        }
        HusRadioBlock {
            id: layoutDirectionRadio
            initCheckedIndex: 0
            model: [
                { label: 'LeftToRight', value: Qt.LeftToRight },
                { label: 'RightToLeft', value: Qt.RightToLeft },
            ]
        }
    }

    Row {
        HusText {
            width: 120
            anchors.verticalCenter: parent.verticalCenter
            text: 'Space: '
        }
        HusSlider {
            id: spaceSlider
            width: 200
            height: 30
            min: -1
            max: 100
            value: -1
        }
    }

    HusSpace {
        layout: 'Row'
        spacing: spaceSlider.currentValue
        layoutDirection: layoutDirectionRadio.currentCheckedValue

        HusIconButton {
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.LikeOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Like' }
        }

        HusIconButton {
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.CommentOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Comment' }
        }

        HusIconButton {
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.StarOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Star' }
        }

        HusIconButton {
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.HeartOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Heart' }
        }

        HusIconButton {
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.ShareAltOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Share' }
        }

        HusIconButton {
            enabled: false
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.DownloadOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Download' }
        }

        HusIconButton {
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.EllipsisOutlined
            onClicked: contextMenu.open();

            HusContextMenu {
                id: contextMenu
                y: parent.height + 2
                menu.leftPadding: 4
                menu.rightPadding: 4
                menu.topPadding: 4
                menu.bottomPadding: 4
                defaultMenuWidth: 110
                initModel: [
                    { key: '1', label: 'Report', iconSource: HusIcon.WarningOutlined, },
                    { key: '2', label: 'Mail', iconSource: HusIcon.MailOutlined },
                    { key: '3', label: 'Mobile', iconSource: HusIcon.MobileOutlined },
                ]
                onClickMenu: close();
                Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
            }
        }
    }

    HusSpace {
        layout: 'Row'
        spacing: spaceSlider.currentValue
        layoutDirection: layoutDirectionRadio.currentCheckedValue

        HusButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button1' }
        HusButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button2' }
        HusButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button3' }
        HusButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button4' }

        HusIconButton {
            enabled: false
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.DownloadOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Download' }
        }

        HusIconButton {
            type: buttonTypeRadio.currentCheckedValue
            iconSource: HusIcon.DownloadOutlined
            HusToolTip { showArrow: true; visible: parent.hovered; text: 'Download' }
        }
    }
}
```

---

### 示例 2 - 列布局

layout === 'Column/ColumnLayout' 用法，等同于使用原生 `Column/ColumnLayout`。


```qml
import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Row {
    spacing: 15

    HusSpace {
        layout: 'Column'

        HusButton { text: 'Button1' }
        HusButton { text: 'Button2' }
        HusButton { text: 'Button3' }
    }

    HusSpace {
        layout: 'Column'

        HusButton { type: HusButton.Type_Dashed; text: 'Button1' }
        HusButton { type: HusButton.Type_Dashed; text: 'Button2' }
        HusButton { type: HusButton.Type_Dashed; text: 'Button3' }
    }

    HusSpace {
        layout: 'Column'

        HusButton { type: HusButton.Type_Primary; text: 'Button1' }
        HusButton { type: HusButton.Type_Primary; text: 'Button2' }
        HusButton { type: HusButton.Type_Primary; text: 'Button3' }
    }
}
```

---

### 示例 3 - 网格布局

layout === 'Grid/GridLayout' 用法，等同于使用原生 `Grid/GridLayout`。

`HusSpace` 会自动组合子组件，使它们看起来像一个整体。


```qml
import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Column {
    spacing: 15

    Row {
        HusText {
            width: 120
            anchors.verticalCenter: parent.verticalCenter
            text: 'LayoutDirection: '
        }
        HusRadioBlock {
            id: layoutDirectionRadio2
            initCheckedIndex: 0
            model: [
                { label: 'LeftToRight', value: Qt.LeftToRight },
                { label: 'RightToLeft', value: Qt.RightToLeft },
            ]
        }
    }

    HusSpace {
        layout: 'GridLayout'
        rows: 3
        columns: 3
        layoutDirection: layoutDirectionRadio2.currentCheckedValue

        HusButton { Layout.preferredWidth: 100; z: hovered ? 1 : 0; type: HusButton.Type_Primary; text: 'Button1' }
        HusButton { Layout.preferredWidth: 100; z: hovered ? 1 : 0; text: 'Button2' }
        HusIconButton { Layout.fillWidth: true; z: hovered ? 1 : 0; iconSource: HusIcon.LikeOutlined }

        HusSelect {
            Layout.preferredWidth: 100
            z: active ? 1 : 0
            currentIndex: 0
            model: [
                { label: 'Between' },
                { label: 'Except' },
            ]
        }
        HusInput {
            Layout.preferredWidth: 150
            Layout.columnSpan: 2
            z: hovered ? 1 : 0
        }

        HusLabel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: '$'
            colorBg: HusTheme.Primary.colorFillPrimary
            verticalAlignment: HusLabel.AlignVCenter
            horizontalAlignment : HusLabel.AlignHCenter
        }
        HusInput {
            Layout.fillWidth: true
            Layout.maximumWidth: 100
            z: hovered ? 1 : 0
            text: '1,000,000'
        }
        HusIconButton {
            Layout.fillWidth: true
            z: hovered ? 1 : 0
            iconSource: HusIcon.SearchOutlined
        }
    }
}
```

---

### 示例 4 - 常见组合

一些常见的组合例子。


```qml
import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Column {
    spacing: 10

    HusSpace {
        layout: 'Row'

        HusInput { width: 100; text: '0571' }
        HusInput { width: 150; text: '26888888' }
    }

    HusSpace {
        layout: 'Row'

        HusInput { text: 'https://github.com/mengps/HuskarUI' }
        HusButton { type: HusButton.Type_Primary; text: 'Submit' }
    }

    HusSpace {
        layout: 'Row'

        HusInput { text: 'https://github.com/mengps/HuskarUI' }
        HusIconButton { iconSource: HusIcon.CopyOutlined }
    }

    HusSpace {
        layout: 'Row'

        HusSelect { model: [{ label: 'Jiangsu' }, { label: 'Hubei' }] }
        HusInput { width: 300; text: 'Pukou District, Nanjing' }
    }

    HusSpace {
        layout: 'Row'

        HusMultiSelect { width: 300; options: [{ label: 'Jiangsu' }, { label: 'Hubei' }] }
        HusInput { width: 300; text: 'Pukou District, Nanjing' }
    }

    HusSpace {
        layout: 'Row'

        HusInput { width: 200; text: 'input content' }
        HusDateTimePicker { width: 200; placeholderText: 'Please select date' }
    }

    HusSpace {
        layout: 'RowLayout'

        HusDateTimePicker { Layout.preferredWidth: 200; placeholderText: 'Please select start date' }
        HusLabel { Layout.fillHeight: true; text: '  =>  '; verticalAlignment: HusLabel.AlignVCenter }
        HusDateTimePicker { Layout.preferredWidth: 200; placeholderText: 'Please select end date' }
    }

    HusSpace {
        layout: 'Row'

        HusInput { width: 200; text: 'input content' }
        HusColorPicker { }
    }
}
```

