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

        DocDescription {
            desc: qsTr(`
# HusDateTimePicker 日期选择框 \n
输入或选择日期时间的控件。\n
* **继承自 { [HusInput](internal://HusInput) }**\n
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
locale | Locale | - | 区域设置
radiusItemBg | [HusRadius](internal://HusRadius) | - | 选择项圆角
radiusPopupBg | [HusRadius](internal://HusRadius) | - | 弹窗圆角
popup | [HusPopup](internal://HusPopup) | - | 访问内部弹窗
panel | [HusDateTimePickerPanel](internal://HusDateTimePickerPanel) | - | 访问内部日期时间选择面板
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
当用户需要输入一个日期，可以点击标准输入框，弹出日期面板进行选择。\n
                       `)
        }

        ThemeToken {
            source: 'HusDateTimePicker'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusDateTimePicker.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法，在浮层中可以选择或者输入日期。\n
通过 \`showDate\` 属性设置是否显示日期选择部分。\n
通过 \`showTime\` 属性设置是否显示时间选择部分。\n
通过 \`datePickerMode\` 属性设置日期选择模式，支持的模式：\n
- 年份选择模式{ HusDateTimePicker.Mode_Year }\n
- 季度选择模式{ HusDateTimePicker.Mode_Quarter }\n
- 月选择模式{ HusDateTimePicker.Mode_Month }\n
- 周选择模式{ HusDateTimePicker.Mode_Week }\n
- 天选择模式(默认){ HusDateTimePicker.Mode_Day }\n
通过 \`timePickerMode\` 属性设置时间选择模式，支持的模式：\n
- 小时分钟秒{hh:mm:ss}(默认){ HusDateTimePicker.Mode_HHMMSS }\n
- 小时分钟{hh:mm}{ HusDateTimePicker.Mode_HHMM }\n
- 分钟秒{mm:ss}{ HusDateTimePicker.Mode_MMSS }\n
通过 \`format\` 属性设置日期时间格式：\n
年月日时分秒遵从一般日期格式 \`yyyy MM dd hh mm ss\`，而 \`w\` 将替换为周数，\`q\` 将替换为季度。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRadioBlock {
                        id: sizeHintRadio
                        initCheckedIndex: 1
                        model: [
                            { label: 'Small', value: 'small' },
                            { label: 'Normal', value: 'normal' },
                            { label: 'Large', value: 'large' },
                        ]
                    }

                    HusDateTimePicker {
                        placeholderText: qsTr('请选择日期时间')
                        format: qsTr('yyyy-MM-dd hh:mm:ss')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }

                    HusDateTimePicker {
                        placeholderText: qsTr('请选择日期')
                        datePickerMode: HusDateTimePicker.Mode_Day
                        showTime: false
                        format: qsTr('yyyy-MM-dd')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }

                    HusDateTimePicker {
                        placeholderText: qsTr('请选择周')
                        datePickerMode: HusDateTimePicker.Mode_Week
                        showTime: false
                        format: qsTr('yyyy-w周')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }

                    HusDateTimePicker {
                        placeholderText: qsTr('请选择月份')
                        datePickerMode: HusDateTimePicker.Mode_Month
                        showTime: false
                        format: qsTr('yyyy-MM')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }

                    HusDateTimePicker {
                        placeholderText: qsTr('请选择季度')
                        datePickerMode: HusDateTimePicker.Mode_Quarter
                        showTime: false
                        format: qsTr('yyyy-Qq')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }

                    HusDateTimePicker {
                        placeholderText: qsTr('请选择年份')
                        datePickerMode: HusDateTimePicker.Mode_Year
                        showTime: false
                        format: qsTr('yyyy')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }

                    HusDateTimePicker {
                        placeholderText: qsTr('请选择时间')
                        showDate: false
                        timePickerMode: HusDateTimePicker.Mode_HHMMSS
                        format: qsTr('hh:mm:ss')
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRadioBlock {
                    id: sizeHintRadio
                    initCheckedIndex: 1
                    model: [
                        { label: 'Small', value: 'small' },
                        { label: 'Normal', value: 'normal' },
                        { label: 'Large', value: 'large' },
                    ]
                }

                HusDateTimePicker {
                    placeholderText: qsTr('请选择日期时间')
                    format: qsTr('yyyy-MM-dd hh:mm:ss')
                    sizeHint: sizeHintRadio.currentCheckedValue
                    onSelected: (date) => print(getDateTimeString())
                }

                HusDateTimePicker {
                    placeholderText: qsTr('请选择日期')
                    datePickerMode: HusDateTimePicker.Mode_Day
                    showTime: false
                    format: qsTr('yyyy-MM-dd')
                    sizeHint: sizeHintRadio.currentCheckedValue
                }

                HusDateTimePicker {
                    placeholderText: qsTr('请选择周')
                    datePickerMode: HusDateTimePicker.Mode_Week
                    showTime: false
                    format: qsTr('yyyy-w周')
                    sizeHint: sizeHintRadio.currentCheckedValue
                }

                HusDateTimePicker {
                    placeholderText: qsTr('请选择月份')
                    datePickerMode: HusDateTimePicker.Mode_Month
                    showTime: false
                    format: qsTr('yyyy-MM')
                    sizeHint: sizeHintRadio.currentCheckedValue
                }

                HusDateTimePicker {
                    placeholderText: qsTr('请选择季度')
                    datePickerMode: HusDateTimePicker.Mode_Quarter
                    showTime: false
                    format: qsTr('yyyy-Qq')
                    sizeHint: sizeHintRadio.currentCheckedValue
                }

                HusDateTimePicker {
                    placeholderText: qsTr('请选择年份')
                    datePickerMode: HusDateTimePicker.Mode_Year
                    showTime: false
                    format: qsTr('yyyy')
                    sizeHint: sizeHintRadio.currentCheckedValue
                }

                HusDateTimePicker {
                    placeholderText: qsTr('请选择时间')
                    showDate: false
                    timePickerMode: HusDateTimePicker.Mode_HHMMSS
                    format: qsTr('hh:mm:ss')
                    sizeHint: sizeHintRadio.currentCheckedValue
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('任意选择时分秒部分')
            desc: qsTr(`
可任意选择小时分钟秒/小时分钟/分钟秒三种模式。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 10

                    HusDateTimePicker {
                        showDate: false
                        timePickerMode: HusDateTimePicker.Mode_HHMMSS
                        format: 'hh:mm:ss'
                    }

                    HusDateTimePicker {
                        showDate: false
                        timePickerMode: HusDateTimePicker.Mode_HHMM
                        format: 'hh:mm'
                    }

                    HusDateTimePicker {
                        showDate: false
                        timePickerMode: HusDateTimePicker.Mode_MMSS
                        format: 'mm:ss'
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusDateTimePicker {
                    showDate: false
                    timePickerMode: HusDateTimePicker.Mode_HHMMSS
                    format: 'hh:mm:ss'
                }

                HusDateTimePicker {
                    showDate: false
                    timePickerMode: HusDateTimePicker.Mode_HHMM
                    format: 'hh:mm'
                }

                HusDateTimePicker {
                    showDate: false
                    timePickerMode: HusDateTimePicker.Mode_MMSS
                    format: 'mm:ss'
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

                    HusDateTimePicker {
                        id: customDatePicker
                        initDateTime: new Date(2025, 4, 1)
                        placeholderText: qsTr('请选择日期')
                        datePickerMode: HusDateTimePicker.Mode_Day
                        showTime: false
                        format: qsTr('yyyy-MM-dd')
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

                HusDateTimePicker {
                    id: customDatePicker
                    format: qsTr('yyyy-MM-dd')
                    initDateTime: new Date(2025, 4, 1)
                    placeholderText: qsTr('请选择日期')
                    datePickerMode: HusDateTimePicker.Mode_Day
                    showTime: false
                    dayDelegate: HusButton {
                        implicitWidth: 40
                        implicitHeight: 36
                        font.pixelSize: parseInt(HusTheme.Primary.fontPrimarySize) - 2
                        type: isCurrentDay || isHovered ? HusButton.Type_Primary : HusButton.Type_Link
                        text: `<span>${model.day}</span>${getHoliday()}`
                        effectEnabled: false
                        colorText: isCurrentDay ? 'white' : HusTheme.Primary.colorTextBase
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
