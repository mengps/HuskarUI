import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control

    enum Type {
        Type_Filled = 0,
        Type_Outlined = 1
    }

    enum Size {
        Size_Auto = 0,
        Size_Fixed = 1
    }

    signal clicked(index: int, radioData: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property var model: []
    readonly property int count: model.length
    property int initCheckedIndex: -1
    property int currentCheckedIndex: -1
    property var currentCheckedValue: undefined
    property int type: HusRadioBlock.Type_Filled
    property int size: HusRadioBlock.Size_Auto
    property int radioWidth: 120
    property int radioHeight: 30
    property font font: Qt.font({
                                    family: HusTheme.HusRadio.fontFamily,
                                    pixelSize: parseInt(HusTheme.HusRadio.fontSize)
                                })
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusRadio.radiusBlockBg }
    property Component toolTipDelegate: HusToolTip {
        text: toolTip.text ?? ''
        delay: toolTip.delay ?? 500
        timeout: toolTip.timeout ?? -1
        visible: hovered
        animationEnabled: control.animationEnabled
    }
    property Component radioDelegate: HusIconButton {
        id: __rootItem

        required property var modelData
        required property int index

        T.ButtonGroup.group: __buttonGroup
        Component.onCompleted: {
            if (control.initCheckedIndex == index) {
                checked = true;
                __buttonGroup.clicked(__rootItem);
            }
        }

        animationEnabled: control.animationEnabled
        effectEnabled: control.effectEnabled
        hoverCursorShape: control.hoverCursorShape
        implicitWidth: control.size == HusRadioBlock.Size_Auto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                 control.radioWidth
        implicitHeight: control.size == HusRadioBlock.Size_Auto ? (implicitContentHeight + topPadding + bottomPadding) :
                                                                  control.radioHeight
        z: (hovered || checked) ? 1 : 0
        enabled: control.enabled && (modelData.enabled === undefined ? true : modelData.enabled)
        font: control.font
        type: HusButton.Type_Default
        iconSource: modelData.icon ?? 0
        text: modelData.label
        colorBorder: (enabled && checked) ? HusTheme.HusRadio.colorBlockBorderChecked :
                                            HusTheme.HusRadio.colorBlockBorder;
        colorText: {
            if (enabled) {
                if (control.type == HusRadioBlock.Type_Filled) {
                    return checked ? HusTheme.HusRadio.colorBlockTextFilledChecked :
                                     hovered ? HusTheme.HusRadio.colorBlockTextChecked :
                                               HusTheme.HusRadio.colorBlockText;
                } else {
                    return (checked || hovered) ? HusTheme.HusRadio.colorBlockTextChecked :
                                                  HusTheme.HusRadio.colorBlockText;
                }
            } else {
                return HusTheme.HusRadio.colorTextDisabled;
            }
        }
        colorBg: {
            if (enabled) {
                if (control.type == HusRadioBlock.Type_Filled) {
                    return down ? (checked ? HusTheme.HusRadio.colorBlockBgActive : HusTheme.HusRadio.colorBlockBg) :
                                  hovered ? (checked ? HusTheme.HusRadio.colorBlockBgHover : HusTheme.HusRadio.colorBlockBg) :
                                            checked ? HusTheme.HusRadio.colorBlockBgChecked :
                                                      HusTheme.HusRadio.colorBlockBg;
                } else {
                    return HusTheme.HusRadio.colorBlockBg;
                }
            } else {
                return checked ? HusTheme.HusRadio.colorBlockBgCheckedDisabled : HusTheme.HusRadio.colorBlockBgDisabled;
            }
        }
        checkable: true
        background: Item {
            Rectangle {
                id: __effect
                width: __bg.width
                height: __bg.height
                anchors.centerIn: parent
                visible: __rootItem.effectEnabled
                color: 'transparent'
                border.width: 0
                border.color: __rootItem.enabled ? HusTheme.HusRadio.colorBlockEffectBg : 'transparent'
                opacity: 0.2

                ParallelAnimation {
                    id: __animation
                    onFinished: __effect.border.width = 0;
                    NumberAnimation {
                        target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                        duration: HusTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                        duration: HusTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'opacity'; from: 0.2; to: 0;
                        duration: HusTheme.Primary.durationSlow
                    }
                }

                Connections {
                    target: __rootItem
                    function onReleased() {
                        if (__rootItem.animationEnabled && __rootItem.effectEnabled) {
                            __effect.border.width = 8;
                            __animation.restart();
                        }
                    }
                }
            }

            HusRectangleInternal {
                id: __bg
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                color: __rootItem.colorBg
                topLeftRadius: index == 0 ? control.radiusBg.topLeft : 0
                topRightRadius: index === (count - 1) ? control.radiusBg.topRight : 0
                bottomLeftRadius: index == 0 ? control.radiusBg.bottomLeft : 0
                bottomRightRadius: index === (count - 1) ? control.radiusBg.bottomRight : 0
                border.width: 1
                border.color: __rootItem.colorBorder

                Behavior on color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
                Behavior on border.color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
            }
        }

        Loader {
            x: (parent.width - width) * 0.5
            active: toolTip !== undefined
            sourceComponent: control.toolTipDelegate
            property bool checked: __rootItem.released
            property bool pressed: __rootItem.pressed
            property bool hovered: __rootItem.hovered
            property var toolTip: modelData.toolTip
        }

        Connections {
            target: control
            function onCurrentCheckedIndexChanged() {
                if (__rootItem.index == control.currentCheckedIndex) {
                    __rootItem.checked = true;
                }
            }
        }
    }
    property string contentDescription: ''

    objectName: '__HusRadioBlock__'
    implicitWidth: __loader.implicitWidth
    implicitHeight: __loader.implicitHeight

    Loader {
        id: __loader
        sourceComponent: Row {
            spacing: -1

            Repeater {
                id: __repeater
                model: control.model
                delegate: radioDelegate
            }
        }

        T.ButtonGroup {
            id: __buttonGroup
            onClicked:
                button => {
                    control.currentCheckedIndex = button.index;
                    control.currentCheckedValue = button.modelData.value;
                    control.clicked(button.index, button.modelData);
                }
        }
    }

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}
