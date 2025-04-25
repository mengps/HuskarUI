import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelDatePicker 日期选择框 \n
输入或选择日期的控件。\n
* **继承自 { Item }**\n
支持的代理：\n
- **dayDelegate: Component** 天项代理\n
  - \`model: var\` 天模型(参见 MonthGrid)\n
  - \`isCurrentWeek: bool\` 是否为当前周\n
  - \`isHoveredWeek: bool\` 是否为悬浮周\n
  - \`isCurrentMonth: bool\` 是否为当前月\n
  - \`isCurrentVisualMonth: bool\` 是否为(==visualMonth)\n
  - \`isCurrentDay: bool\` 是否为当前天\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
placeholderText | string | 输入框占位文本
iconPosition | int | 图标位置(来自 DelDatePicker)
pickerMode | int | 日期选择模式(来自 DelDatePicker)
initDate | date | 初始日期
currentDate | date | 当前日期
currentYear | int | 当前年份
currentMonth | int | 当前月份
currentDay | int |当前天数
currentWeekNumber | int | 当前周数
currentQuarter | int | 当前季度
visualYear | int | 弹窗显示的年份(通常不需要使用)
visualMonth | int | 弹窗显示的月份(通常不需要使用)
visualQuarter | int | 弹窗显示的季度(通常不需要使用)
dateFormat | string | 日期格式
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要输入一个日期，可以点击标准输入框，弹出日期面板进行选择。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法，在浮层中可以选择或者输入日期。
通过 \`pickerMode\` 属性设置选择模式，支持的模式：\n
- 年份选择模式{ DelDatePicker.Mode_Year }\n
- 季度选择模式{ DelDatePicker.Mode_Quarter }\n
- 月选择模式{ DelDatePicker.Mode_Month }\n
- 周选择模式{ DelDatePicker.Mode_Week }\n
- 天选择模式(默认){ DelDatePicker.Mode_Day }\n
通过 \`dateFormat\` 属性设置日期格式：\n
年月日遵从一般日期格式 \`yyyy MM dd\`，而 \`w\` 将替换为周数，\`q\` 将替换为季度。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelDatePicker {
                        placeholderText: qsTr('请选择日期')
                        pickerMode: DelDatePicker.Mode_Day
                        dateFormat: qsTr('yyyy-MM-dd')
                    }

                    DelDatePicker {
                        placeholderText: qsTr('请选择周')
                        pickerMode: DelDatePicker.Mode_Week
                        dateFormat: qsTr('yyyy-w周')
                    }

                    DelDatePicker {
                        placeholderText: qsTr('请选择月份')
                        pickerMode: DelDatePicker.Mode_Month
                        dateFormat: qsTr('yyyy-MM')
                    }

                    DelDatePicker {
                        placeholderText: qsTr('请选择季度')
                        pickerMode: DelDatePicker.Mode_Quarter
                        dateFormat: qsTr('yyyy-Qq')
                    }

                    DelDatePicker {
                        placeholderText: qsTr('请选择年份')
                        pickerMode: DelDatePicker.Mode_Year
                        dateFormat: qsTr('yyyy')
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelDatePicker {
                    placeholderText: qsTr('请选择日期')
                    pickerMode: DelDatePicker.Mode_Day
                    dateFormat: qsTr('yyyy-MM-dd')
                }

                DelDatePicker {
                    placeholderText: qsTr('请选择周')
                    pickerMode: DelDatePicker.Mode_Week
                    dateFormat: qsTr('yyyy-w周')
                }

                DelDatePicker {
                    placeholderText: qsTr('请选择月份')
                    pickerMode: DelDatePicker.Mode_Month
                    dateFormat: qsTr('yyyy-MM')
                }

                DelDatePicker {
                    placeholderText: qsTr('请选择季度')
                    pickerMode: DelDatePicker.Mode_Quarter
                    dateFormat: qsTr('yyyy-Qq')
                }

                DelDatePicker {
                    placeholderText: qsTr('请选择年份')
                    pickerMode: DelDatePicker.Mode_Year
                    dateFormat: qsTr('yyyy')
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义日历')
            desc: qsTr(`
简单创建一个五月带有农历和节日的日历。\n
通过 \`initDate\` 属性设置初始日期。\n
通过 \`dayDelegate\` 属性设置日代理。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelDatePicker {
                        id: customDatePicker
                        initDate: new Date(2025, 4, 1)
                        placeholderText: qsTr('请选择日期')
                        pickerMode: DelDatePicker.Mode_Day
                        dateFormat: qsTr('yyyy-MM-dd')
                        dayDelegate: DelButton {
                            padding: 0
                            implicitWidth: 50
                            implicitHeight: 50
                            type: isCurrentDay || hovered ? DelButton.Type_Primary : DelButton.Type_Link
                            text: \`<span>\${model.day}</span>\${getHoliday()}\`
                            effectEnabled: false
                            colorText: isCurrentDay ? 'white' : DelTheme.Primary.colorTextBase
                            Component.onCompleted: contentItem.textFormat = Text.RichText;

                            function getHoliday() {
                                if (model.month === 4 && model.day === 1) {
                                    return '<br/><span style="color:red">劳动节</span>';
                                } else if (model.month === 4 && model.day === 21) {
                                    return '<br/><span style="color:red">小满</span>';
                                } else if (model.month === 4 && model.day === 31) {
                                    return '<br/><span style="color:red">端午节</span>';
                                }  else {
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
                                        return \`<br/><span style="color:\${colorText}">\${lunarDaysMay2025[model.day - 1]}</span>\`;
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

                DelDatePicker {
                    id: customDatePicker
                    initDate: new Date(2025, 4, 1)
                    placeholderText: qsTr('请选择日期')
                    pickerMode: DelDatePicker.Mode_Day
                    dateFormat: qsTr('yyyy-MM-dd')
                    dayDelegate: DelButton {
                        padding: 0
                        implicitWidth: 50
                        implicitHeight: 50
                        type: isCurrentDay || hovered ? DelButton.Type_Primary : DelButton.Type_Link
                        text: `<span>${model.day}</span>${getHoliday()}`
                        effectEnabled: false
                        colorText: isCurrentDay ? 'white' : DelTheme.Primary.colorTextBase
                        Component.onCompleted: contentItem.textFormat = Text.RichText;

                        function getHoliday() {
                            if (model.month === 4 && model.day === 1) {
                                return '<br/><span style="color:red">劳动节</span>';
                            } else if (model.month === 4 && model.day === 21) {
                                return '<br/><span style="color:red">小满</span>';
                            } else if (model.month === 4 && model.day === 31) {
                                return '<br/><span style="color:red">端午节</span>';
                            }  else {
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
                                    return `<br/><span style="color:${colorText}">${lunarDaysMay2025[model.day - 1]}</span>`;
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
