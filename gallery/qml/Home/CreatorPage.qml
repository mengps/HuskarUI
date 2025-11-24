import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Basic
import HuskarUI.Basic
import Gallery

HusWindow {
    id: root
    width: 800
    height: 550
    minimumWidth: 800
    minimumHeight: 550
    captionBar.winTitle: qsTr('创建新项目')
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/huskarui_icon.svg'
        }
    }
    captionBar.showMinimizeButton: false
    captionBar.showMaximizeButton: false
    captionBar.color: HusTheme.Primary.colorFillTertiary
    captionBar.closeCallback: () => creatorLoader.visible = false;
    Component.onCompleted: setSpecialEffect(galleryWindow.specialEffect);

    Connections {
        target: galleryWindow
        function onSpecialEffectChanged() {
            root.setSpecialEffect(galleryWindow.specialEffect);
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 40
        anchors.topMargin: captionBar.height + 20

        Column {
            spacing: 15

            HusText {
                text: qsTr('项目名称')
            }

            HusInput {
                id: projectNameInput
                width: 500
                text: 'HuskarUIProject'
            }

            HusText {
                text: qsTr('位置')
            }

            HusInput {
                id: projectLocationInput
                width: 500
                Component.onCompleted: {
                    text = Creator.urlToLocalFile(projectLocationFolderDialog.currentFolder);
                }

                HusIconButton {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    leftPadding: 10
                    rightPadding: 10
                    iconSource: HusIcon.EllipsisOutlined
                    onClicked: {
                        projectLocationFolderDialog.open();
                    }

                    FolderDialog {
                        id: projectLocationFolderDialog
                        currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
                        onAccepted: {
                            currentFolder = selectedFolder;
                            projectLocationInput.text = Creator.urlToLocalFile(selectedFolder);
                        }
                    }
                }
            }

            HusText {
                text: qsTr('HuskarUI 包含方式')
            }

            HusRadioBlock {
                id: containMethod
                initCheckedIndex: 2
                model: [
                    { label: qsTr('不包含'), value: Creator.NoContain, toolTip: { text: qsTr('将创建基础的 CMake 项目') } },
                    { label: qsTr('源码包含'), value: Creator.SourceContain, toolTip: { text: qsTr('将使用 add_subdirectory()') } },
                    { label: qsTr('库包含'), value: Creator.LibraryContain, toolTip: { text: qsTr('将以动态库形式包含') } },
                ]
                onCurrentCheckedIndexChanged: {
                    if (currentCheckedIndex == 1) {
                        sourceLocation.text = Creator.urlToLocalFile(sourceFloderDialog.currentFolder);
                    } else if (currentCheckedIndex == 2) {
                        defaultCheckBox.checkedChanged();
                    }
                }
            }

            HusText {
                text: {
                    switch (containMethod.currentCheckedIndex) {
                    case 0: return '';
                    case 1: return qsTr('HuskarUI 源码位置');
                    case 2: return qsTr('HuskarUI 库位置');
                    }
                }
                visible: containMethod.currentCheckedIndex != 0
            }

            HusCheckBox {
                id: defaultCheckBox
                text: qsTr('默认安装位置')
                checked: true
                visible: containMethod.currentCheckedIndex == 2
                onCheckedChanged: {
                    if (containMethod.currentCheckedIndex == 2) {
                        if (checked)
                            sourceLocation.text = "${Qt_DIR}/../../../";
                        else
                            sourceLocation.text = Creator.urlToLocalFile(sourceFloderDialog.currentFolder);
                    }
                }
                Component.onCompleted: checkedChanged();

                HusIconText {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: HusIcon.QuestionCircleOutlined
                    iconSize: HusTheme.Primary.fontPrimarySize + 2
                    colorIcon: HusTheme.Primary.colorPrimary

                    HusToolTip {
                        text: qsTr('如果 HuskarUI 是默认安装的，库将安装在 QtSDK 目录\n如果自定义安装位置则不勾选')
                        visible: buildLocationHover.hovered
                    }

                    HoverHandler {
                        id: buildLocationHover
                    }
                }
            }

            HusInput {
                id: sourceLocation
                width: 500
                visible: containMethod.currentCheckedIndex != 0
                enabled: !(containMethod.currentCheckedIndex == 2 && defaultCheckBox.checked)
                Component.onCompleted: {
                    text = Creator.urlToLocalFile(sourceFloderDialog.currentFolder);
                }

                HusIconButton {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    leftPadding: 10
                    rightPadding: 10
                    iconSource: HusIcon.EllipsisOutlined
                    onClicked: {
                        sourceFloderDialog.currentFolder = Creator.localFileToUrl(sourceLocation.text);
                        sourceFloderDialog.open();
                    }

                    FolderDialog {
                        id: sourceFloderDialog
                        onAccepted: {
                            currentFolder = selectedFolder;
                            sourceLocation.text = Creator.urlToLocalFile(selectedFolder);
                        }
                    }
                }
            }

            HusCheckBox {
                id: addDeployScript
                text: qsTr('添加 CMake 部署脚本')
                checked: true
            }

            HusCheckBox {
                id: isShareLibrary
                visible: containMethod.currentCheckedIndex != 0
                text: qsTr('HuskarUI 动态库')
                checked: true
                onCheckedChanged: {
                    if (!checked && visible) {
                        containMethod.currentCheckedIndex = 1;
                    }
                }

                HusIconText {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: HusIcon.QuestionCircleOutlined
                    iconSize: HusTheme.Primary.fontPrimarySize + 2
                    colorIcon: HusTheme.Primary.colorPrimary

                    HusToolTip {
                        text: qsTr('如果 HuskarUI 构建为动态库请勾选。\n静态库不要勾选并且只能选择源码包含。')
                        visible: isShareLibrarynHover.hovered
                    }

                    HoverHandler {
                        id: isShareLibrarynHover
                    }
                }
            }
        }

        Row {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            spacing: 15

            HusButton {
                text: qsTr('创建')
                type: HusButton.Type_Primary
                onClicked: {
                    let object = {};
                    object.projectName = projectNameInput.text;
                    object.projectLocation = projectLocationInput.text;
                    object.containMethod = containMethod.currentCheckedValue;
                    object.isDefaultBuild = defaultCheckBox.checked;
                    object.sourceLocation = sourceLocation.text;
                    object.addDeployScript = addDeployScript.checked;
                    object.isShareLibrary = isShareLibrary.checked;
                    Creator.createProject(object);
                }
            }

            HusButton {
                text: qsTr('取消')
                type: HusButton.Type_Outlined
                onClicked: captionBar.closeCallback();
            }
        }
    }
}
