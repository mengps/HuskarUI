import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

T.Control {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property real spinSize: 24 * control.sizeRatio
    property real indicatorSize: 7 * control.sizeRatio
    property int indicatorItemCount: 4
    property bool spinning: true
    property string tip: ''
    property var percent: 'auto' || 0
    property color colorTip: themeSource.colorTip
    property color colorIndicator: themeSource.colorIndicator
    property color colorProgressBar: themeSource.colorProgressBar
    property string sizeHint: 'normal'
    property real sizeRatio: {
        switch (sizeHint) {
        case 'small': return 0.6;
        case 'normal': return 1.0;
        case 'large': return 1.6;
        }
    }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusSpin

    property Component indicatorDelegate: Repeater {
        model: control.indicatorItemCount
        delegate: Item {
            id: __rootItem
            x: halfSize + (halfSize - control.indicatorSize * 0.5) *
               Math.cos(2 * Math.PI * index / control.indicatorItemCount) - control.indicatorSize * 0.5
            y: halfSize + (halfSize - control.indicatorSize * 0.5) *
               Math.sin(2 * Math.PI * index / control.indicatorItemCount) - control.indicatorSize * 0.5

            required property int index

            Loader {
                sourceComponent: control.indicatorItemDelegate
                property alias index: __rootItem.index
                property real itemSize: control.indicatorSize
            }
        }
        property real halfSize: control.spinSize * 0.5
    }
    property Component indicatorItemDelegate: Rectangle {
        id: __indicatorDelegate
        width: itemSize
        height: width
        radius: width * 0.5
        color: control.colorIndicator

        OpacityAnimator on opacity {
            id: opacityAnimator
            duration: 1200
            loops: 1
            alwaysRunToEnd: true
            onFinished: {
                reverse = !reverse;
                from = reverse ? 1.0 : 0.2;
                to = reverse ? 0.2 : 1.0;
                restart();
            }
            property bool reverse: false
        }

        Timer {
            interval: (index + 1) * 1200 / control.indicatorItemCount
            onCanRunChanged: {
                if (canRun) {
                    restart();
                } else {
                    opacityAnimator.stop();
                }
            }
            onTriggered: {
                opacityAnimator.reverse = false;
                opacityAnimator.from = 0.2;
                opacityAnimator.to = 1.0;
                opacityAnimator.restart();
            }
            property bool canRun: control.animationEnabled && control.spinning
        }
    }
    property Component tipDelegate: HusText {
        text: control.tip
        font: control.font
        color: control.colorTip
    }

    objectName: '__HusSpin__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    spacing: 5
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    contentItem: ColumnLayout {
        spacing: control.spacing

        Item {
            id: __spinner
            Layout.preferredWidth: control.spinSize
            Layout.preferredHeight: control.spinSize
            Layout.alignment: Qt.AlignHCenter
            visible: control.spinning
            opacity: control.spinning ? 1 : 0

            property bool isProgress: typeof control.percent === 'number'

            Loader {
                id: __indicatorLoader
                anchors.fill: parent
                scale: __spinner.isProgress ? 0.0 : 1.0
                visible: scale > 0
                sourceComponent: control.indicatorDelegate

                Behavior on scale {
                    enabled: control.animationEnabled
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                        duration: HusTheme.Primary.durationSlow
                    }
                }

                Behavior on opacity {
                    enabled: control.animationEnabled;
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                        duration: HusTheme.Primary.durationMid
                    }
                }

                RotationAnimator on rotation {
                    running: control.animationEnabled && control.spinning
                    from: 0
                    to: 360
                    duration: 1200
                    loops: Animation.Infinite
                }
            }

            HusProgress {
                anchors.fill: parent
                type: HusProgress.Type_Circle
                animationEnabled: control.animationEnabled
                showInfo: false
                percent: visible ? control.percent : 0
                barThickness: 4 * control.sizeRatio
                colorBar: control.colorProgressBar
                scale: 1.0 - __indicatorLoader.scale
                visible: scale > 0
            }
        }

        Loader {
            Layout.alignment: Qt.AlignHCenter
            active: control.tip !== ''
            sourceComponent: control.tipDelegate
        }
    }

    Accessible.role: Accessible.Indicator
    Accessible.name: control.tip
    Accessible.description: control.contentDescription
}
