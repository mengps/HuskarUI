import QtQuick
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
# HusDateTimePickerPanel 日期选择面板 \n
可选择的日期时间面板。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **dayDelegate: Component** 天项代理，代理可访问属性：\n
  - \`model: var\` 天模型(参见 MonthGrid)\n
  - \`isHovered: bool\` 是否悬浮在本项\n
  - \`isCurrentWeek: bool\` 是否为当前周\n
  - \`isHoveredWeek: bool\` 是否为悬浮周\n
  - \`isCurrentMonth: bool\` 是否为当前月\n
  - \`isVisualMonth: bool\` 是否为(==visualMonth)\n
  - \`isCurrentDay: bool\` 是否为当前天\n
  - \`isVisualDay: bool\` 是否为(==visualDay)\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
text | string | '' | 当前日期文本
visualText | string | '' | 视觉日期文本
showNow | bool | false | 显示当前日期时间的快捷选择
showDate | bool | true | 显示日期部分
showTime | bool | true | 显示时间部分
datePickerMode | int | HusDateTimePicker.Mode_Day | 日期选择模式(来自 HusDateTimePicker)
timePickerMode | int | HusDateTimePicker.Mode_HHMMSS | 时间选择模式(来自 HusDateTimePicker)
format | string | 'yyyy-MM-dd hh:mm:ss' | 日期时间格式
prevIconSource | int丨string | HusIcon.LeftOutlined | 往前图标(来自 HusIcon)或图标链接
nextIconSource | int丨string | HusIcon.RightOutlined | 往后图标(来自 HusIcon)或图标链接
superPrevIconSource | int丨string | HusIcon.DoubleLeftOutlined | 加倍往前图标(来自 HusIcon)或图标链接
superNextIconSource | int丨string | HusIcon.DoubleRightOutlined | 加倍往后图标(来自 HusIcon)或图标链接
yearRowSpacing | real | 10 | 年选择项行间隔
yearColumnSpacing | real | 15 | 年选择项列间隔
monthRowSpacing | real | 10 | 月选择项行间隔
monthColumnSpacing | real | 15 | 月选择项列间隔
quarterSpacing | real | 10 | 季度选择项列间隔
initDateTime | date | undefined | 初始日期时间
currentDateTime | date | - | 当前日期时间
currentYear | int | - | 当前年份
currentMonth | int | - | 当前月份
currentDay | int | - | 当前天数
currentWeekNumber | int | - | 当前周数
currentQuarter | int | - | 当前季度
currentHours | int | - | 当前小时数
currentMinutes | int | - | 当前分钟数
currentSeconds | int | - | 当前秒数
visualYear | int | - | 视觉年份(通常不需要使用)
visualMonth | int | - | 视觉月份(通常不需要使用)
visualDay | int | - | 视觉天数(通常不需要使用)
visualWeekNumber | int | - | 视觉周数(通常不需要使用)
visualQuarter | int | - | 视觉季度(通常不需要使用)
visualHours | int | - | 视觉小时(通常不需要使用)
visualMinutes | int | - | 视觉分钟(通常不需要使用)
visualSeconds | int | - | 视觉秒数(通常不需要使用)
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 弹窗圆角
radiusItemBg | [HusRadius](internal://HusRadius) | - | 选择项圆角
sizeHint | string | 'normal' | 尺寸提示
\n<br/>
\n### 支持的函数：\n
- \`clearDateTime()\` 清空当前日期时间 \n
- \`setDateTime(date: jsDate)\` 设置当前日期时间为 \`date\` \n
- \`getDateTime(): jsDate\` 获取当前的日期时间 \n
- \`setDateTimeString(dateTimeString: string)\` 设置当前日期时间字符串为 \`dateTimeString\` \n
- \`getDateTimeString(): string\` 获取当前的日期时间字符串
- \`selectNow()\` 选择现在时间
- \`resetVisualStatus()\` 重置所有视觉状态(即重置visual为current)
\n<br/>
\n### 支持的信号：\n
- \`selected(date: jsDate)\` 选择日期时间时发出\n
  -  \`date\` 选择的日期时间\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要一个可以点击的日期面板进行选择时。\n
                       `)
        }

        ThemeToken {
            source: 'HusDateTimePicker'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
基本用法在 [HusDateTimePicker](internal://HusDateTimePicker) 中已有示例。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSwitch {
                        id: showNowSwitch
                        text: 'showNow: '
                        checked: false
                    }

                    HusSwitch {
                        id: showDateSwitch
                        text: 'showDate: '
                        checked: true
                    }

                    HusSwitch {
                        id: showTimeSwitch
                        text: 'showTime: '
                        checked: false
                    }

                    HusRadioBlock {
                        id: sizeHintRadio
                        initCheckedIndex: 1
                        model: [
                            { label: 'Small', value: 'small' },
                            { label: 'Normal', value: 'normal' },
                            { label: 'Large', value: 'large' },
                        ]
                    }

                    HusDateTimePickerPanel {
                        showNow: showNowSwitch.checked
                        showDate: showDateSwitch.checked
                        showTime: showTimeSwitch.checked
                        format: qsTr('yyyy-MM-dd hh:mm:ss')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSwitch {
                    id: showNowSwitch
                    text: 'showNow: '
                    checked: false
                }

                HusSwitch {
                    id: showDateSwitch
                    text: 'showDate: '
                    checked: true
                }

                HusSwitch {
                    id: showTimeSwitch
                    text: 'showTime: '
                    checked: false
                }

                HusRadioBlock {
                    id: sizeHintRadio
                    initCheckedIndex: 1
                    model: [
                        { label: 'Small', value: 'small' },
                        { label: 'Normal', value: 'normal' },
                        { label: 'Large', value: 'large' },
                    ]
                }

                HusDateTimePickerPanel {
                    showNow: showNowSwitch.checked
                    showDate: showDateSwitch.checked
                    showTime: showTimeSwitch.checked
                    format: qsTr('yyyy-MM-dd hh:mm:ss')
                    sizeHint: sizeHintRadio.currentCheckedValue
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义日历')
            desc: qsTr(`
简单创建一个五月带有农历和节日的日历。\n
通过 \`initDateTime\` 属性设置初始日期时间。\n
通过 \`dayDelegate\` 属性设置日代理。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusDateTimePickerPanel {
                        width: 410
                        height: 340
                        initDateTime: new Date(2025, 4, 1)
                        datePickerMode: HusDateTimePicker.Mode_Day
                        showTime: false
                        format: qsTr('yyyy-MM-dd')
                        yearRowSpacing: 30
                        yearColumnSpacing: 40
                        monthRowSpacing: 30
                        monthColumnSpacing: 40
                        dayDelegate: HusButton {
                            implicitWidth: 40
                            implicitHeight: 36
                            font.pixelSize: parseInt(HusTheme.Primary.fontPrimarySize) - 2
                            type: isCurrentDay || isHovered ? HusButton.Type_Primary : HusButton.Type_Link
                            text: \`<span>\${model.day}</span>\${getHoliday()}\`
                            effectEnabled: false
                            colorText: isCurrentDay ? 'white' : HusTheme.Primary.colorTextBase
                            Component.onCompleted: contentItem.textFormat = Text.RichText;

                            function getHoliday() {
                                if (model.month === 4 && model.day === 1) {
                                    return \`<br/><span style=\'color:red\'>劳动节</span>\`;
                                } else if (model.month === 4 && model.day === 21) {
                                    return \`<br/><span style=\'color:red\'>小满</span>\`;
                                } else if (model.month === 4 && model.day === 31) {
                                    return \`<br/><span style=\'color:red\'>端午节</span>\`;
                                } else {
                                    const lunarDaysMay2025 = [
                                      '初四', '初五', '初六', '初七', '初八',
                                      '初九', '初十', '十一', '十二', '十三',
                                      '十四', '十五', '十六', '十七', '十八',
                                      '十九', '二十', '廿一', '廿二', '廿三',
                                      '廿四', '廿五', '廿六', '廿七', '廿八',
                                      '廿九', '三十', '初一', '初二', '初三',
                                      '初四'
                                    ];
                                    if (model.month === 4)
                                        return \`<br/><span style='color:\${colorText}'>\${lunarDaysMay2025[model.day - 1]}</span>\`;
                                    else
                                        return '';
                                }
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusDateTimePickerPanel {
                    width: 410
                    height: 340
                    showTime: false
                    initDateTime: new Date(2025, 4, 1)
                    datePickerMode: HusDateTimePicker.Mode_Day
                    format: qsTr('yyyy-MM-dd')
                    yearRowSpacing: 30
                    yearColumnSpacing: 40
                    monthRowSpacing: 30
                    monthColumnSpacing: 40
                    dayDelegate: HusButton {
                        implicitWidth: 40
                        implicitHeight: 36
                        font.pixelSize: parseInt(HusTheme.Primary.fontPrimarySize) - 2
                        type: isCurrentDay || isHovered ? HusButton.Type_Primary : HusButton.Type_Link
                        text: `<span>${model.day}</span>${getHoliday()}`
                        effectEnabled: false
                        colorText: isVisualMonth ? (isCurrentDay ? 'white' : HusTheme.Primary.colorTextBase) : HusTheme.Primary.colorTextQuaternary
                        Component.onCompleted: contentItem.textFormat = Text.RichText;

                        function getHoliday() {
                            if (model.month === 4 && model.day === 1) {
                                return `<br/><span style=\'color:red\'>劳动节</span>`;
                            } else if (model.month === 4 && model.day === 21) {
                                return `<br/><span style=\'color:red\'>小满</span>`;
                            } else if (model.month === 4 && model.day === 31) {
                                return `<br/><span style=\'color:red\'>端午节</span>`;
                            } else {
                                const lunarDaysMay2025 = [
                                  '初四', '初五', '初六', '初七', '初八',
                                  '初九', '初十', '十一', '十二', '十三',
                                  '十四', '十五', '十六', '十七', '十八',
                                  '十九', '二十', '廿一', '廿二', '廿三',
                                  '廿四', '廿五', '廿六', '廿七', '廿八',
                                  '廿九', '三十', '初一', '初二', '初三',
                                  '初四'
                                ];
                                if (model.month === 4)
                                    return `<br/><span style='color:${colorText}'>${lunarDaysMay2025[model.day - 1]}</span>`;
                                else
                                    return '';
                            }
                        }
                    }
                }
            }
        }
    }
}
