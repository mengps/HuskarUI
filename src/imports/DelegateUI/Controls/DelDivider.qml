import QtQuick
import QtQuick.Shapes
import DelegateUI

Item {
    id: control

    enum Align {
        Left = 0,
        Center = 1,
        Right = 2
    }

    font {
        family: DelTheme.DelDivider.fontFamily
        pixelSize: DelTheme.DelDivider.fontSize
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property font font
    property string title: ""
    property int titleAlign: DelDivider.Left
    property int titlePadding: 20
    property color colorText: DelTheme.DelDivider.colorText
    property color colorSplit: DelTheme.DelDivider.colorSplit
    property int style: ShapePath.SolidLine

    property Component titleDelegate: Text {
        font: control.font
        text: control.title
        color: control.colorText
    }
    property Component splitDelegate: Shape {
        id: __shape

        property real lineY: __titleLoader.y + __titleLoader.implicitHeight * 0.5

        ShapePath {
            strokeStyle: control.style
            strokeColor: control.colorSplit
            strokeWidth: 1
            fillColor: "transparent"
            startX: 0
            startY: __shape.lineY
            PathLine { x: control.title == "" ? 0 : __titleLoader.x - 10; y: __shape.lineY }
        }

        ShapePath {
            strokeStyle: control.style
            strokeColor: control.colorSplit
            strokeWidth: 1
            fillColor: "transparent"
            startX: control.title == "" ? 0 : (__titleLoader.x + __titleLoader.implicitWidth + 10)
            startY: __shape.lineY
            PathLine { x: control.width; y: __shape.lineY }
        }
    }

    Behavior on colorSplit { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

    Loader {
        id: __splitLoader
        sourceComponent: splitDelegate
    }

    Loader {
        id: __titleLoader
        z: 1
        anchors.left: control.titleAlign == DelDivider.Left ? parent.left : undefined
        anchors.leftMargin: control.titleAlign == DelDivider.Left ? control.titlePadding : 0
        anchors.right: control.titleAlign == DelDivider.Right ? parent.right : undefined
        anchors.rightMargin: control.titleAlign == DelDivider.Right ? control.titlePadding : 0
        anchors.horizontalCenter: control.titleAlign == DelDivider.Center ? parent.horizontalCenter : undefined
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: titleDelegate
    }
}
