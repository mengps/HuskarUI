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

    signal clicked(radioData: var)

    property bool animationEnabled: DelTheme.animationEnabled
    property bool effectEnabled: true
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
    property string contentDescription: ""

    property Component radioDelegate: DelButton {
        id: __rootItem

        required property var modelData
        required property int index
        property int shape: {
            if (count === 1)
                return 0;
            else if (index == 0)
                return 1;
            else if (index === (count - 1))
                return 2;
            else
                return 0;
        }

        T.ButtonGroup.group: __buttonGroup
        Component.onCompleted: {
            if (control.initCheckedIndex == index) {
                checked = true;
                __buttonGroup.clicked(__rootItem);
            }
        }

        animationEnabled: control.animationEnabled
        implicitWidth: control.size == DelRadioBlock.Size_Auto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                 control.radioWidth
        implicitHeight: control.size == DelRadioBlock.Size_Auto ? (implicitContentHeight + topPadding + bottomPadding) :
                                                                  control.radioHeight
        z: (hovered || checked) ? 1 : 0
        enabled: modelData.enabled === undefined ? true : modelData.enabled
        font: control.font
        type: DelButton.Type_Default
        text: modelData.label
        colorBorder: (!enabled && checked) ? DelTheme.DelRadio.colorBlockBorderChecked :
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
                    return down ? DelTheme.DelRadio.colorBlockBgActive :
                                  hovered ? (checked ? DelTheme.DelRadio.colorBlockBgHover : DelTheme.DelRadio.colorBlockBg) :
                                            checked ? DelTheme.DelRadio.colorBlockBgChecked :
                                                      DelTheme.DelRadio.colorBlockBg;
                } else {
                    return DelTheme.DelRadio.colorBlockBg;
                }
            } else {
                return DelTheme.DelRadio.colorBlockBgDisabled;
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
                color: "transparent"
                border.width: 0
                border.color: __rootItem.enabled ? DelTheme.DelButton.colorBorderHover : "transparent"
                opacity: 0.2

                ParallelAnimation {
                    id: __animation
                    onFinished: __effect.border.width = 0;
                    NumberAnimation {
                        target: __effect; property: "width"; from: __bg.width + 3; to: __bg.width + 8;
                        duration: DelTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: "height"; from: __bg.height + 3; to: __bg.height + 8;
                        duration: DelTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: "opacity"; from: 0.2; to: 0;
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
                topLeftRadius: shape == 1 ? control.radiusBg : 0
                bottomLeftRadius: shape == 1 ? control.radiusBg : 0
                topRightRadius: shape == 2 ? control.radiusBg : 0
                bottomRightRadius: shape == 2 ? control.radiusBg : 0
                border.width: 1
                border.color: __rootItem.colorBorder

                Behavior on color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
                Behavior on border.color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
            }
        }
    }

    Component {
        id: __row

        Row {
            spacing: -1

            Repeater {
                id: __repeater
                model: control.model
                delegate: radioDelegate
            }
        }
    }

    Loader {
        id: __loader
        sourceComponent: __row

        T.ButtonGroup {
            id: __buttonGroup
            onClicked:
                (button)=>{
                    control.currentCheckedIndex = button.index;
                    control.currentCheckedValue = button.modelData.value;
                    control.clicked(button.modelData);
                }
        }
    }

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}
