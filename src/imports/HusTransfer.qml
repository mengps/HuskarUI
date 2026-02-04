/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the 'Software'), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided 'as is', without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts
import HuskarUI.Basic

T.Control {
    id: control

    signal change(nextTargetKeys: var, direction: string, moveKeys: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property var dataSource: []
    readonly property alias sourceKeys: __private.sourceKeys
    property var targetKeys: []
    property alias sourceCheckedKeys: __sourceList.checkedKeys
    property alias targetCheckedKeys: __targetList.checkedKeys
    property alias defaultSourceCheckedKeys: __sourceList.defaultCheckedKeys
    property alias defaultTargetCheckedKeys: __targetList.defaultCheckedKeys
    readonly property alias sourceCount: __sourceList.totalCount
    readonly property alias targetCount: __targetList.totalCount
    readonly property int sourceCheckedCount: sourceCheckedKeys.length
    readonly property int targetCheckedCount: targetCheckedKeys.length
    property var titles: ['Source', 'Target']
    property var operations: ['>', '<']
    property bool showSearch: false
    property var filterOption: (value, record) => String(record.title).includes(value)
    property string searchPlaceholder: 'Search here'
    property var pagination: false ?? {}
    property bool oneWay: false
    property font titleFont: Qt.font({
                                         family: themeSource.fontFamilyTitle,
                                         pixelSize: parseInt(themeSource.fontSizeTitle)
                                     })
    property color colorTitle: themeSource.colorColumnTitle
    property color colorText: themeSource.colorText
    property color colorBg: themeSource.colorBg
    property color colorBorder: themeSource.colorBorder
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property var themeSource: HusTheme.HusTransfer

    property alias sourceTableView: __sourceList.view
    property alias targetTableView: __targetList.view

    property Component titleDelegate: RowLayout {
        HusText {
            Layout.alignment: Qt.AlignLeft
            leftPadding: 8
            font: control.titleFont
            text: numberText + qsTr('项')
            color: control.colorTitle
            verticalAlignment: Text.AlignVCenter
            property string numberText: onLeft ? `${control.sourceCheckedCount}/${control.sourceCount} ` :
                                                 `${control.targetCheckedCount}/${control.targetCount} `
        }

        HusText {
            Layout.alignment: Qt.AlignRight
            rightPadding: 8
            font: control.titleFont
            text: title
            color: control.colorTitle
            verticalAlignment: Text.AlignVCenter
        }
    }
    property Component searchInputDelegate: HusInput {
        iconSource: HusIcon.SearchOutlined
        placeholderText: control.searchPlaceholder
        clearEnabled: true
        onTextChanged: control.filter(text, onLeft ? 'left' : 'right');
    }
    property Component rightActionDelegate: HusButton {
        padding: 8 * sizeRatio
        topPadding: 4 * sizeRatio
        bottomPadding: 4 * sizeRatio
        text: control.operations[0]
        type: HusButton.Type_Primary
        enabled: control.sourceCheckedKeys.length > 0 && control.enabled
        onClicked: {
            targetKeys = [...sourceCheckedKeys, ...targetKeys];
            control.clearAllCheckedKeys('left');
            control.change(targetKeys, 'right', [...sourceCheckedKeys]);
        }
    }
    property Component leftActionDelegate: HusButton {
        padding: 8 * sizeRatio
        topPadding: 4 * sizeRatio
        bottomPadding: 4 * sizeRatio
        text: control.operations[1]
        type: HusButton.Type_Primary
        enabled: control.targetCheckedKeys.length > 0 && control.enabled && !control.oneWay
        visible: !control.oneWay
        onClicked: {
            const targetKeysSet = new Set;
            targetCheckedKeys.forEach(key => targetKeysSet.add(key));
            targetKeys = targetKeys.filter(key => !targetKeysSet.has(key));
            control.clearAllCheckedKeys('right');
            control.change(targetKeys, 'left', targetKeysSet.keys());
        }
    }
    property Component emptyDelegate: HusEmpty { description: qsTr('暂无数据') }

    function clearAllCheckedKeys(direction = 'left') {
        if (direction === 'left') {
            sourceTableView.clearAllCheckedKeys();
        } else {
            targetTableView.clearAllCheckedKeys();
        }
    }

    function filter(text: string, direction = 'left') {
        if (direction === 'left') {
            __sourceList.filterString = text;
            __sourceList.filter();
        } else {
            __targetList.filterString = text;
            __targetList.filter();
        }
    }

    onTargetKeysChanged: __private.resetData();

    objectName: '__HusTransfer__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    spacing: 4
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }
    contentItem: RowLayout {
        spacing: control.spacing

        TransferList {
            id: __sourceList
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: control.titles[0]
            onLeft: true
        }

        Column {
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Loader {
                sourceComponent: control.rightActionDelegate
            }

            Loader {
                sourceComponent: control.leftActionDelegate
            }
        }

        TransferList {
            id: __targetList
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: control.titles[1]
            onLeft: false
        }
    }

    QtObject {
        id: __private

        property alias sourceData: __sourceList.initData
        property var sourceKeys: []
        property alias targetData: __targetList.initData

        function resetData() {
            const targetKeysSet = new Set;
            const __sourceData = [], __sourceKeys = [], __targetData = [];
            targetKeys.forEach(key => targetKeysSet.add(key));
            control.dataSource.forEach(
                        object => {
                            if (object.hasOwnProperty('key')) {
                                if (targetKeysSet.has(object.key)) {
                                    __targetData.push(object);
                                } else {
                                    __sourceData.push(object);
                                    __sourceKeys.push(object.key);
                                }
                            }
                        });
            sourceData = __sourceData;
            sourceKeys = __sourceKeys;
            targetData = __targetData;

            __sourceList.filter();
            __targetList.filter();
        }
    }

    component TransferList: T.Control {
        id: __transferListRoot

        property var initData: []
        property var filteredData: []
        property string filterString: ''

        property alias totalCount: __pagination.total
        property alias view: __transferView
        property alias onLeft: __transferView.onLeft
        property alias title: __transferView.title
        property alias rowCount: __transferView.rowCount
        property alias checkedKeys: __transferView.checkedKeys
        property alias defaultCheckedKeys: __transferView.defaultCheckedKeys
        property alias initModel: __transferView.initModel

        function filter() {
            let data = initData;
            if (control.showSearch && filterString !== '') {
                data = data.filter(item => control.filterOption(filterString, item));
            }
            filteredData = data;
            refreshData();
        }

        function refreshData() {
            if (typeof control.pagination === 'object') {
                const start = __pagination.currentPageIndex * __pagination.pageSize;
                const end = start + __pagination.pageSize;
                __transferView.initModel = filteredData.slice(start, end);
            } else {
                __transferView.initModel = filteredData;
            }
        }

        padding: background.border.width
        topPadding: Math.max(8, control.radiusBg.topLeft, control.radiusBg.topRight)
        bottomPadding: Math.max(8, control.radiusBg.bottomLeft, control.radiusBg.bottomRight)
        contentItem: ColumnLayout {
            spacing: 0

            Loader {
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                Layout.fillWidth: true
                active: control.showSearch
                visible: active
                sourceComponent: control.searchInputDelegate
                property bool onLeft: __transferView.onLeft
            }

            HusTableView {
                id: __transferView
                Layout.fillWidth: true
                Layout.fillHeight: true
                animationEnabled: control.animationEnabled
                themeSource: control.themeSource
                color: control.colorBg
                colorColumnHeaderBg: 'transparent'
                columnResizable: false
                showRowHeader: false
                defaultColumnHeaderHeight: 32
                minimumRowHeight: 32
                topLeftRadius: 0
                topRightRadius: 0
                columnHeaderFilterIconDelegate: null
                columnHeaderTitleDelegate: Loader{
                    sourceComponent: control.titleDelegate
                    property bool onLeft: __transferView.onLeft
                    property string title: __transferView.title
                }
                columns: [
                    {
                        width: __transferView.width,
                        title: __transferView.title,
                        delegate: __textDelegate,
                        dataIndex: 'title',
                        selectionType: 'checkbox',
                    }
                ]

                property bool onLeft: true
                property string title: ''

                Component {
                    id: __textDelegate

                    HusText {
                        leftPadding: 8
                        font: control.font
                        text: cellData
                        color: enabled ? control.colorText : control.themeSource.colorTextDisabled
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: {
                                __transferView.toggleForRows([row]);
                            }
                        }
                    }
                }

                Loader {
                    anchors.top: parent.top
                    anchors.topMargin: parent.defaultColumnHeaderHeight
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: parent.rowCount === 0
                    sourceComponent: control.emptyDelegate
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                active: typeof control.pagination === 'object'
                visible: active
                sourceComponent: HusDivider { }
            }

            HusPagination {
                id: __pagination
                Layout.topMargin: 8
                Layout.alignment: Qt.AlignHCenter
                clip: true
                visible: typeof control.pagination === 'object'
                sizeHint: 'small'
                total: filteredData.length
                pageSize: control.pagination?.pageSize ?? 10
                pageButtonMaxCount: control.pagination?.pageButtonMaxCount ?? 7
                showQuickJumper: control.pagination?.showQuickJumper ?? false
                defaultButtonSpacing: control.pagination?.defaultButtonSpacing ?? 8 * sizeRatio
                onCurrentPageIndexChanged: __transferListRoot.refreshData();
            }
        }
        background: HusRectangleInternal {
            color: control.colorBg
            border.color: control.colorBorder
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
        }
    }
}
