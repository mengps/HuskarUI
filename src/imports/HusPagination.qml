import QtQuick
import HuskarUI.Basic

Item {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
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
    property string prevButtonTooltip: qsTr('上一页')
    property string nextButtonTooltip: qsTr('下一页')
    property Component prevButtonDelegate: ActionButton {
        iconSource: HusIcon.LeftOutlined
        tooltipText: control.prevButtonTooltip
        disabled: control.currentPageIndex == 0
        onClicked: control.gotoPrevPage();
    }
    property Component nextButtonDelegate: ActionButton {
        iconSource: HusIcon.RightOutlined
        tooltipText: control.nextButtonTooltip
        disabled: control.currentPageIndex == (control.pageTotal - 1)
        onClicked: control.gotoNextPage();
    }
    property Component quickJumperDelegate: Row {
        height: control.defaultButtonHeight
        spacing: control.defaultButtonSpacing

        HusText {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr('跳至')
            font {
                family: HusTheme.HusCopyableText.fontFamily
                pixelSize: parseInt(HusTheme.HusCopyableText.fontSize)
            }
            color: HusTheme.Primary.colorTextBase
        }

        HusInput {
            width: 48
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: HusInput.AlignHCenter
            animationEnabled: control.animationEnabled
            enabled: control.enabled
            validator: IntValidator { top: 99999; bottom: 0 }
            onEditingFinished: {
                control.gotoPageIndex(parseInt(text) - 1);
                clear();
            }
        }

        HusText {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr('页')
            font {
                family: HusTheme.Primary.fontPrimaryFamily
                pixelSize: HusTheme.Primary.fontPrimarySize
            }
            color: HusTheme.Primary.colorTextBase
        }
    }

    objectName: '__HusPagination__'
    width: __row.width
    height: __row.height
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

    component PaginationButton: HusButton {
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
                return checked ? HusTheme.HusPagination.colorButtonTextActive : HusTheme.HusPagination.colorButtonText;
            else
                return HusTheme.HusPagination.colorButtonTextDisabled;
        }
        colorBg: {
            if (enabled) {
                if (checked)
                    return HusTheme.HusPagination.colorButtonBg;
                else
                    return down ? HusTheme.HusPagination.colorButtonBgActive :
                                  hovered ? HusTheme.HusPagination.colorButtonBgHover :
                                            HusTheme.HusPagination.colorButtonBg;
            } else {
                return checked ? HusTheme.HusPagination.colorButtonBgDisabled : 'transparent';
            }
        }
        colorBorder: checked ? HusTheme.HusPagination.colorBorderActive : 'transparent'
        onClicked: {
            control.currentPageIndex = pageIndex;
        }
        property int pageIndex: 0

        Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
        Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
        Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

        HusToolTip {
            visible: parent.hovered && parent.enabled
            animationEnabled: control.animationEnabled
            text: parent.text
        }
    }

    component PaginationMoreButton: HusIconButton {
        id: __moreRoot
        padding: 0
        width: control.defaultButtonWidth
        height: control.defaultButtonHeight
        animationEnabled: false
        effectEnabled: false
        enabled: control.enabled
        colorBg: 'transparent'
        colorBorder: 'transparent'
        text: '•••'

        property bool showIcon: (enabled && (down || hovered))
        property bool isPrev: false
        property alias tooltipText: __moreTooltip.text

        onShowIconChanged: __seqAnimation.restart();

        SequentialAnimation {
            id: __seqAnimation
            alwaysRunToEnd: true
            ScriptAction {
                script: {
                    if (__moreRoot.showIcon) {
                        __moreRoot.text = '';
                        __moreRoot.iconSource = __moreRoot.isPrev ? HusIcon.DoubleLeftOutlined : HusIcon.DoubleRightOutlined;
                    } else {
                        __moreRoot.text = '•••'
                        __moreRoot.iconSource = 0;
                    }
                }
            }
            NumberAnimation {
                target: __moreRoot
                property: 'opacity'
                from: 0.0
                to: 1.0
                duration: control.animationEnabled ? HusTheme.Primary.durationSlow : 0
            }
        }

        HusToolTip {
            id: __moreTooltip
            visible: parent.enabled && parent.hovered && text !== ''
            animationEnabled: control.animationEnabled
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

        HusIconButton {
            id: __actionButton
            padding: 0
            width: control.defaultButtonWidth
            height: control.defaultButtonHeight
            animationEnabled: control.animationEnabled
            enabled: control.enabled && !__actionRoot.disabled
            effectEnabled: false
            colorBorder: 'transparent'
            colorBg: enabled ? (down ? HusTheme.HusPagination.colorActionBgActive :
                                       hovered ? HusTheme.HusPagination.colorActionBgHover :
                                                 HusTheme.HusPagination.colorActionBg) : HusTheme.HusPagination.colorActionBg
            onClicked: __actionRoot.clicked();

            HusToolTip {
                id: __tooltip
                visible: parent.hovered && parent.enabled && text !== ''
                animationEnabled: control.animationEnabled
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
            tooltipText: qsTr('向前5页')
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
            tooltipText: qsTr('向后5页')
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

        HusSelect {
            anchors.verticalCenter: parent.verticalCenter
            animationEnabled: control.animationEnabled
            clearEnabled: false
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
