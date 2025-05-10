import QtQuick
import QtQuick.Templates as T
import DelegateUI

Item {
    id: control

    implicitWidth: __loader.width
    implicitHeight: __loader.height

    font {
        family: DelTheme.DelRadio.fontFamily
        pixelSize: DelTheme.DelRadio.fontSize
    }

    enum Type {
        Type_Filled = 0,
        Type_Outlined = 1
    }

    enum Size {
        Size_Auto = 0,
        Size_Fixed = 1
    }

    signal clicked(index: int, radioData: var)

    property bool animationEnabled: DelTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property var model: []
    property int count: model.length
    property int initCheckedIndex: -1
    property int currentCheckedIndex: -1
    property var currentCheckedValue: undefined
    property int type: DelRadioBlock.Type_Filled
    property int size: DelRadioBlock.Size_Auto
    property int radioWidth: 120
    property int radioHeight: 30
    property font font
    property int radiusBg: 6
    property Component radioDelegate: DelIconButton {
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
        implicitWidth: control.size == DelRadioBlock.Size_Auto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                 control.radioWidth
        implicitHeight: control.size == DelRadioBlock.Size_Auto ? (implicitContentHeight + topPadding + bottomPadding) :
                                                                  control.radioHeight
        z: (hovered || checked) ? 1 : 0
        enabled: control.enabled && (modelData.enabled === undefined ? true : modelData.enabled)
        font: control.font
        type: DelButton.Type_Default
        iconSource: modelData.icon ?? 0
        text: modelData.label
        colorBorder: (enabled && checked) ? DelTheme.DelRadio.colorBlockBorderChecked :
                                            DelTheme.DelRadio.colorBlockBorder;
        colorText: {
            if (enabled) {
                if (control.type == DelRadioBlock.Type_Filled) {
                    return checked ? DelTheme.DelRadio.colorBlockTextFilledChecked :
                                     hovered ? DelTheme.DelRadio.colorBlockTextChecked :
                                               DelTheme.DelRadio.colorBlockText;
                } else {
                    return (checked || hovered) ? DelTheme.DelRadio.colorBlockTextChecked :
                                                  DelTheme.DelRadio.colorBlockText;
                }
            } else {
                return DelTheme.DelRadio.colorTextDisabled;
            }
        }
        colorBg: {
            if (enabled) {
                if (control.type == DelRadioBlock.Type_Filled) {
                    return down ? (checked ? DelTheme.DelRadio.colorBlockBgActive : DelTheme.DelRadio.colorBlockBg) :
                                  hovered ? (checked ? DelTheme.DelRadio.colorBlockBgHover : DelTheme.DelRadio.colorBlockBg) :
                                            checked ? DelTheme.DelRadio.colorBlockBgChecked :
                                                      DelTheme.DelRadio.colorBlockBg;
                } else {
                    return DelTheme.DelRadio.colorBlockBg;
                }
            } else {
                return checked ? DelTheme.DelRadio.colorBlockBgCheckedDisabled : DelTheme.DelRadio.colorBlockBgDisabled;
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
                border.color: __rootItem.enabled ? DelTheme.DelRadio.colorBlockEffectBg : 'transparent'
                opacity: 0.2

                ParallelAnimation {
                    id: __animation
                    onFinished: __effect.border.width = 0;
                    NumberAnimation {
                        target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                        duration: DelTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                        duration: DelTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'opacity'; from: 0.2; to: 0;
                        duration: DelTheme.Primary.durationSlow
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

            DelRectangle {
                id: __bg
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                color: __rootItem.colorBg
                topLeftRadius: index == 0 ? control.radiusBg : 0
                bottomLeftRadius: index == 0 ? control.radiusBg : 0
                topRightRadius: index === (count - 1) ? control.radiusBg : 0
                bottomRightRadius: index === (count - 1) ? control.radiusBg : 0
                border.width: 1
                border.color: __rootItem.colorBorder

                Behavior on color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
                Behavior on border.color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
            }
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
