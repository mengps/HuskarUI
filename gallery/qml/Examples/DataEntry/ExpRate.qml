import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusRate 评分 \n
用于对事物进行评分操作。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **fillDelegate: Component** 满星代理，代理可访问属性：\n
  - \`index: int\` 当前星星索引\n
  - \`hovered: bool\` 是否悬浮在当前星星上\n
- **emptyDelegate: Component** 空星代理，代理可访问属性：\n
  - \`index: int\` 当前星星索引\n
  - \`hovered: bool\` 是否悬浮在当前星星上\n
- **halfDelegate: Component** 半星代理，代理可访问属性：\n
  - \`index: int\` 当前星星索引\n
  - \`hovered: bool\` 是否悬浮在当前星星上\n
- **toolTipDelegate: Component** 文字提示代理，代理可访问属性：\n
  - \`index: int\` 当前星星索引\n
  - \`hovered: bool\` 是否悬浮在当前星星上\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
hoverCursorShape | enum | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
count | int | 5 | 星星数量
initValue | int | 0 | 初始值
value | int | 0 | 当前值
spacing | int | 4 | 星星间隔
iconSize | int | 24 | 图标大小
toolTipFont | font | - | 文字提示字体
showToolTip | bool | false | 是否显示文字提示
toolTipTexts | list | [] | 文字提示文本列表(长度需等于count)
colorFill | color | - | 满星颜色
colorEmpty | color | - | 空星颜色
colorHalf | color | - | 半星颜色
colorToolTipText | color | - | 文字提示文本颜色
colorToolTipBg | color | - | 文字提示背景颜色
allowHalf | bool | false | 是否允许半星
isDone | bool | false | 是否已经完成评分
fillIcon | int丨string | HusIcon.StarFilled丨'' | 满星图标(来自 HusIcon)或图标链接
emptyIcon | int丨string | HusIcon.StarFilled丨'' | 空星图标(来自 HusIcon)或图标链接
halfIcon | int丨string | HusIcon.StarFilled丨'' | 半星图标(来自 HusIcon)或图标链接
\n<br/>
\n### 支持的信号：\n
- \`done(value: int)\` 完成评分时发出\n
**提供一个半星助手**：\`halfRateHelper\` 可将任意项变为半星\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要对评价进行展示。
- 需要对事物进行快速的评级操作。
                       `)
        }

        ThemeToken {
            source: 'HusRate'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
最简单的用法。\n
通过 \`initValue\` 设置初始评分值。\n
通过 \`value\` 获取当前评分值。\n
通过 \`allowHalf\` 允许选中半星。\n
通过 \`enabled\` 设置是否只读(进行鼠标交互)。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRate {
                        initValue: 3
                    }

                    HusRate {
                        allowHalf: true
                        initValue: 3.5
                    }

                    HusRate {
                        allowHalf: true
                        initValue: 2.5
                        enabled: false
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRate {
                    initValue: 3
                }

                HusRate {
                    allowHalf: true
                    initValue: 3.5
                }

                HusRate {
                    allowHalf: true
                    initValue: 2.5
                    enabled: false
                }
            }
        }

        CodeBox {
            clip: false
            width: parent.width
            desc: qsTr(`
通过 \`showToolTip\` 设置是否显示文字提示。\n
通过 \`toolTipTexts\` 设置文字提示文本列表。\n
**注意** 文字提示并非弹出，需要注意clip。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRate {
                        initValue: 3
                        showToolTip: true
                        toolTipTexts: ['terrible', 'bad', 'normal', 'good', 'wonderful']
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRate {
                    initValue: 3
                    showToolTip: true
                    toolTipTexts: ['terrible', 'bad', 'normal', 'good', 'wonderful']
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`colorFill\` 设置满星颜色。\n
通过 \`colorEmpty\` 设置空星颜色。\n
通过 \`colorHalf\` 设置半星颜色。\n
通过 \`fillIcon\` 设置满星图标。\n
通过 \`emptyIcon\` 设置空星图标。\n
通过 \`halfIcon\` 设置半星图标。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRate {
                        allowHalf: true
                        initValue: 3
                        colorFill: 'red'
                        colorEmpty: 'red'
                        colorHalf: 'red'
                        fillIcon: HusIcon.HeartFilled
                        emptyIcon: HusIcon.HeartOutlined
                        halfIcon: HusIcon.HeartFilled
                    }

                    HusRate {
                        allowHalf: true
                        initValue: 3
                        colorFill: 'green'
                        colorEmpty: 'green'
                        colorHalf: 'green'
                        fillIcon: HusIcon.LikeFilled
                        emptyIcon: HusIcon.LikeOutlined
                        halfIcon: HusIcon.LikeFilled
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRate {
                    allowHalf: true
                    initValue: 3
                    colorFill: 'red'
                    colorEmpty: 'red'
                    colorHalf: 'red'
                    fillIcon: HusIcon.HeartFilled
                    emptyIcon: HusIcon.HeartOutlined
                    halfIcon: HusIcon.HeartFilled
                }

                HusRate {
                    allowHalf: true
                    initValue: 3
                    colorFill: 'green'
                    colorEmpty: 'green'
                    colorHalf: 'green'
                    fillIcon: HusIcon.LikeFilled
                    emptyIcon: HusIcon.LikeOutlined
                    halfIcon: HusIcon.LikeFilled
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`fillDelegate\` 设置满星代理组件。\n
通过 \`emptyDelegate\` 设置空星代理组件。\n
通过 \`halfDelegate\` 设置半星代理组件。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRate {
                        id: custom1
                        initValue: 3
                        colorFill: 'red'
                        fillDelegate: HusText {
                            width: custom1.iconSize
                            height: custom1.iconSize
                            color: custom1.colorFill
                            font {
                                family: HusTheme.Primary.fontPrimaryFamily
                                pixelSize: custom1.iconSize
                            }
                            text: index + 1
                        }
                        emptyDelegate: HusText {
                            width: custom1.iconSize
                            height: custom1.iconSize
                            color: custom1.colorEmpty
                            font {
                                family: HusTheme.Primary.fontPrimaryFamily
                                pixelSize: custom1.iconSize
                            }
                            text: index + 1
                        }
                    }

                    HusRate {
                        id: custom2
                        initValue: 3
                        colorFill: 'red'
                        fillDelegate: HusIconText {
                            iconSource: {
                                if (index <= 2) return HusIcon.FrownOutlined;
                                else if (index == 3) return HusIcon.MehOutlined;
                                else return HusIcon.SmileOutlined;
                            }
                            iconSize: custom2.iconSize
                            color: custom2.colorFill
                            scale: hovered ? 1.1 : 1.0
                        }
                        emptyDelegate: HusIconText {
                            iconSource: {
                                if (index <= 2) return HusIcon.FrownOutlined;
                                else if (index == 3) return HusIcon.MehOutlined;
                                else return HusIcon.SmileOutlined;
                            }
                            iconSize: custom2.iconSize
                            color: custom2.colorEmpty
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRate {
                    id: custom1
                    initValue: 3
                    colorFill: 'red'
                    fillDelegate: HusText {
                        width: custom1.iconSize
                        height: custom1.iconSize
                        color: custom1.colorFill
                        font {
                            family: HusTheme.Primary.fontPrimaryFamily
                            pixelSize: custom1.iconSize
                        }
                        text: index + 1
                    }
                    emptyDelegate: HusText {
                        width: custom1.iconSize
                        height: custom1.iconSize
                        color: custom1.colorEmpty
                        font {
                            family: HusTheme.Primary.fontPrimaryFamily
                            pixelSize: custom1.iconSize
                        }
                        text: index + 1
                    }
                }

                HusRate {
                    id: custom2
                    initValue: 3
                    colorFill: 'red'
                    fillDelegate: HusIconText {
                        iconSource: {
                            if (index <= 2) return HusIcon.FrownOutlined;
                            else if (index == 3) return HusIcon.MehOutlined;
                            else return HusIcon.SmileOutlined;
                        }
                        iconSize: custom2.iconSize
                        color: custom2.colorFill
                        scale: hovered ? 1.1 : 1.0
                    }
                    emptyDelegate: HusIconText {
                        iconSource: {
                            if (index <= 2) return HusIcon.FrownOutlined;
                            else if (index == 3) return HusIcon.MehOutlined;
                            else return HusIcon.SmileOutlined;
                        }
                        iconSize: custom2.iconSize
                        color: custom2.colorEmpty
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
提供一个半星助手：\`halfRateHelper\` 来把任意项变为半星，通过 \`layer.effect\` 来使用它。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRate {
                        id: custom3
                        allowHalf: true
                        initValue: 3.5
                        colorFill: 'green'
                        colorEmpty: 'green'
                        colorHalf: 'green'
                        fillDelegate: Canvas {
                            width: custom3.iconSize
                            height: custom3.iconSize
                            onPaint: {
                                const size = custom3.iconSize * 0.5;
                                custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorFill);
                            }
                        }
                        emptyDelegate: Canvas {
                            width: custom3.iconSize
                            height: custom3.iconSize
                            onPaint: {
                                const size = custom3.iconSize * 0.5;
                                custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorEmpty, false);
                            }
                        }
                        halfDelegate: Canvas {
                            width: custom3.iconSize
                            height: custom3.iconSize
                            onPaint: {
                                const size = custom3.iconSize * 0.5;
                                custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorEmpty, false);
                            }

                            Canvas {
                                width: custom3.iconSize
                                height: custom3.iconSize
                                layer.enabled: true
                                layer.effect: custom3.halfRateHelper
                                onPaint: {
                                    const size = custom3.iconSize * 0.5;
                                    custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorFill);
                                }
                            }
                        }

                        function drawHexagon(ctx, x, y, radius, color, isFill = true) {
                            ctx.beginPath();
                            for (let i = 0; i < 6; i++) {
                                const angle = (i * Math.PI / 3) - Math.PI / 6;
                                const xPos = x + radius * Math.cos(angle);
                                const yPos = y + radius * Math.sin(angle);
                                if (i === 0) {
                                    ctx.moveTo(xPos, yPos);
                                } else {
                                    ctx.lineTo(xPos, yPos);
                                }
                            }
                            ctx.closePath();
                            if (isFill) {
                                ctx.fillStyle = color;
                                ctx.fill();
                            } else {
                                ctx.lineWidth = 1;
                                ctx.strokeStyle = color;
                                ctx.stroke();
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRate {
                    id: custom3
                    allowHalf: true
                    initValue: 3.5
                    colorFill: 'green'
                    colorEmpty: 'green'
                    colorHalf: 'green'
                    fillDelegate: Canvas {
                        width: custom3.iconSize
                        height: custom3.iconSize
                        onPaint: {
                            const size = custom3.iconSize * 0.5;
                            custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorFill);
                        }
                    }
                    emptyDelegate: Canvas {
                        width: custom3.iconSize
                        height: custom3.iconSize
                        onPaint: {
                            const size = custom3.iconSize * 0.5;
                            custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorEmpty, false);
                        }
                    }
                    halfDelegate: Canvas {
                        width: custom3.iconSize
                        height: custom3.iconSize
                        onPaint: {
                            const size = custom3.iconSize * 0.5;
                            custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorEmpty, false);
                        }

                        Canvas {
                            width: custom3.iconSize
                            height: custom3.iconSize
                            layer.enabled: true
                            layer.effect: custom3.halfRateHelper
                            onPaint: {
                                const size = custom3.iconSize * 0.5;
                                custom3.drawHexagon(getContext('2d'), size, size, size - 1, custom3.colorHalf);
                            }
                        }
                    }

                    function drawHexagon(ctx, x, y, radius, color, isFill = true) {
                        ctx.beginPath();
                        for (let i = 0; i < 6; i++) {
                            const angle = (i * Math.PI / 3) - Math.PI / 6;
                            const xPos = x + radius * Math.cos(angle);
                            const yPos = y + radius * Math.sin(angle);
                            if (i === 0) {
                                ctx.moveTo(xPos, yPos);
                            } else {
                                ctx.lineTo(xPos, yPos);
                            }
                        }
                        ctx.closePath();
                        if (isFill) {
                            ctx.fillStyle = color;
                            ctx.fill();
                        } else {
                            ctx.lineWidth = 1;
                            ctx.strokeStyle = color;
                            ctx.stroke();
                        }
                    }
                }
            }
        }
    }
}
