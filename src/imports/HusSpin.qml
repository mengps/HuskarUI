import QtQuick
import HuskarUI.Basic

Item {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property int iconSource: 0     // 0 表示使用默认四叶草,其他值使用 HusIcon
    property int size: 32
    property bool spinning: true
    property string tip: ''
    property real tipSpacing: 8
    property color colorIcon: HusTheme.Primary.colorPrimary
    property color colorTip: HusTheme.Primary.colorTextSecondary
    property int delay: 0    // 毫秒
    property var delayCallback: null
    default property alias contentDelegate: __contentItem.data

    objectName: '__HusSpin__'
    implicitWidth: Math.max(__spinIcon.width, __tipText.width, __contentItem.implicitWidth)
    implicitHeight: Math.max(
        __spinIcon.height + (tip.length > 0 ? tipSpacing + __tipText.height : 0),
        __contentItem.implicitHeight
    )

    QtObject {
        id: __private
        property bool spinVisible: control.spinning
    }

    Timer {
        id: __delayTimer
        interval: control.delay
        running: control.spinning && control.delay > 0
        repeat: false
        onTriggered: {
            __private.spinVisible = false;
            if (control.delayCallback && typeof control.delayCallback === 'function') {
                control.delayCallback();
            }
        }
    }

    onSpinningChanged: {
        if (spinning) {
            __private.spinVisible = true;
            if (delay > 0) {
                __delayTimer.restart();
            }
        } else {
            __private.spinVisible = false;
            __delayTimer.stop();
        }
    }

    // 子组件容器 - 始终可见
    Item {
        id: __contentItem
        anchors.fill: parent
        opacity: __private.spinVisible ? 0.5 : 1.0

        Behavior on opacity {
            NumberAnimation {
                duration: control.animationEnabled ? 300 : 0
            }
        }
    }

    // Spin 图标层 - 独立控制可见性
    Column {
        anchors.centerIn: parent
        spacing: control.tipSpacing
        visible: __private.spinVisible
        z: 1

        Item {
            id: __spinIcon
            width: control.size
            height: control.size
            anchors.horizontalCenter: parent.horizontalCenter
            transformOrigin: Item.Center

            // 四叶草 Canvas (默认)
            Canvas {
                id: __cloverCanvas
                anchors.fill: parent
                visible: control.iconSource === 0
                antialiasing: true

                onPaint: {
                    const ctx = getContext('2d');
                    ctx.clearRect(0, 0, width, height);

                    const centerX = width / 2;
                    const centerY = height / 2;
                    const radius = width / 8;
                    const leafDistance = width / 3;

                    // 四个叶片的位置
                    const positions = [
                        { x: centerX, y: centerY - leafDistance },           // 上
                        { x: centerX + leafDistance, y: centerY },           // 右
                        { x: centerX, y: centerY + leafDistance },           // 下
                        { x: centerX - leafDistance, y: centerY }            // 左
                    ];

                    // 透明度数组：从 0.3 到 1.0 递增
                    const opacities = [0.3, 0.5, 0.7, 1.0];

                    // 绘制四个叶片，每个叶片使用不同的透明度
                    for (let i = 0; i < positions.length; i++) {
                        ctx.save();
                        ctx.globalAlpha = opacities[i];
                        ctx.fillStyle = control.colorIcon;
                        ctx.beginPath();
                        ctx.arc(positions[i].x, positions[i].y, radius, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.restore();
                    }
                }

                Connections {
                    target: control
                    function onColorIconChanged() {
                        __cloverCanvas.requestPaint();
                    }
                }
            }

            // HusIcon 图标 (自定义时使用)
            HusIconText {
                anchors.fill: parent
                visible: control.iconSource !== 0
                iconSource: control.iconSource
                iconSize: control.size
                colorIcon: control.colorIcon
            }

            NumberAnimation on rotation {
                running: control.spinning && control.animationEnabled && __private.spinVisible
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }

        HusText {
            id: __tipText
            anchors.horizontalCenter: parent.horizontalCenter
            text: control.tip
            visible: !!control.tip.length
            color: control.colorTip

            Behavior on color {
                enabled: control.animationEnabled
                ColorAnimation { duration: HusTheme.Primary.durationFast }
            }
        }
    }
}