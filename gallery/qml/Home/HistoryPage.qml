import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

import '../Controls'
import '../Controls/markdown.js' as Markdown

HusWindow {
    id: root
    width: 980
    height: 680
    minimumWidth: 760
    minimumHeight: 520
    captionBar.showMinimizeButton: false
    captionBar.showMaximizeButton: false
    captionBar.winTitle: qsTr('历史记录')
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/huskarui_new_square.svg'
        }
    }
    captionBar.closeCallback: () => historyLoader.visible = false;
    Component.onCompleted: loadVersionList();

    property var versionModel: []
    property string changelogText: ''

    function loadVersionList() {
        const text = HusApi.readFileToString(':/changelogs/index.json');
        if (text === '')
            return;
        try {
            const data = JSON.parse(text);
            root.versionModel = Markdown.buildVersionList(data.items ?? [], HusApp.libVersion());
            if (root.versionModel.length > 0) {
                versionMenu.defaultSelectedKeys = [root.versionModel[0].key];
                versionMenu.initModel = root.versionModel;
                root.loadChangelog(root.versionModel[0].file);
            }
        } catch (e) {
            console.error('解析历史记录索引失败:', e);
        }
    }

    function loadChangelog(fileName) {
        if (!fileName)
            return;
        root.changelogText = HusApi.readFileToString(':/changelogs/' + fileName);
    }

    Item {
        anchors.fill: parent

        HusShadow {
            anchors.fill: backRect
            source: backRect
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

            GradientFlowEffect {
                anchors.fill: parent
                opacity: 0.3
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: root.captionBar.height + 12
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.bottomMargin: 12
            spacing: 12

            Rectangle {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
                radius: HusTheme.Primary.radiusPrimary
                color: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.6)
                border.color: HusTheme.Primary.colorFillPrimary

                HusMenu {
                    id: versionMenu
                    anchors.fill: parent
                    anchors.margins: 6
                    defaultMenuWidth: width
                    defaultMenuTopPadding: 6
                    defaultMenuBottomPadding: 6
                    defaultMenuSpacing: 2
                    initModel: []
                    onClickMenu: function(deep, key, keyPath, data) {
                        if (data)
                            root.loadChangelog(data.file);
                    }
                    menuLabelDelegate: HusText {
                        text: menuButton.text
                        font: menuButton.font
                        color: menuButton.colorText
                        elide: Text.ElideRight

                        property var model: parent.model
                        property var menuButton: parent.menuButton

                        HusTag {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr('当前')
                            visible: model.isCurrent ?? false
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: HusTheme.Primary.radiusPrimary
                color: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.6)
                border.color: HusTheme.Primary.colorFillPrimary
                clip: true

                MarkdownView {
                    anchors.fill: parent
                    markdown: root.changelogText
                }

                HusEmpty {
                    anchors.fill: parent
                    visible: root.versionModel.length === 0 || root.changelogText === ''
                    description: qsTr('暂无历史记录')
                }
            }
        }
    }
}
