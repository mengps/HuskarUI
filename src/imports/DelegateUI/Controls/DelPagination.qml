import QtQuick
import DelegateUI

Item {
    id: control

    width: __row.width
    height: __row.height

    property bool animationEnabled: DelTheme.animationEnabled
    property int defaultButtonWidth: 32
    property int defaultButtonHeight: 32
    property int defaultButtonSpacing: 8
    property bool showQuickJumper: false
    property int currentPageIndex: 0
    property int total: 0
    property int pageTotal: pageSize > 0 ? Math.ceil(total / pageSize) : 0
    property int pageButtonMaxCount: 7
    property int pageSize: 10
    property var pageSizeModel: []
    property string prevButtonTooltip: qsTr("上一页")
    property string nextButtonTooltip: qsTr("下一页")
    property Component prevButtonDelegate: ActionButton {
        iconSource: DelIcon.LeftOutlined
        tooltipText: control.prevButtonTooltip
        disabled: control.currentPageIndex == 0
        onClicked: control.gotoPrevPage();
    }
    property Component nextButtonDelegate: ActionButton {
        iconSource: DelIcon.RightOutlined
        tooltipText: control.nextButtonTooltip
        disabled: control.currentPageIndex == (control.pageTotal - 1)
        onClicked: control.gotoNextPage();
    }
    property Component quickJumperDelegate: Row {
        height: control.defaultButtonHeight
        spacing: control.defaultButtonSpacing

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("跳至")
            font {
                family: DelTheme.DelCopyableText.fontFamily
                pixelSize: DelTheme.DelCopyableText.fontSize
            }
            color: DelTheme.Primary.colorTextBase
        }

        DelInput {
            width: 48
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: DelInput.AlignHCenter
            animationEnabled: control.animationEnabled
            enabled: control.enabled
            validator: IntValidator { top: 99999; bottom: 0 }
            onEditingFinished: {
                control.gotoPageIndex(parseInt(text) - 1);
                clear();
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("页")
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySize
            }
            color: DelTheme.Primary.colorTextBase
        }
    }

    Component.onCompleted: currentPageIndexChanged();

    onPageSizeChanged: {
        const __pageTotal = (pageSize > 0 ? Math.ceil(total / pageSize) : 0);
        if (currentPageIndex > __pageTotal) {
            currentPageIndex = __pageTotal - 1;
        }
    }

    function gotoPageIndex(index: int) {
        if (index <= 0)
            control.currentPageIndex = 0;
        else if (index < pageTotal)
            control.currentPageIndex = index;
        else
            control.currentPageIndex = (pageTotal - 1);
    }

    function gotoPrevPage() {
        if (currentPageIndex > 0)
            currentPageIndex--;
    }

    function gotoPrev5Page() {
        if (currentPageIndex > 5)
            currentPageIndex -= 5;
        else
            currentPageIndex = 0;
    }

    function gotoNextPage() {
        if (currentPageIndex < pageTotal)
            currentPageIndex++;
    }

    function gotoNext5Page() {
        if ((currentPageIndex + 5) < pageTotal)
            currentPageIndex += 5;
        else
            currentPageIndex = pageTotal - 1;
    }

    component PaginationButton: DelButton {
        padding: 0
        width: control.defaultButtonWidth
        height: control.defaultButtonHeight
        animationEnabled: false
        effectEnabled: false
        enabled: control.enabled
        text: (pageIndex + 1)
        checked: control.currentPageIndex == pageIndex
        font.bold: checked
        colorText: {
            if (enabled)
                return checked ? DelTheme.DelPagination.colorButtonTextActive : DelTheme.DelPagination.colorButtonText;
            else
                return DelTheme.DelPagination.colorButtonTextDisabled;
        }
        colorBg: {
            if (enabled) {
                if (checked)
                    return DelTheme.DelPagination.colorButtonBg;
                else
                    return down ? DelTheme.DelPagination.colorButtonBgActive :
                                  hovered ? DelTheme.DelPagination.colorButtonBgHover :
                                            DelTheme.DelPagination.colorButtonBg;
            } else {
                return checked ? DelTheme.DelPagination.colorButtonBgDisabled : "transparent";
            }
        }
        colorBorder: checked ? DelTheme.DelPagination.colorBorderActive : "transparent"
        onClicked: {
            control.currentPageIndex = pageIndex;
        }
        property int pageIndex: 0

        Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }

        DelToolTip {
            arrowVisible: false
            text: parent.text
            visible: parent.hovered && parent.enabled
        }
    }

    component PaginationMoreButton: DelIconButton {
        padding: 0
        width: control.defaultButtonWidth
        height: control.defaultButtonHeight
        animationEnabled: control.animationEnabled
        effectEnabled: false
        enabled: control.enabled
        colorBg: "transparent"
        colorBorder: "transparent"
        
        property real textOpacity: (enabled && (down || hovered)) ? 0.0 : 1.0
        property real iconOpacity: (enabled && (down || hovered)) ? 1.0 : 0.0
        
        text: "•••"
        iconSource: (isPrev ? DelIcon.DoubleLeftOutlined : DelIcon.DoubleRightOutlined)
        property bool isPrev: false
        property alias tooltipText: __moreTooltip.text

        Behavior on textOpacity { 
            enabled: control.animationEnabled
            NumberAnimation { 
                duration: DelTheme.Primary.durationMid
                easing.type: Easing.OutCubic
            } 
        }
        Behavior on iconOpacity { 
            enabled: control.animationEnabled
            NumberAnimation { 
                duration: DelTheme.Primary.durationMid
                easing.type: Easing.OutCubic
            } 
        }

        contentItem: Item {
            Text {
                anchors.centerIn: parent
                text: parent.parent.text
                font: parent.parent.font
                color: parent.parent.enabled ? DelTheme.DelPagination.colorButtonText : DelTheme.DelPagination.colorButtonTextDisabled
                opacity: parent.parent.textOpacity
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            DelIconText {
                anchors.centerIn: parent
                iconSource: parent.parent.iconSource
                iconSize: 12
                colorIcon: parent.parent.enabled ? DelTheme.DelPagination.colorButtonText : DelTheme.DelPagination.colorButtonTextDisabled
                opacity: parent.parent.iconOpacity
            }
        }

        DelToolTip {
            id: __moreTooltip
            arrowVisible: false
            visible: parent.enabled && parent.hovered && text !== ""
        }
    }

    component ActionButton: Item {
        id: __actionRoot
        width: __actionButton.width
        height: __actionButton.height

        signal clicked()
        property bool disabled: false
        property alias iconSource: __actionButton.iconSource
        property alias tooltipText: __tooltip.text

        DelIconButton {
            id: __actionButton
            padding: 0
            width: control.defaultButtonWidth
            height: control.defaultButtonHeight
            animationEnabled: control.animationEnabled
            enabled: control.enabled && !__actionRoot.disabled
            effectEnabled: false
            colorBorder: "transparent"
            colorBg: enabled ? (down ? DelTheme.DelPagination.colorActionBgActive :
                                       hovered ? DelTheme.DelPagination.colorActionBgHover :
                                                 DelTheme.DelPagination.colorActionBg) : DelTheme.DelPagination.colorActionBg
            onClicked: __actionRoot.clicked();

            DelToolTip {
                id: __tooltip
                arrowVisible: false
                visible: parent.hovered && parent.enabled && text !== ""
            }
        }

        HoverHandler {
            enabled: __actionRoot.disabled
            cursorShape: Qt.ForbiddenCursor
        }
    }

    QtObject {
        id: __private
        property int pageButtonHalfCount: Math.ceil(control.pageButtonMaxCount * 0.5)
    }

    Row {
        id: __row
        spacing: control.defaultButtonSpacing

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.prevButtonDelegate
        }

        PaginationButton {
            pageIndex: 0
            visible: control.pageTotal > 0
        }

        PaginationMoreButton {
            isPrev: true
            tooltipText: qsTr("向前5页")
            visible: control.pageTotal > control.pageButtonMaxCount && (control.currentPageIndex + 1) > __private.pageButtonHalfCount
            onClicked: control.gotoPrev5Page();
        }

        Repeater {
            id: __repeater
            model: (control.pageTotal < 2) ? 0 :
                                             (control.pageTotal >= control.pageButtonMaxCount) ? (control.pageButtonMaxCount - 2) :
                                                                                                 (control.pageTotal - 2)
            delegate: Loader {
                sourceComponent: PaginationButton {
                    pageIndex: {
                        if ((control.currentPageIndex + 1) <= __private.pageButtonHalfCount)
                            return index + 1;
                        else if (control.pageTotal - (control.currentPageIndex + 1) <= (control.pageButtonMaxCount - __private.pageButtonHalfCount))
                            return (control.pageTotal - __repeater.count + index - 1);
                        else
                            return (control.currentPageIndex + index + 2 - __private.pageButtonHalfCount);
                    }
                }
                required property int index
            }
        }

        PaginationMoreButton {
            isPrev: false
            tooltipText: qsTr("向后5页")
            visible: control.pageTotal > control.pageButtonMaxCount &&
                     (control.pageTotal - (control.currentPageIndex + 1) > (control.pageButtonMaxCount - __private.pageButtonHalfCount))
            onClicked: control.gotoNext5Page();
        }

        PaginationButton {
            pageIndex: control.pageTotal - 1
            visible: control.pageTotal > 1
        }

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.nextButtonDelegate
        }

        DelSelect {
            anchors.verticalCenter: parent.verticalCenter
            animationEnabled: control.animationEnabled
            model: control.pageSizeModel
            visible: count > 0
            onActivated:
                (index) => {
                    control.pageSize = currentValue;
                }
        }

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.showQuickJumper ? control.quickJumperDelegate : null
        }
    }
}
