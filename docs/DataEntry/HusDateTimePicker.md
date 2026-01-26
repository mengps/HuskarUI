[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusDateTimePicker 日期选择框 


输入或选择日期时间的控件。

* **继承自 { [HusInput](./HusInput.md) }**


<br/>

### 支持的代理：

- **dayDelegate: Component** 天项代理，代理可访问属性：

  - `model: var` 天模型(参见 MonthGrid)

  - `isHovered: bool` 是否悬浮在本项

  - `isCurrentWeek: bool` 是否为当前周

  - `isHoveredWeek: bool` 是否为悬浮周

  - `isCurrentMonth: bool` 是否为当前月

  - `isVisualMonth: bool` 是否为(==visualMonth)

  - `isCurrentDay: bool` 是否为当前天

  - `isVisualDay: bool` 是否为(==visualDay)


<br/>

### 支持的属性：

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
radiusItemBg | [HusRadius](../General/HusRadius.md) | - | 选择项圆角
radiusPopupBg | [HusRadius](../General/HusRadius.md) | - | 弹窗圆角
popup | [HusPopup](../General/HusPopup.md) | - | 访问内部弹窗
panel | [HusDateTimePickerPanel](./HusDateTimePickerPanel.md) | - | 访问内部日期时间选择面板

<br/>

### 支持的函数：

- `clearDateTime()` 清空当前日期时间 

- `setDateTime(date: jsDate)` 设置当前日期时间为 `date` 

- `getDateTime(): jsDate` 获取当前的日期时间 

- `setDateTimeString(dateTimeString: string)` 设置当前日期时间字符串为 `dateTimeString` 

- `getDateTimeString(): string` 获取当前的日期时间字符串
- `selectNow()` 选择现在时间
- `resetVisualStatus()` 重置所有视觉状态(即重置visual为current)

<br/>

### 支持的信号：

- `selected(date: jsDate)` 选择日期时间时发出

  -  `date` 选择的日期时间


<br/>

## 代码演示

### 示例 1 - 基本

最简单的用法，在浮层中可以选择或者输入日期。

通过 `showDate` 属性设置是否显示日期选择部分。

通过 `showTime` 属性设置是否显示时间选择部分。

通过 `datePickerMode` 属性设置日期选择模式，支持的模式：

- 年份选择模式{ HusDateTimePicker.Mode_Year }

- 季度选择模式{ HusDateTimePicker.Mode_Quarter }

- 月选择模式{ HusDateTimePicker.Mode_Month }

- 周选择模式{ HusDateTimePicker.Mode_Week }

- 天选择模式(默认){ HusDateTimePicker.Mode_Day }

通过 `timePickerMode` 属性设置时间选择模式，支持的模式：

- 小时分钟秒{hh:mm:ss}(默认){ HusDateTimePicker.Mode_HHMMSS }

- 小时分钟{hh:mm}{ HusDateTimePicker.Mode_HHMM }

- 分钟秒{mm:ss}{ HusDateTimePicker.Mode_MMSS }

通过 `format` 属性设置日期时间格式：

年月日时分秒遵从一般日期格式 `yyyy MM dd hh mm ss`，而 `w` 将替换为周数，`q` 将替换为季度。


```qml
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
```

---

### 示例 2 - 任意选择时分秒部分

可任意选择小时分钟秒/小时分钟/分钟秒三种模式。


```qml
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
```

---

### 示例 3 - 自定义日历

简单创建一个五月带有农历和节日的日历。

通过 `initDateTime` 属性设置初始日期时间。

通过 `dayDelegate` 属性设置日代理。


```qml
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
            text: `<span>\${model.day}</span>\${getHoliday()}`
            effectEnabled: false
            colorText: isCurrentDay ? 'white' : HusTheme.Primary.colorTextBase
            Component.onCompleted: contentItem.textFormat = Text.RichText;

            function getHoliday() {
                if (model.month === 4 && model.day === 1) {
                    return `<br/><span style='color:red'>劳动节</span>`;
                } else if (model.month === 4 && model.day === 21) {
                    return `<br/><span style='color:red'>小满</span>`;
                } else if (model.month === 4 && model.day === 31) {
                    return `<br/><span style='color:red'>端午节</span>`;
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
                        return `<br/><span style='color:\${colorText}'>\${lunarDaysMay2025[model.day - 1]}</span>`;
                    else
                        return '';
                }
            }
        }
    }
}
```

