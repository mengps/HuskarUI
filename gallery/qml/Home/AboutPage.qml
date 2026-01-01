import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Basic
import HuskarUI.Basic

HusWindow {
    id: root
    width: 400
    height: 500
    minimumWidth: 400
    minimumHeight: 500
    captionBar.showMinimizeButton: false
    captionBar.showMaximizeButton: false
    captionBar.winTitle: qsTr('关于')
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/huskarui_new_square.svg'
        }
    }
    captionBar.closeCallback: () => aboutLoader.visible = false;

    Item {
        anchors.fill: parent

        MultiEffect {
            anchors.fill: backRect
            source: backRect
            shadowColor: HusTheme.Primary.colorTextBase
            shadowEnabled: true
        }

        Rectangle {
            id: backRect
            anchors.fill: parent
            radius: 6
            color: HusTheme.Primary.colorBgBase
            border.color: HusThemeFunctions.alpha(HusTheme.Primary.colorTextBase, 0.2)
        }

        Item {
            anchors.fill: parent

            ShaderEffect {
                anchors.fill: parent
                vertexShader: 'qrc:/Gallery/shaders/effect2.vert.qsb'
                fragmentShader: 'qrc:/Gallery/shaders/effect2.frag.qsb'
                opacity: 0.5

                property vector3d iResolution: Qt.vector3d(width, height, 0)
                property real iTime: 0

                Timer {
                    running: true
                    repeat: true
                    interval: 16
                    onTriggered: parent.iTime += 0.03;
                }
            }
        }

        Column {
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: captionBar.height
            spacing: 10

            Item {
                width: 80
                height: width
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    width: parent.width
                    height: width
                    anchors.centerIn: parent
                    source: 'qrc:/Gallery/images/huskarui_new_square.svg'
                }
            }

            HusText {
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    family: HusTheme.Primary.fontPrimaryFamily
                    pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                    bold: true
                }
                text: `${HusApp.libName()} Gallery`
            }

            HusCopyableText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('库版本: ') + HusApp.libVersion()
            }

            HusCopyableText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('作者: MenPenS')
            }

            HusCopyableText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('微信号: MenPenS0612')
            }

            HusCopyableText {
                width: parent.width - 30
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: HusCopyableText.WordWrap
                horizontalAlignment: HusCopyableText.AlignHCenter
                text: qsTr('QQ交流群号: <a href=\'https://qm.qq.com/q/cMNHn2tWeY\' style=\'color:#722ED1\'>490328047</a>')
                textFormat: HusCopyableText.RichText
                onLinkActivated: (link) => Qt.openUrlExternally(link);
            }

            HusCopyableText {
                width: parent.width - 30
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: HusCopyableText.WordWrap
                horizontalAlignment: HusCopyableText.AlignHCenter
                text: `Github: <a href=\'https://github.com/mengps/${HusApp.libName()}\' style=\'color:#722ED1\'>https://github.com/mengps/${HusApp.libName()}</a>`
                textFormat: HusCopyableText.RichText
                onLinkActivated: (link) => Qt.openUrlExternally(link);
            }

            HusCopyableText {
                width: parent.width - 30
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: HusCopyableText.WordWrap
                horizontalAlignment: HusCopyableText.AlignHCenter
                text: qsTr('如果该项目/源码对你有用，就请点击上方链接给一个免费的Star，谢谢！')
            }

            HusCopyableText {
                width: parent.width - 30
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: HusCopyableText.WordWrap
                horizontalAlignment: HusCopyableText.AlignHCenter
                text: qsTr('有任何问题可以提Issues或进群！')
            }
        }
    }
}
