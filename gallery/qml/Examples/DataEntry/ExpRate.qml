import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelRate 评分 \n
用于对事物进行评分操作。\n
* **继承自 { Item }**\n
支持的代理：\n
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
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
hoverCursorShape | int | 悬浮时鼠标形状(来自 Qt.*Cursor)
count | int | 星星数量
initValue | int | 初始值
value | int | 当前值
spacing | int | 星星间隔
iconSize | int | 图标大小
toolTipFont | font | 文字提示字体
toolTipVisible | bool | 是否显示文字提示(默认false)
toolTipTexts | list | 文字提示文本列表(长度需等于count)
colorFill | color | 满星颜色
colorEmpty | color | 空星颜色
colorHalf | color | 半星颜色
colorToolTipText | color | 文字提示文本颜色
colorToolTipBg | color | 文字提示背景颜色
allowHalf | bool | 是否允许半星(默认false)
isDone | bool | 是否已经完成评分
fillIcon | enum | 满星图标(来自 DelIcon)
emptyIcon | enum | 空星图标(来自 DelIcon)
halfIcon | enum | 半星图标(来自 DelIcon)
\n支持的信号：\n
- \`done(value: int)\` 完成评分时发出\n
**提供一个半星助手**：\`halfRateHelper\` 可将任意项变为半星\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 需要对评价进行展示。
- 需要对事物进行快速的评级操作。
                       `)
        }

        Description {
            title: qsTr("代码演示")
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
                import DelegateUI

                Column {
                    spacing: 10

                    DelRate {
                        initValue: 3
                    }

                    DelRate {
                        allowHalf: true
                        initValue: 3.5
                    }

                    DelRate {
                        allowHalf: true
                        initValue: 2.5
                        enabled: false
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRate {
                    initValue: 3
                }

                DelRate {
                    allowHalf: true
                    initValue: 3.5
                }

                DelRate {
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
通过 \`toolTipVisible\` 设置是否显示文字提示。\n
通过 \`toolTipTexts\` 设置文字提示文本列表。\n
**注意** 文字提示并非弹出，需要注意clip。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelRate {
                        initValue: 3
                        toolTipVisible: true
                        toolTipTexts: ['terrible', 'bad', 'normal', 'good', 'wonderful']
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRate {
                    initValue: 3
                    toolTipVisible: true
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
                import DelegateUI

                Column {
                    spacing: 10

                    DelRate {
                        allowHalf: true
                        initValue: 3
                        colorFill: "red"
                        colorEmpty: "red"
                        colorHalf: "red"
                        fillIcon: DelIcon.HeartFilled
                        emptyIcon: DelIcon.HeartOutlined
                        halfIcon: DelIcon.HeartFilled
                    }

                    DelRate {
                        allowHalf: true
                        initValue: 3
                        colorFill: "green"
                        colorEmpty: "green"
                        colorHalf: "green"
                        fillIcon: DelIcon.LikeFilled
                        emptyIcon: DelIcon.LikeOutlined
                        halfIcon: DelIcon.LikeFilled
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRate {
                    allowHalf: true
                    initValue: 3
                    colorFill: "red"
                    colorEmpty: "red"
                    colorHalf: "red"
                    fillIcon: DelIcon.HeartFilled
                    emptyIcon: DelIcon.HeartOutlined
                    halfIcon: DelIcon.HeartFilled
                }

                DelRate {
                    allowHalf: true
                    initValue: 3
                    colorFill: "green"
                    colorEmpty: "green"
                    colorHalf: "green"
                    fillIcon: DelIcon.LikeFilled
                    emptyIcon: DelIcon.LikeOutlined
                    halfIcon: DelIcon.LikeFilled
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
                import DelegateUI

                Column {
                    spacing: 10

                    DelRate {
                        id: custom1
                        initValue: 3
                        colorFill: "red"
                        fillDelegate: Text {
                            width: custom1.iconSize
                            height: custom1.iconSize
                            color: custom1.colorFill
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: custom1.iconSize
                            }
                            text: index + 1
                        }
                        emptyDelegate: Text {
                            width: custom1.iconSize
                            height: custom1.iconSize
                            color: custom1.colorEmpty
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: custom1.iconSize
                            }
                            text: index + 1
                        }
                    }

                    DelRate {
                        id: custom2
                        initValue: 3
                        colorFill: "red"
                        fillDelegate: DelIconText {
                            iconSource: {
                                if (index <= 2) return DelIcon.FrownOutlined;
                                else if (index == 3) return DelIcon.MehOutlined;
                                else return DelIcon.SmileOutlined;
                            }
                            iconSize: custom2.iconSize
                            color: custom2.colorFill
                            scale: hovered ? 1.1 : 1.0
                        }
                        emptyDelegate: DelIconText {
                            iconSource: {
                                if (index <= 2) return DelIcon.FrownOutlined;
                                else if (index == 3) return DelIcon.MehOutlined;
                                else return DelIcon.SmileOutlined;
                            }
                            iconSize: custom2.iconSize
                            color: custom2.colorEmpty
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRate {
                    id: custom1
                    initValue: 3
                    colorFill: "red"
                    fillDelegate: Text {
                        width: custom1.iconSize
                        height: custom1.iconSize
                        color: custom1.colorFill
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: custom1.iconSize
                        }
                        text: index + 1
                    }
                    emptyDelegate: Text {
                        width: custom1.iconSize
                        height: custom1.iconSize
                        color: custom1.colorEmpty
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: custom1.iconSize
                        }
                        text: index + 1
                    }
                }

                DelRate {
                    id: custom2
                    initValue: 3
                    colorFill: "red"
                    fillDelegate: DelIconText {
                        iconSource: {
                            if (index <= 2) return DelIcon.FrownOutlined;
                            else if (index == 3) return DelIcon.MehOutlined;
                            else return DelIcon.SmileOutlined;
                        }
                        iconSize: custom2.iconSize
                        color: custom2.colorFill
                        scale: hovered ? 1.1 : 1.0
                    }
                    emptyDelegate: DelIconText {
                        iconSource: {
                            if (index <= 2) return DelIcon.FrownOutlined;
                            else if (index == 3) return DelIcon.MehOutlined;
                            else return DelIcon.SmileOutlined;
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
                import DelegateUI

                Column {
                    spacing: 10

                    DelRate {
                        id: custom3
                        allowHalf: true
                        initValue: 3.5
                        colorFill: "green"
                        colorEmpty: "green"
                        colorHalf: "green"
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

                DelRate {
                    id: custom3
                    allowHalf: true
                    initValue: 3.5
                    colorFill: "green"
                    colorEmpty: "green"
                    colorHalf: "green"
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
