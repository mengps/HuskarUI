/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

pragma ComponentBehavior: Unbound

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Templates as T
import Qt.labs.qmlmodels
import HuskarUI.Basic

T.Control {
    id: control

    enum Style
    {
        SolidLine = 0,
        DashLine = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property alias reuseItems: __treeView.reuseItems
    property bool checkable: false
    property bool blockNode: false
    property bool genDefaultKey: true
    property real indent: 18
    property bool showIcon: false
    property int defaultNodeIconSize: 16
    property bool showLine: false
    property int lineStyle: HusTreeView.SolidLine
    property real lineWidth: 1
    property list<real> dashPattern: [4, 4]
    property var switcherIconSouce: HusIcon.CaretRightOutlined ?? ''
    property int switcherIconSize: 12
    property alias rowSpacing: __treeView.rowSpacing
    property var defaultCheckedKeys: []
    property var checkedKeys: []
    property string selectedKey: ''
    property var initModel: []
    property alias titleFont: control.font
    property color colorLine: themeSource.colorLine
    property HusRadius radiusSwitcherBg: HusRadius { all: themeSource.radiusSwitcherBg }
    property HusRadius radiusTitleBg: HusRadius { all: themeSource.radiusTitleBg }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusTreeView

    property alias verScrollBar: __vScrollBar
    property alias horScrollBar: __hScrollBar
    property alias treeView: __treeView
    property alias treeModel: __treeModel

    property Component switcherDelegate: HusRectangleInternal {
        radius: control.radiusSwitcherBg.all
        topLeftRadius: control.radiusSwitcherBg.topLeft
        topRightRadius: control.radiusSwitcherBg.topRight
        bottomLeftRadius: control.radiusSwitcherBg.bottomLeft
        bottomRightRadius: control.radiusSwitcherBg.bottomRight
        color: enabled ? __expandHover.hovered ?
                             control.themeSource.colorBgHover :
                             control.themeSource.colorBg : control.themeSource.colorBgDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

        HusIconText {
            anchors.centerIn: parent
            iconSource: control.switcherIconSouce
            iconSize: control.switcherIconSize
            verticalAlignment: Text.AlignVCenter
            rotation: isExpanded ? 90 : 0
        }

        HoverHandler {
            id: __expandHover
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            onTapped: {
                __treeView.toggleExpanded(row);
            }
        }
    }
    property Component nodeContentDelegate: Item {
        implicitWidth: __layout.implicitWidth
        implicitHeight: __layout.implicitHeight

        HoverHandler {
            id: __selectHover
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        }

        TapHandler {
            enabled: parent.enabled
            onTapped: control.selectedKey = treeData?.key ?? '';
        }

        HusRectangleInternal {
            anchors.fill: parent
            radius: control.radiusTitleBg.all
            topLeftRadius: control.radiusTitleBg.topLeft
            topRightRadius: control.radiusTitleBg.topRight
            bottomLeftRadius: control.radiusTitleBg.bottomLeft
            bottomRightRadius: control.radiusTitleBg.bottomRight
            color: {
                if (isSelected) {
                    return HusTheme.isDark ? control.themeSource.colorSelectionDark :
                                             control.themeSource.colorSelection;
                } else {
                    return __selectHover.hovered ? control.themeSource.colorBgHover :
                                                   control.themeSource.colorBg;
                }
            }
        }

        RowLayout {
            id: __layout
            width: control.blockNode ? parent.width : implicitWidth
            anchors.verticalCenter: parent.verticalCenter

            Loader {
                id: __icon
                Layout.leftMargin: 6
                active: control.showIcon
                visible: active
                sourceComponent: HusIconText {
                    Layout.alignment: Qt.AlignVCenter
                    iconSource: treeData?.iconSource ?? 0
                    iconSize: treeData?.iconSize ?? control.defaultNodeIconSize
                }
            }

            HusText {
                Layout.fillWidth: control.blockNode
                Layout.leftMargin: __icon.visible ? 0 : 6
                Layout.rightMargin: 6
                padding: 2
                font: control.font
                text: treeData?.title ?? ''
                color: enabled ? control.themeSource.colorTitle : control.themeSource.colorTitleDisabled
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    property Component nodeBgDelegate: Item { }

    function clear() {
        initModel = [];
    }

    function checkForKeys(keys: var) {
        __private.checkForKeys(keys);
    }

    function expandForKeys(keys: var) {
        __private.expandForKeys(keys);
    }

    function expandToIndex(index: var) {
        __treeView.expandToIndex(index);
    }

    function collapseToIndex(index: var) {
        __treeView.collapse(__treeView.rowAtIndex(index));
    }

    function expandAll() {
        __treeView.expandRecursively();
    }

    function collapseAll() {
        __treeView.collapseRecursively();
    }

    function index(treePath: var): var {
        return __treeModel.index(treePath, 0);
    }

    function appendNode(parentIndex: var, data: var) {
        if (parentIndex.valid) {
            const parentData = __treeModel.getRow(parentIndex);
            let newRowIndex = 0;
            if (parentData.hasOwnProperty('rows'))
                newRowIndex = parentData.rows.length;
            const treePath = [...parentData.__data.treePath, newRowIndex];
            __treeModel.appendRow(parentIndex, __private.initObject(data, treePath));
        } else {
            /*! 无效则将追加到根节点(TreeModel默认行为) */
            __treeModel.appendRow(parentIndex, __private.initObject(data, [__treeModel.rows.length]));
        }
    }

    function removeNode(index: var) {
        if (index.valid) {
            __treeModel.removeRow(index);
        }
    }

    function moveNode(fromIndex: var, toIndex: var) {
        const row = __treeModel.getRow(fromIndex);
        appendNode(toIndex);
        removeNode(fromIndex);
    }

    function setNodeData(index: var, data: var) {
        if (index.valid) {
            __treeModel.setData(index, data, 'display');
        }
    }

    function getNodeData(index: var): var {
        if (index.valid) {
            return __treeModel.data(index, 'display');
        } else {
            return undefined;
        }
    }

    onCheckableChanged: checkForKeys(defaultCheckedKeys);
    onDefaultCheckedKeysChanged: checkForKeys(defaultCheckedKeys);
    onInitModelChanged: {
        __private.clearCheckedKeys();
        __treeModel.rows = __private.initRows(initModel);
    }

    objectName: '__HusTreeView__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 4
    spacing: 4
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    background: Item { }
    contentItem: TreeView {
        id: __treeView
        implicitWidth: contentWidth
        implicitHeight: contentHeight
        boundsBehavior: Flickable.StopAtBounds
        reuseItems: false
        rowSpacing: 4
        T.ScrollBar.horizontal: __hScrollBar
        T.ScrollBar.vertical: __vScrollBar
        selectionModel: ItemSelectionModel { }
        model: TreeModel {
            id: __treeModel
            onModelReset: control.checkForKeys(control.defaultCheckedKeys);

            TableModelColumn { display: '__data' }
        }
        delegate: T.TreeViewDelegate {
            id: __rootItem
            clip: false
            implicitWidth: __rowLayout.implicitWidth
            implicitHeight: __rowLayout.implicitHeight
            background: Loader {
                sourceComponent: control.nodeBgDelegate
                property alias row: __rootItem.row
                property alias depth: __rootItem.depth
                property alias treeData: __rootItem.treeData
                property alias isSelected: __rootItem.isSelected
                property alias isExpanded: __rootItem.expanded
            }
            Component.onCompleted: {
                if (depth > 0) {
                    let index = __treeModel.index(treeData.treePath, 0).parent;
                    for (let i = 1; i < depth; ++i) {
                        index = index.parent;
                        const siblingIndex = treeData.treePath[depth - i];
                        depthLine[depth - 1 - i] = !indexIsLastNode(index, siblingIndex);
                    }
                    /*! 最后一条线必为 true */
                    depthLine[depth - 1] = true;
                    depthLineChanged();
                }
            }

            required property int row
            required property var model

            property var treeData: model.display
            property string key: model.display?.key ?? ''
            property bool isLastNode: pathIsLastNode(treeData.treePath)
            property bool isRootNode: depth === 0
            property bool isSelected: control.selectedKey === key
            property int checkState: model.display.checkState
            property string delegateUrl: treeData?.delegateUrl ?? ''
            property bool contentEnabled: model.display?.enabled ?? true
            property bool checkboxDisabled: model.display?.checkboxDisabled ?? false
            property var depthLine: new Array(depth)

            function pathIsLastNode(treePath: var): bool {
                if (treePath.length > 1) {
                    const parentIndex = __treeModel.index(treePath, 0).parent;
                    return indexIsLastNode(parentIndex, treePath[treePath.length - 1]);
                }
                return false;
            }

            function indexIsLastNode(index: var, siblingIndex: int): bool {
                if (index.valid) {
                    const siblingCount = __treeModel.getRow(index).rows.length;
                    return siblingIndex === (siblingCount - 1);
                }
                return false;
            }

            RowLayout {
                id: __rowLayout
                width: control.blockNode ? __treeView.width : implicitWidth
                spacing: control.spacing

                /*! 占位用 */
                Item {
                    Layout.fillHeight: true
                    Layout.leftMargin: __rootItem.depth * control.indent

                    /*! 深度线 */
                    Loader {
                        height: parent.height
                        active: control.showLine && !__rootItem.isRootNode
                        visible: active
                        sourceComponent: Item {
                            id: __linkLineItem
                            property real fullHeight: height + control.rowSpacing

                            Repeater {
                                model: __rootItem.depthLine
                                delegate: Loader {
                                    active: __rootItem.depthLine[index] ?? false
                                    sourceComponent: LinkLine {
                                        startX: -control.indent * (__rootItem.depth - 1) + (control.indent - control.lineWidth) * index
                                        startY: 1
                                        endX: startX
                                        endY: (__rootItem.isLastNode && index === __rootItem.depth - 1) ?
                                                  __linkLineItem.height * 0.5 : __linkLineItem.fullHeight
                                    }
                                    required property int index
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24

                    Loader {
                        x: -__rowLayout.spacing - 1
                        width: 6
                        height: control.lineWidth
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 1
                        active: control.showLine && __rootItem.isLastNode && __rootItem.hasChildren
                        sourceComponent: LinkLine {
                            startX: control.lineWidth
                            startY: control.lineWidth
                            endX: width
                            endY: control.lineWidth
                        }
                    }

                    Loader {
                        x: -__rowLayout.spacing - 1
                        width: 24
                        height: control.lineWidth
                        anchors.verticalCenter: parent.verticalCenter
                        active: control.showLine && !__rootItem.hasChildren && !__rootItem.isRootNode
                        sourceComponent: LinkLine {
                            startX: control.lineWidth
                            startY: control.lineWidth
                            endX: width
                            endY: control.lineWidth
                        }
                    }

                    Loader {
                        anchors.fill: parent
                        active: __rootItem.hasChildren
                        sourceComponent: control.switcherDelegate
                        property alias row: __rootItem.row
                        property alias depth: __rootItem.depth
                        property alias treeData: __rootItem.treeData
                        property alias isSelected: __rootItem.isSelected
                        property alias isExpanded: __rootItem.expanded
                    }
                }

                Loader {
                    active: control.checkable
                    visible: active
                    sourceComponent: HusCheckBox {
                        animationEnabled: control.animationEnabled
                        enabled: __rootItem.contentEnabled && !__rootItem.checkboxDisabled
                        checkState: __rootItem.checkState
                        onToggled: {
                            __rootItem.model.display.checkState = checkState;
                            __private.updateTreeNodeCheckState(__rootItem.treeData.treePath, checkState);
                        }
                    }
                }

                Loader {
                    Layout.fillWidth: control.blockNode
                    Layout.fillHeight: true
                    enabled: __rootItem.contentEnabled
                    source: __rootItem.delegateUrl
                    sourceComponent: __rootItem.delegateUrl === '' ? control.nodeContentDelegate : undefined
                    property alias row: __rootItem.row
                    property alias depth: __rootItem.depth
                    property alias treeData: __rootItem.treeData
                    property alias isSelected: __rootItem.isSelected
                    property alias isExpanded: __rootItem.expanded
                }
            }
        }
    }

    QtObject {
        id: __private

        property var checkedKeysSet: new Set

        function treeEqual(treePath1: var, treePath2: var): bool {
            if (treePath1.length !== treePath2.length) return false;
            return treePath1.every((value, index) => value === treePath2[index]);
        }

        function isSubNode(rootTree: var, subTree: var): bool {
            if (rootTree.length > subTree.length) return false;
            return rootTree.every((value, index) => value === subTree[index]);
        }

        function updateSubNodeCheckState(rootPath: var, object: var, checkState: int, skipDisabled = true) {
            const data = object.__data;
            const nodeTreePath = data.treePath;
            if (isSubNode(rootPath, nodeTreePath)) {
                if (data.enabled && !data.checkboxDisabled) {
                    /*! 更新模型 */
                    updateModelCheckState(data, nodeTreePath, checkState);
                } else {
                    if (!skipDisabled) {
                        updateModelCheckState(data, nodeTreePath, checkState);
                    }
                    /*! 不处理禁用节点下的所有子节点 */
                    return;
                }
            }
            if (object.hasOwnProperty('rows')) {
                /*! 更新子节点 */
                object.rows.forEach(o => updateSubNodeCheckState(rootPath, o, checkState));
            }
        }

        function updateModelCheckState(nodeData: var, treePath: var, checkState: int) {
            const newData = Object.assign({}, nodeData);
            newData.checkState = checkState;
            const index = __treeModel.index(treePath, 0);
            __treeModel.setData(index, newData, 'display');
            /*! 更新选中键表 */
            updateKeyCheckState(nodeData.key, checkState);
        }

        function calcTreeNodeCheckState(node: var): int {
            const nodeData = node.__data;
            const nodeTreePath = nodeData.treePath;
            let checkableCount = 0;
            let checkedCount = 0;
            let partiallyCheckedCount = 0;
            if (node.hasOwnProperty('rows')) {
                node.rows.forEach(
                            o => {
                                const data = o.__data;
                                if (data.enabled && !data.checkboxDisabled) {
                                    checkableCount++
                                    /*! 计算该节点状态 */
                                    let checkState = Qt.Unchecked;
                                    if (o.hasOwnProperty('rows')) {
                                        checkState = calcTreeNodeCheckState(o);
                                    } else {
                                        checkState = data.checkState;
                                    }
                                    /*! 统计 */
                                    if (checkState === Qt.PartiallyChecked) {
                                        partiallyCheckedCount++;
                                    } else if (checkState === Qt.Checked) {
                                        checkedCount++;
                                    }
                                }
                            });
            }
            /*! 汇总 */
            let checkState = Qt.Unchecked;
            if (checkableCount > 0) {
                if (checkableCount === checkedCount) {
                    checkState = Qt.Checked;
                } else if (partiallyCheckedCount > 0 || (checkedCount > 0 && checkableCount > 1)){
                    checkState = Qt.PartiallyChecked;
                }
            }

            updateModelCheckState(nodeData, nodeTreePath, checkState);

            return checkState;
        }

        function updateRootTreeCheckState(object: var) {
            const data = object.__data;
            updateModelCheckState(data, data.treePath, calcTreeNodeCheckState(object));
        }

        function updateTreeNodeCheckState(treePath: var, checkState: int) {
            if (control.checkable) {
                /*! 先更新该节点下所有子节点状态 */
                const index = __treeModel.index(treePath, 0);
                const subTreeNode = __treeModel.getRow(index);
                updateSubNodeCheckState(treePath, subTreeNode, checkState);
                for (const row of __treeModel.rows) {
                    /* 仅更新本节点的根子树 */
                    if (row.__data.treePath[0] === treePath[0]) {
                        /*! 非根子树则需要更新整条链路状态 */
                        const rootPath = [treePath[0]];
                        if (!treeEqual(rootPath, treePath)) {
                            updateRootTreeCheckState(row);
                        }
                        /*! 更新选中键 */
                        updateCheckedKeys();
                        break;
                    }
                }
            }
        }

        function updateKeyCheckState(key: string, checkState: int) {
            /*! 选中和部分选中都视为选中 */
            if (checkState === Qt.Checked || checkState === Qt.PartiallyChecked) {
                if (!hasCheckedKey(key)) {
                    checkedKeysSet.add(key);
                }
            } else {
                if (hasCheckedKey(key)) {
                    checkedKeysSet.delete(key);
                }
            }
        }

        function addCheckedKey(key: string) {
            if (!hasCheckedKey(key)) {
                checkedKeysSet.set(key, true);
                updateCheckedKeys();
            }
        }

        function removeCheckedKey(key: string) {
            if (hasCheckedKey) {
                checkedKeysSet.delete(key);
                updateCheckedKeys();
            }
        }

        function hasCheckedKey(key: string): bool {
            return checkedKeysSet.has(key);
        }

        function clearCheckedKeys() {
            checkedKeysSet.clear();
            updateCheckedKeys();
        }

        function updateCheckedKeys() {
            control.checkedKeys = [...checkedKeysSet.keys()];
        }

        function checkForKeys(keys: var) {
            if (keys.length > 0) {
                const keysSet = new Set;
                keys.forEach(key => keysSet.add(key));
                const checkForNode = (node) => {
                    if (keysSet.size > 0) {
                        const data = node.__data;
                        if (keysSet.has(data.key)) {
                            updateSubNodeCheckState(data.treePath, node, Qt.Checked, false);
                            /*! 更新完成移除键,确保不会有多余计算 */
                            keysSet.delete(data.key);
                        } else {
                            if (node.hasOwnProperty('rows')) {
                                node.rows.forEach(o => checkForNode(o));
                            }
                        }
                    }
                }
                for (const row of __treeModel.rows) {
                    if (keysSet.size > 0) {
                        checkForNode(row);
                        updateRootTreeCheckState(row);
                    }
                }
                updateCheckedKeys();
            }
        }

        function expandForKeys(keys: var) {
            if (keys.length > 0) {
                const keysSet = new Set;
                keys.forEach(key => keysSet.add(key));
                const expandForNode = (node) => {
                    if (keysSet.size > 0) {
                        const data = node.__data;
                        const hasChildren = node.hasOwnProperty('rows');
                        if (keysSet.has(data.key)) {
                            const index = __treeModel.index(data.treePath, 0);
                            if (hasChildren) {
                                /*! 需要展开到子项 */
                                const subIndex = __treeModel.index([...data.treePath, 0], 0);
                                __treeView.expandToIndex(subIndex);
                            } else {
                                __treeView.expandToIndex(index);
                            }
                            /*! 更新完成移除键,确保不会有多余计算 */
                            keysSet.delete(data.key);
                        } else {
                            if (hasChildren) {
                                node.rows.forEach(o => expandForNode(o));
                            }
                        }
                    }
                }
                for (const row of __treeModel.rows) {
                    if (keysSet.size > 0) {
                        expandForNode(row);
                    }
                }
            }
        }

        function initRows(rows: var, treePath = []) {
            const newRows = [];
            for (let i = 0; i < rows.length; i++) {
                const object = rows[i];
                newRows.push(initObject(object, [...treePath, i]));
            }
            return newRows;
        }

        function initObject(object: var, treePath: var): var {
            const newObject = {
                __data: object?.__data ?? {},
            };

            for (const k in object) {
                if (k !== 'children') {
                    newObject.__data[k] = object[k];
                }
            }

            newObject.__data.treePath = [...treePath];
            newObject.__data.checkState = Qt.Unchecked;

            /*! 创建默认键 */
            if (control.genDefaultKey) {
                if (!newObject.__data.hasOwnProperty('key')) {
                    newObject.__data.key = newObject.__data.treePath.join('-');
                }
            }

            if (!object.hasOwnProperty('enabled')) {
                newObject.__data.enabled = true;
            }

            if (!object.hasOwnProperty('checkboxDisabled')) {
                newObject.__data.checkboxDisabled = false;
            }

            if (object.hasOwnProperty('children')) {
                newObject.rows = initRows(object.children, [...treePath]);
            }

            return newObject;
        }

        onCheckedKeysSetChanged: updateCheckedKeys();
    }

    component LinkLine: Shape {
        id: __shape
        property real startX: 0
        property real startY: 0
        property real endX: 0
        property real endY: 0

        ShapePath {
            strokeStyle: control.lineStyle === HusTreeView.SolidLine ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorLine
            strokeWidth: control.lineWidth
            dashPattern: control.dashPattern
            fillColor: 'transparent'
            startX: __shape.startX
            startY: __shape.startY

            PathLine {
                x: __shape.endX
                y: __shape.endY
            }
        }
    }

    HusScrollBar {
        id: __hScrollBar
        z: 11
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        animationEnabled: control.animationEnabled
    }

    HusScrollBar {
        id: __vScrollBar
        z: 12
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        animationEnabled: control.animationEnabled
    }

    Accessible.role: Accessible.Tree
    Accessible.description: control.contentDescription
}
