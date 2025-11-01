import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control

    enum Size {
        Size_Auto = 0,
        Size_Fixed = 1
    }

    signal pressed(index: int, buttonData: var)
    signal released(index: int, buttonData: var)
    signal clicked(index: int, buttonData: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property var model: []
    property int count: model.length
    property int size: HusButtonBlock.Size_Auto
    property int buttonWidth: 120
    property int buttonHeight: 30
    property int buttonLeftPadding: 10
    property int buttonRightPadding: 10
    property int buttonTopPadding: 8
    property int buttonBottomPadding: 8
    property font font: Qt.font({
                                    family: HusTheme.HusButton.fontFamily,
                                    pixelSize: parseInt(HusTheme.HusButton.fontSize)
                                })
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusButton.radiusBg }
    property Component buttonDelegate: HusIconButton {
        id: __rootItem

        required property var modelData
        required property int index

        onPressed: control.pressed(index, modelData);
        onReleased: control.released(index, modelData);
        onClicked: control.clicked(index, modelData);
        animationEnabled: control.animationEnabled
        effectEnabled: control.effectEnabled
        autoRepeat: modelData.autoRepeat ?? false
        hoverCursorShape: control.hoverCursorShape
        leftPadding: control.buttonLeftPadding
        rightPadding: control.buttonRightPadding
        topPadding: control.buttonTopPadding
        bottomPadding: control.buttonBottomPadding
        implicitWidth: control.size == HusButtonBlock.Size_Auto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                 control.buttonWidth
        implicitHeight: control.size == HusButtonBlock.Size_Auto ? (implicitContentHeight + topPadding + bottomPadding) :
                                                                  control.buttonHeight
        z: (hovered || checked) ? 1 : 0
        enabled: control.enabled && (modelData.enabled === undefined ? true : modelData.enabled)
        font: control.font
        type: modelData.type ?? HusButton.Type_Default
        iconSource: modelData.iconSource ?? 0
        text: modelData.label
        background: Item {
            Rectangle {
                id: __effect
                width: __bg.width
                height: __bg.height
                anchors.centerIn: parent
                visible: __rootItem.effectEnabled
                color: 'transparent'
                border.width: 0
                border.color: __rootItem.enabled ? HusTheme.HusButton.colorBorderHover : 'transparent'
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
    }
    property string contentDescription: ''

    objectName: '__HusButtonBlock__'
    implicitWidth: __loader.width
    implicitHeight: __loader.height

    Loader {
        id: __loader
        sourceComponent: Row {
            spacing: -1

            Repeater {
                id: __repeater
                model: control.model
                delegate: buttonDelegate
            }
        }
    }

    Accessible.role: Accessible.Button
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
}
