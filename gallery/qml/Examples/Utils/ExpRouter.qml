import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusRouter 路由 \n
简单的URL路由。\n
* **继承自 { QObject }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
currentUrl | url(readonly) | '' | 当前URL
currentPath | string(readonly) | '' | 当前URL路径
currentIndex | int(readonly) | -1 | 当前URL在历史记录中的索引
history | list&lt;HusRouterHistory&gt;(readonly) | - | 历史记录 |
historyMaxCount | int | 100 | 历史记录最大数量
canGoBack | bool(readonly) | - | 是否能后退
canGoForward | bool(readonly) | - | 是否能前进
\n<br/>
\n### \`HusRouterHistory\` 支持的属性：\n
属性名 | 类型 | 描述
----- | --- | ---
location | url | 本条历史地址
\n<br/>
\n### 支持的函数：\n
- \`push(url: url)\` 导航到指定URL并将新URL添加到历史记录的顶部 \n
- \`replace(url: url)\` 替换当前URL并将老的URL从历史记录中移除, 然后将新URL添加到历史记录顶部 \n
- \`clear()\` 清空所有导航历史 \n
- \`goBack()\` 后退到历史记录中的上一个URL \n
- \`goForward()\` 前进到历史记录中的下一个URL \n
- \`getQueryParams(url: url)\` 以键值对的形式返回URL中的查询字符串 \n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要进行URL路由时使用。\n
                       `)
        }

        ThemeToken { }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
简单的分组导航，通过导航URL获取信息并进行展示。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import HuskarUI.Basic

                Item {
                    height: 200

                    Rectangle {
                        anchors.fill: rowLayout
                        anchors.margins: -5
                        anchors.leftMargin: 0
                        radius: 5
                        color: HusTheme.Primary.colorFillQuaternary
                        border.color: HusTheme.Primary.colorBorder
                    }

                    RowLayout {
                        id: rowLayout
                        width: 500
                        height: parent.height
                        spacing: 0

                        HusRouter { id: infoRouter }

                        HusTreeView {
                            Layout.preferredWidth: 200
                            Layout.fillHeight: true
                            genDefaultKey: true
                            showIcon: true
                            showLine: true
                            initModel: [
                                {
                                    id: '1',
                                    title: 'Group 1',
                                    group: 'Group1',
                                    iconSource: HusIcon.GroupOutlined,
                                    children: [
                                        { title: 'User 1', id: '1' },
                                        { title: 'User 2', id: '2' },
                                    ],
                                },
                                {
                                    id: '2',
                                    title: 'Group 2',
                                    group: 'Group2',
                                    iconSource: HusIcon.GroupOutlined,
                                    children: [
                                        { title: 'User 11', id: '3' },
                                        { title: 'User 22', id: '4' },
                                    ],
                                },
                            ]
                            onSelectedKeyChanged: {
                                const idx = index(selectedKey.split('-'));
                                const data = getNodeData(idx);
                                if (idx.parent.valid) {
                                    const parentData = getNodeData(idx.parent);
                                    const path = \`https://127.0.0.1/api/group/user?group=\${parentData.group}&id=\${data.id}\`
                                    infoRouter.push(path);
                                } else {
                                    const path = \`https://127.0.0.1/api/group?id=\${data.id}\`
                                    infoRouter.push(path);
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            HusInput {
                                Layout.fillWidth: true
                                readOnly: true
                                text: infoRouter.currentUrl
                                onTextChanged: {
                                    const queryParams = infoRouter.getQueryParams(text);
                                    if (queryParams.group) {
                                        infoCard.title = queryParams.group + '-user';
                                    } else {
                                        infoCard.title = 'Group';
                                    }
                                    infoCard.bodyDescription = 'ID: ' + queryParams.id;
                                }

                                HusToolTip {
                                    text: parent.text
                                    visible: parent.hovered
                                }
                            }

                            HusCard {
                                id: infoCard
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            `
            exampleDelegate: Item {
                height: 200

                Rectangle {
                    anchors.fill: rowLayout
                    anchors.margins: -5
                    anchors.leftMargin: 0
                    radius: 5
                    color: HusTheme.Primary.colorFillQuaternary
                    border.color: HusTheme.Primary.colorBorder
                }

                RowLayout {
                    id: rowLayout
                    width: 500
                    height: parent.height
                    spacing: 0

                    HusRouter { id: infoRouter }

                    HusTreeView {
                        Layout.preferredWidth: 200
                        Layout.fillHeight: true
                        genDefaultKey: true
                        showIcon: true
                        showLine: true
                        initModel: [
                            {
                                id: '1',
                                title: 'Group 1',
                                group: 'Group1',
                                iconSource: HusIcon.GroupOutlined,
                                children: [
                                    { title: 'User 1', id: '1' },
                                    { title: 'User 2', id: '2' },
                                ],
                            },
                            {
                                id: '2',
                                title: 'Group 2',
                                group: 'Group2',
                                iconSource: HusIcon.GroupOutlined,
                                children: [
                                    { title: 'User 11', id: '3' },
                                    { title: 'User 22', id: '4' },
                                ],
                            },
                        ]
                        onSelectedKeyChanged: {
                            const idx = index(selectedKey.split('-'));
                            const data = getNodeData(idx);
                            if (idx.parent.valid) {
                                const parentData = getNodeData(idx.parent);
                                const path = `https://127.0.0.1/api/group/user?group=${parentData.group}&id=${data.id}`
                                infoRouter.push(path);
                            } else {
                                const path = `https://127.0.0.1/api/group?id=${data.id}`
                                infoRouter.push(path);
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        HusInput {
                            Layout.fillWidth: true
                            readOnly: true
                            text: infoRouter.currentUrl
                            onTextChanged: {
                                const queryParams = infoRouter.getQueryParams(text);
                                if (queryParams.group) {
                                    infoCard.title = queryParams.group + '-user';
                                } else {
                                    infoCard.title = 'Group';
                                }
                                infoCard.bodyDescription = 'ID: ' + queryParams.id;
                            }

                            HusToolTip {
                                text: parent.text
                                visible: parent.hovered
                            }
                        }

                        HusCard {
                            id: infoCard
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
