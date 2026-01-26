[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSwitchEffect 切换效果 


两个组件之间的切换/过渡效果。

* **模块 { HuskarUI.Basic }**

* **继承自 { Item }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
fromItem | Item | - | 从项目
toItem | Item | - | 到项目
startCallback | function | ()=>void | 开始回调(started信号之前调用)
endCallback | function | function() | 结束回调(finished信号之前调用)
type | enum | - | 特效类型(来自 HusSwitchEffect)
duration | int | 800 | 特效持续时间(毫秒)
easing | QEasingCurve | - | 缓动曲线
maskSource | string | '' | 遮罩源
maskScaleEnabled | bool | false | 是否启用遮罩缩放
maskScale | real | 1.0 | 遮罩缩放
maskRotationEnabled | bool | false | 是否启用遮罩旋转
maskRotation | real | 0 | 遮罩旋转角度
maskColorizationEnabled | bool | false | 是否启用遮罩源着色
maskColorizationColor | color | 'red' | 着色颜色
maskColorization | real | 0 | 着色强度(0.0~1.0)

<br/>

### 支持的函数：

- `startSwitch(from = null, to = null)` 特效开始从 `from` 项切换到 `to`。


<br/>

### 支持的信号：

- `started()` 动画开始时发出

- `finished()` 动画结束时发出


<br/>

## 代码演示

### 示例 1

通过 `type` 属性设置特效类型，支持的类型：

- 无{ HusSwitchEffect.Type_None }

- 透明度特效{ HusSwitchEffect.Type_Opacity }

- 模糊特效{ HusSwitchEffect.Type_Blurry }

- 遮罩特效{ HusSwitchEffect.Type_Mask }

- 百叶窗特效{ HusSwitchEffect.Type_Blinds }

- 3D翻转特效{ HusSwitchEffect.Type_3DFlip }

- 雷电特效{ HusSwitchEffect.Type_Thunder }

通过 `duration` 属性设置特效持续时间(毫秒)。

通过 `startSwitch` 函数开始切换。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusButton {
        id: startButton
        leftPadding: 20
        rightPadding: 20
        text: qsTr('开始')
        type: HusButton.Type_Primary
        onClicked: {
            direction = !direction;
            if (direction) {
                switchEffect.startSwitch(item1, item2)
            } else {
                switchEffect.startSwitch(item2, item1)
            }
        }
        property bool direction: false
    }

    Row {
        height: 30
        spacing: 10

        HusText {
            text: qsTr('持续时间')
            anchors.verticalCenter: parent.verticalCenter
        }

        HusSlider {
            id: durationSlider
            width: 240
            height: parent.height
            min: 0
            max: 3000
            value: 1500
        }

        HusText {
            text: durationSlider.currentValue.toFixed(0)
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    HusRadioBlock {
        id: effectType
        initCheckedIndex: 0
        model: [
            { 'label': qsTr('无'), 'value': HusSwitchEffect.Type_None, 'duration': 0 },
            { 'label': qsTr('透明度特效'), 'value': HusSwitchEffect.Type_Opacity, 'duration': 800 },
            { 'label': qsTr('模糊特效'), 'value': HusSwitchEffect.Type_Blurry, 'duration': 1200 },
            {
                'label': qsTr('遮罩特效'),
                'value': HusSwitchEffect.Type_Mask,
                'duration': 1500,
                'maskScaleEnabled': true,
                'maskRotationEnabled': true,
                'maskSource': 'qrc:/HuskarUI/resources/images/star.png',
            },
            {
                'label': qsTr('百叶窗特效'),
                'value': HusSwitchEffect.Type_Blinds,
                'duration': 1500,
            },
            {
                'label': qsTr('3D翻转特效'),
                'value': HusSwitchEffect.Type_3DFlip,
                'duration': 1500,
            },
            {
                'label': qsTr('雷电特效'),
                'value': HusSwitchEffect.Type_Thunder,
                'duration': 1500,
            },
        ]
        onClicked: function(index, radioData) {
            switchEffect.type = radioData.value;
            switchEffect.maskScaleEnabled = radioData.maskScaleEnabled ?? false;
            switchEffect.maskRotationEnabled = radioData.maskRotationEnabled ?? false;
            switchEffect.maskSource = radioData.maskSource || '';
            durationSlider.value = radioData.duration;
        }
    }

    Item {
        width: parent.width
        height: 500

        Image {
            id: item1
            width: parent.width
            height: parent.height
            source: 'qrc:/Gallery/images/switch_effect1.jpg'
            visible: true
        }

        Image {
            id: item2
            width: parent.width
            height: parent.height
            source: 'qrc:/Gallery/images/switch_effect2.jpg'
            visible: false
        }

        HusSwitchEffect {
            id: switchEffect
            anchors.fill: parent
            duration: durationSlider.currentValue
            maskScale: animationTime * 3
            maskRotation: (1.0 - animationTime) * 360
            onFinished: {
                item1.visible = !startButton.direction;
                item2.visible = startButton.direction;
            }
        }
    }
}
```

