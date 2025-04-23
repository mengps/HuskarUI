import QtQuick
import QtQuick.Templates as T
import Qt.labs.qmlmodels
import DelegateUI

DelRectangle {
    id: control

    clip: true
    color: DelTheme.Primary.colorBgBase
    topLeftRadius : 6
    topRightRadius: 6

    columnHeaderTitleFont {
        family: DelTheme.DelTableView.fontFamily
        pixelSize: DelTheme.DelTableView.fontSize
    }
    rowHeaderTitleFont {
        family: DelTheme.DelTableView.fontFamily
        pixelSize: DelTheme.DelTableView.fontSize
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property bool alternatingRow: false
    property int defaultColumnHeaderHeight: 40
    property int defaultRowHeaderWidth: 40
    property bool columnGridVisible: false
    property bool rowGridVisible: false
    property real minimumRowHeight: 40
    property real maximumRowHeight: Number.NaN
    property var initModel: []
    property var columns: []
    property var checkedKeys: []

    property color colorGridLine: DelTheme.DelTableView.colorGridLine

    property bool columnHeaderVisible: true
    property font columnHeaderTitleFont
    property color colorColumnHeaderTitle: DelTheme.DelTableView.colorColumnTitle
    property color colorColumnHeaderBg: DelTheme.DelTableView.colorColumnHeaderBg

    property bool rowHeaderVisible: true
    property font rowHeaderTitleFont
    property color colorRowHeaderTitle: DelTheme.DelTableView.colorRowTitle
    property color colorRowHeaderBg: DelTheme.DelTableView.colorRowHeaderBg

    property color colorResizeBlockBg: DelTheme.DelTableView.colorResizeBlockBg

    property Component columnHeaderDelegate: Item {
        id: __columnHeaderDelegate
        property bool editable: headerData.editable ?? false
        property string align: headerData.align ?? 'center'
        property string selectionType: headerData.selectionType ?? ''
        property var sorter: headerData.sorter
        property var sortDirections: headerData.sortDirections ?? []
        property var onFilter: headerData.onFilter

        Text {
            anchors {
                left: __checkBoxLoader.active ? __checkBoxLoader.right : parent.left
                leftMargin: __checkBoxLoader.active ? 0 : 10
                right: parent.right
                rightMargin: 10
                top: parent.top
                topMargin: 4
                bottom: parent.bottom
                bottomMargin: 4
            }
            font: control.columnHeaderTitleFont
            text: headerData.title
            color: control.colorColumnHeaderTitle
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: {
                if (__columnHeaderDelegate.align == 'left')
                    return Text.AlignLeft;
                else if (__columnHeaderDelegate.align == 'right')
                    return Text.AlignRight;
                else
                    return Text.AlignHCenter;
            }
        }

        MouseArea {
            height: parent.height
            anchors.left: __columnHeaderDelegate.editable ? __sorterLoader.left : __checkBoxLoader.right
            anchors.right: __filterLoader.active ? __filterLoader.left : parent.right
            enabled: __sorterLoader.active
            hoverEnabled: true
            onEntered: cursorShape = Qt.PointingHandCursor;
            onExited: cursorShape = Qt.ArrowCursor;
            onClicked: {
                control.sort(column);
                __sorterLoader.sortMode = columns[column].sortMode ?? 'false';
            }
        }

        Loader {
            id: __checkBoxLoader
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            active: __columnHeaderDelegate.selectionType == 'checkbox'
            sourceComponent: DelCheckBox {
                id: __parentBox

                Component.onCompleted: {
                    __parentBox.checkState = __private.parentCheckState;
                }

                onToggled: {
                    if (checkState == Qt.Unchecked) {
                        __private.model.forEach(
                                    object => {
                                        __private.checkedKeysMap.delete(object.key);
                                    });
                        __private.checkedKeysMapChanged();
                    } else {
                        __private.model.forEach(
                                    object => {
                                        __private.checkedKeysMap.set(object.key, true);
                                    });
                        __private.checkedKeysMapChanged();
                    }
                }

                Connections {
                    target: __private
                    function onParentCheckStateChanged() {
                        __parentBox.checkState = __private.parentCheckState;
                    }
                }
            }
        }

        Loader {
            id: __sorterLoader
            anchors.right: __filterLoader.active ? __filterLoader.left : parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            active: sorter !== undefined
            sourceComponent: columnHeaderSorterIconDelegate
            onLoaded: {
                if (sortDirections.length === 0) return;

                let ref = control.columns[column];
                if (!ref.hasOwnProperty('activeSorter')) {
                    ref.activeSorter = false;
                }
                if (!ref.hasOwnProperty('sortIndex')) {
                    ref.sortIndex = -1;
                }
                if (!ref.hasOwnProperty('sortMode')) {
                    ref.sortMode = 'false';
                }
                sortMode = ref.sortMode;
            }
            property int column: model.column
            property alias sorter: __columnHeaderDelegate.sorter
            property alias sortDirections: __columnHeaderDelegate.sortDirections
            property string sortMode: 'false'
        }

        Loader {
            id: __filterLoader
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            active: onFilter !== undefined
            sourceComponent: columnHeaderFilterIconDelegate
            property int column: model.column
            property alias onFilter: __columnHeaderDelegate.onFilter
        }
    }
    property Component rowHeaderDelegate: Item {
        Text {
            anchors {
                left: parent.left
                leftMargin: 8
                right: parent.right
                rightMargin: 8
                top: parent.top
                topMargin: 4
                bottom: parent.bottom
                bottomMargin: 4
            }
            font: control.rowHeaderTitleFont
            text: (row + 1)
            color: control.colorRowHeaderTitle
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
    property Component columnHeaderSorterIconDelegate: Item {
        id: __sorterIconDelegate
        width: __sorterIconColumn.width
        height: __sorterIconColumn.height + 12

        Column {
            id: __sorterIconColumn
            anchors.verticalCenter: parent.verticalCenter
            spacing: -2

            DelIconText {
                visible: sortDirections.indexOf('ascend') !== -1
                colorIcon: sortMode === 'ascend' ? DelTheme.DelTableView.colorIconHover :
                                                   DelTheme.DelTableView.colorIcon
                iconSource: DelIcon.CaretUpOutlined
                iconSize: DelTheme.DelTableView.fontSize - 2
            }

            DelIconText {
                visible: sortDirections.indexOf('descend') !== -1
                colorIcon: sortMode === 'descend' ? DelTheme.DelTableView.colorIconHover :
                                                    DelTheme.DelTableView.colorIcon
                iconSource: DelIcon.CaretDownOutlined
                iconSize: DelTheme.DelTableView.fontSize - 2
            }
        }
    }
    property Component columnHeaderFilterIconDelegate: Item {
        width: __headerFilterIcon.width
        height: __headerFilterIcon.height + 12

        HoverIcon {
            id: __headerFilterIcon
            anchors.centerIn: parent
            iconSource: DelIcon.SearchOutlined
            colorIcon: hovered ? DelTheme.DelTableView.colorIconHover : DelTheme.DelTableView.colorIcon
            onClicked: {
                __filterPopup.open();
            }
        }

        DelPopup {
            id: __filterPopup
            x: -width * 0.5
            y: parent.height
            padding: 5
            contentItem: Column {
                spacing: 5

                DelInput {
                    id: __searchInput
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: qsTr('Search ') + control.columns[column].dataIndex
                    onEditingFinished: __searchButton.clicked();
                    Component.onCompleted: {
                        let ref = control.columns[column];
                        if (ref.hasOwnProperty('filterInput')) {
                            text = ref.filterInput;
                        } else {
                            ref.filterInput = '';
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 5

                    DelIconButton {
                        id: __searchButton
                        text: qsTr('Search')
                        iconSource: DelIcon.SearchOutlined
                        type: DelButton.Type_Primary
                        onClicked: {
                            if (__searchInput.text.length == 0)
                                __filterPopup.close();
                            control.columns[column].filterInput = __searchInput.text;
                            control.filter();
                        }
                    }

                    DelButton {
                        text: qsTr('Reset')
                        onClicked: {
                            if (__searchInput.text.length == 0)
                                __filterPopup.close();
                            __searchInput.clear();
                            control.columns[column].filterInput = '';
                            control.filter();
                        }
                    }

                    DelButton {
                        text: qsTr('Close')
                        type: DelButton.Type_Link
                        onClicked: {
                            __filterPopup.close();
                        }
                    }
                }
            }
        }
    }

    onColumnsChanged: {
        let headerColumns = [];
        let headerRow = {};
        for (const object of columns) {
            let column = Qt.createQmlObject('import Qt.labs.qmlmodels; TableModelColumn {}', __columnHeaderModel);
            column.display = object.dataIndex;
            headerColumns.push(column);
            headerRow[object.dataIndex] = object;
        }

        __columnHeaderModel.clear();
        if (columnHeaderVisible) {
            __columnHeaderModel.columns = headerColumns;
            __columnHeaderModel.rows = [headerRow];
        }

        let cellColumns = [];
        for (let i = 0; i < columns.length; i++) {
            let column = Qt.createQmlObject('import Qt.labs.qmlmodels; TableModelColumn {}', __cellModel);
            column.display = `__data${i}`;
            cellColumns.push(column);
        }
        __cellModel.columns = cellColumns;
    }

    onInitModelChanged: {
        clearSort();
        filter();
    }

    function checkForRows(rows: var) {
        rows.forEach(
                    row => {
                        if (row >= 0 && row < __private.model.length) {
                            const key = __private.model[row].key;
                            __private.checkedKeysMap.set(key, true);
                        }
                    });
        __private.checkedKeysMapChanged();
    }

    function checkForKeys(keys: var) {
        keys.forEach(key => __private.checkedKeysMap.set(object.key, true));
        __private.checkedKeysMapChanged();
    }

    function getCheckedKeys() {
        return [...__private.checkedKeysMap.keys()];
    }

    function clearAllCheckedKeys() {
        __private.checkedKeysMap.clear();
        __private.checkedKeysMapChanged();
        __private.parentCheckState = Qt.Unchecked;
        __private.parentCheckStateChanged();
    }

    function scrollToRow(row) {
        __cellView.positionViewAtRow(row, TableView.AlignVCenter);
        __private.updateParentCheckBox();
    }

    function sort(column) {
        /*! 仅需设置排序相关属性, 真正的排序在 filter() 中完成 */
        if (columns[column].hasOwnProperty('sorter')) {
            columns.forEach(
                        (object, index) => {
                            if (object.hasOwnProperty('sorter')) {
                                if (column === index) {
                                    object.activeSorter = true;
                                    object.sortIndex = (object.sortIndex + 1) % object.sortDirections.length;
                                    object.sortMode = object.sortDirections[object.sortIndex];
                                } else {
                                    object.activeSorter = false;
                                    object.sortIndex = -1;
                                    object.sortMode = 'false';
                                }
                            }
                        });
        }

        filter();
    }

    function clearSort() {
        columns.forEach(
                    object => {
                        if (object.sortDirections && object.sortDirections.length !== 0) {
                            object.activeSorter = false;
                            object.sortIndex = -1;
                            object.sortMode = 'false';
                        }
                    });
        __private.model = [...initModel];
    }

    function filter() {
        /*! 先过滤 */
        let changed = false;
        let model = [...initModel];
        columns.forEach(
                    object => {
                        if (object.hasOwnProperty('onFilter') && object.hasOwnProperty('filterInput')) {
                            model = model.filter((record, index) => object.onFilter(object.filterInput, record));
                            changed = true;
                        }
                    });
        if (changed)
            __private.model = model;

        /*! 根据 activeSorter 列排序 */
        columns.forEach(
                    object => {
                        if (object.activeSorter === true) {
                            if (object.sortMode === 'ascend') {
                                /*! sorter 作为上升处理 */
                                __private.model.sort(object.sorter);
                                __private.modelChanged();
                            } else if (object.sortMode === 'descend') {
                                /*! 返回 ascend 相反结果即可 */
                                __private.model.sort((a, b) => object.sorter(b, a));
                                __private.modelChanged();
                            } else {
                                /*! 还原 */
                                __private.model = model;
                            }
                        }
                    });
    }

    function clearFilter() {
        columns.forEach(
                    object => {
                        if (object.hasOwnProperty('onFilter') || object.hasOwnProperty('filterInput')) {
                            object.filterInput = '';
                        }
                    });
        __private.model = [...initModel];
    }

    function clear() {
        __private.model = initModel = [];
        __cellModel.clear();
        columns.forEach(
                    object => {
                        if (object.sortDirections && object.sortDirections.length !== 0) {
                            object.activeSorter = false;
                            object.sortIndex = -1;
                            object.sortMode = 'false';
                        }
                        if (object.hasOwnProperty('onFilter') || object.hasOwnProperty('filterInput')) {
                            object.filterInput = '';
                        }
                    });
    }

    function appendRow(object: var) {
        __private.model.push(object);
        __cellModel.appendRow(__private.toCellObject(object));
    }

    function getRow(rowIndex) {
        if (rowIndex >= 0 && rowIndex < __private.model.length) {
            return __private.model[rowIndex];
        }
        return undefined;
    }

    function insertRow(rowIndex, object: var) {
        __private.model.splice(rowIndex, 0, object);
        __cellModel.insertRow(rowIndex, __private.toCellObject(object));
    }

    function moveRow(fromRowIndex, toRowIndex, count = 1) {
        if (fromRowIndex >= 0 && fromRowIndex < __private.model.length &&
                toRowIndex >= 0 && toRowIndex < __private.model.length) {
            const objects = __private.model.splice(from, count);
            __private.model.splice(to, 0, ...objects);
            __cellModel.moveRow(fromRowIndex, toRowIndex, count);
        }
    }

    function removeRow(rowIndex, count = 1) {
        if (rowIndex >= 0 && rowIndex < __private.model.length) {
            __private.model.splice(rowIndex, count);
            __cellModel.removeRow(rowIndex, count);
        }
    }

    function setRow(rowIndex, object: var) {
        if (rowIndex >= 0 && rowIndex < __private.model.length) {
            __private.model[rowIndex] = object;
            __cellModel.setRow(rowIndex, __private.toCellObject(object));
        }
    }

    component HoverIcon: DelIconText {
        signal clicked()
        property alias hovered: __hoverHandler.hovered

        HoverHandler {
            id: __hoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            onTapped: parent.clicked();
        }
    }

    component ResizeArea: MouseArea {
        property bool isHorizontal: true
        property var target: __columnHeaderItem
        property point startPos: Qt.point(0, 0)
        property real minimumWidth: 0
        property real maximumWidth: Number.NaN
        property real minimumHeight: 0
        property real maximumHeight: Number.NaN
        property var resizeCallback: (result) => { }

        preventStealing: true
        hoverEnabled: true
        onEntered: cursorShape = isHorizontal ? Qt.SplitHCursor : Qt.SplitVCursor;
        onPressed:
            (mouse) => {
                if (target) {
                    startPos = Qt.point(mouseX, mouseY);
                }
            }
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    if (isHorizontal) {
                        let resultWidth = 0;
                        let offsetX = mouse.x - startPos.x;
                        if (maximumWidth != Number.NaN && (target.width + offsetX) > maximumWidth) {
                            resultWidth = maximumWidth;
                        } else if ((target.width + offsetX) < minimumWidth) {
                            resultWidth = minimumWidth;
                        } else {
                            resultWidth = target.width + offsetX;
                        }
                        resizeCallback(resultWidth);
                    } else {
                        let resultHeight = 0;
                        let offsetY = mouse.y - startPos.y;
                        if (maximumHeight != Number.NaN && (target.height + offsetY) > maximumHeight) {
                            resultHeight = maximumHeight;
                        } else if ((target.height + offsetY) < minimumHeight) {
                            resultHeight = minimumHeight;
                        } else {
                            resultHeight = target.height + offsetY;
                        }
                        resizeCallback(resultHeight);
                    }
                    mouse.accepted = true;
                }
            }
    }

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }

    QtObject {
        id: __private
        property var model: []
        property int parentCheckState: Qt.Unchecked
        property var checkedKeysMap: new Map

        function updateParentCheckBox() {
            let checkCount = 0;
            model.forEach(
                        object => {
                            if (checkedKeysMap.has(object.key)) {
                                checkCount++;
                            }
                        });
            parentCheckState = checkCount == 0 ? Qt.Unchecked : checkCount == model.length ? Qt.Checked : Qt.PartiallyChecked;
            parentCheckStateChanged();
        }

        function updateCheckedKeys() {
            control.checkedKeys = [...checkedKeysMap.keys()];
        }

        function toCellObject(object) {
            let dataObject = new Object;
            for (let i = 0; i < control.columns.length; i++) {
                const dataIndex = control.columns[i].dataIndex ?? '';
                if (object.hasOwnProperty(dataIndex)) {
                    dataObject[`__data${i}`] = object[dataIndex];
                } else {
                    dataObject[`__data${i}`] = null;
                }
            }
            return dataObject;
        }

        onModelChanged: {
            control.scrollToRow(0);
            __cellModel.clear();

            let cellRows = [];
            model.forEach(
                        (object, index) => {
                            let data = { };
                            for (let i = 0; i < columns.length; i++) {
                                const dataIndex = columns[i].dataIndex ?? '';
                                if (object.hasOwnProperty(dataIndex)) {
                                    data[`__data${i}`] = object[dataIndex];
                                } else {
                                    data[`__data${i}`] = null;
                                }
                            }
                            cellRows.push(data);
                        });
            __cellModel.rows = cellRows;

            __rowHeaderModel.rows = model;

            updateParentCheckBox();
        }
        onParentCheckStateChanged: updateCheckedKeys();
        onCheckedKeysMapChanged: updateCheckedKeys();
    }

    DelRectangle {
        id: __columnHeaderViewBg
        height: control.defaultColumnHeaderHeight
        anchors.left: control.rowHeaderVisible ? __rowHeaderViewBg.right : parent.left
        anchors.right: parent.right
        topLeftRadius: control.rowHeaderVisible ? 0 : 6
        topRightRadius: 6
        color: control.colorColumnHeaderBg
        visible: control.columnHeaderVisible

        TableView {
            id: __columnHeaderView
            anchors.fill: parent
            syncDirection: Qt.Horizontal
            syncView: __cellView
            reuseItems: false /*! 重用有未知BUG */
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            model: TableModel {
                id: __columnHeaderModel
            }
            delegate: Item {
                id: __columnHeaderItem
                implicitWidth: display.width ?? 100
                implicitHeight: __columnHeaderView.height
                clip: true

                required property var model
                required property var display
                property int row: model.row
                property int column: model.column
                property string selectionType: display.selectionType ?? ''
                property bool editable: display.editable ?? false
                property var sorter: display.sorter
                property real minimumWidth: display.minimumWidth ?? 40
                property real maximumWidth: display.maximumWidth ?? Number.NaN

                TableView.onReused: {
                    if (selectionType == 'checkbox')
                        __private.updateParentCheckBox();
                }

                TableView.editDelegate: DelInput {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: sorter !== undefined ? 50 : 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: display.title
                    visible: activeFocus && __columnHeaderItem.editable
                    TableView.onCommit: {
                        control.columns[__columnHeaderItem.column].title = text;
                        control.columnsChanged();
                    }
                }

                Loader {
                    anchors.fill: parent
                    sourceComponent: control.columnHeaderDelegate
                    property alias model: __columnHeaderItem.model
                    property alias headerData: __columnHeaderItem.display
                    property alias column: __columnHeaderItem.column
                }

                Rectangle {
                    z: 2
                    width: 1
                    color: control.colorGridLine
                    height: parent.height * 0.5
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }

                ResizeArea {
                    width: 8
                    height: parent.height
                    minimumWidth: __columnHeaderItem.minimumWidth
                    maximumWidth: __columnHeaderItem.maximumWidth
                    anchors.right: parent.right
                    anchors.rightMargin: -width * 0.5
                    target: __columnHeaderItem
                    isHorizontal: true
                    resizeCallback: result => __columnHeaderView.setColumnWidth(__columnHeaderItem.column, result);
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: control.colorGridLine
        }
    }

    Rectangle {
        id: __rowHeaderViewBg
        width: control.defaultRowHeaderWidth
        anchors.top: control.columnHeaderVisible ? __columnHeaderViewBg.bottom : __cellMouseArea.top
        anchors.bottom: __cellMouseArea.bottom
        color: control.colorRowHeaderBg
        visible: control.rowHeaderVisible

        TableView {
            id: __rowHeaderView
            anchors.fill: parent
            syncDirection: Qt.Vertical
            syncView: __cellView
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            model: TableModel {
                id: __rowHeaderModel
                TableModelColumn { }
            }
            delegate: Item {
                id: __rowHeaderItem
                implicitWidth: __rowHeaderView.width
                implicitHeight: 40
                clip: true

                required property var model
                property int row: model.row

                Loader {
                    anchors.fill: parent
                    sourceComponent: control.rowHeaderDelegate
                    property alias model: __rowHeaderItem.model
                    property alias row: __rowHeaderItem.row
                }

                Rectangle {
                    z: 2
                    width: parent.width * 0.5
                    color: control.colorGridLine
                    height: 1
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ResizeArea {
                    width: parent.width
                    height: 8
                    minimumHeight: control.minimumRowHeight
                    maximumHeight: control.maximumRowHeight
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -height * 0.5
                    target: __rowHeaderItem
                    isHorizontal: false
                    resizeCallback: result => __rowHeaderView.setRowHeight(__rowHeaderItem.row, result);
                }
            }
        }

        Rectangle {
            width: 1
            height: parent.height
            anchors.right: parent.right
            color: control.colorGridLine
        }
    }

    MouseArea {
        id: __cellMouseArea
        anchors.top: control.columnHeaderVisible ? __columnHeaderViewBg.bottom : parent.top
        anchors.bottom: parent.bottom
        anchors.left: __columnHeaderViewBg.left
        anchors.right: __columnHeaderViewBg.right
        hoverEnabled: true
        onExited: __cellView.currentHoverRow = -1;
        onWheel: wheel => wheel.accepted = true;

        TableView {
            id: __cellView
            property int currentHoverRow: -1
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            selectionModel: ItemSelectionModel { }
            T.ScrollBar.horizontal: __hScrollBar
            T.ScrollBar.vertical: __vScrollBar
            clip: true
            reuseItems: false /*! 重用有未知BUG */
            model: TableModel { id: __cellModel }
            delegate: Rectangle {
                id: __rootItem
                implicitWidth: control.columns[column].width
                implicitHeight: control.defaultRowHeaderWidth
                clip: true
                color: {
                    if (__private.checkedKeysMap.has(key)) {
                        if (row == __cellView.currentHoverRow)
                            return DelTheme.isDark ? DelTheme.DelTableView.colorCellBgDarkHoverChecked :
                                                     DelTheme.DelTableView.colorCellBgHoverChecked;
                        else
                            return DelTheme.isDark ? DelTheme.DelTableView.colorCellBgDarkChecked :
                                                     DelTheme.DelTableView.colorCellBgChecked;
                    } else {
                        return row == __cellView.currentHoverRow ? DelTheme.DelTableView.colorCellBgHover :
                                                                   control.alternatingRow && __rootItem.row % 2 !== 0 ?
                                                                       DelTheme.DelTableView.colorCellBgHover : DelTheme.DelTableView.colorCellBg;
                    }
                }

                TableView.onReused: {
                    checked = __private.checkedKeysMap.has(key);
                    if (__childCheckBoxLoader.item) {
                        __childCheckBoxLoader.item.checked = checked;
                    }
                }

                required property var model
                required property var index
                required property var display
                required property bool current
                required property bool selected

                property int row: model.row
                property int column: model.column
                property string key: __private.model[row]?.key ?? ''
                property string selectionType: control.columns[column].selectionType ?? ''
                property string dataIndex: control.columns[column].dataIndex ?? ''
                property string filterInput: control.columns[column].filterInput ?? ''
                property alias cellData: __rootItem.display
                property bool checked: false

                Loader {
                    active: control.rowGridVisible
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    sourceComponent: Rectangle { color: control.colorGridLine }
                }

                Loader {
                    active: control.columnGridVisible
                    width: 1
                    height: parent.height
                    anchors.right: parent.right
                    sourceComponent: Rectangle { color: control.colorGridLine }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: __cellView.currentHoverRow = __rootItem.row;

                    Loader {
                        id: __childCheckBoxLoader
                        active: selectionType == 'checkbox'
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        sourceComponent: DelCheckBox {
                            id: __childBox

                            Component.onCompleted: {
                                __childBox.checked = __rootItem.checked = __private.checkedKeysMap.has(key);
                            }

                            onToggled: {
                                if (checkState == Qt.Checked) {
                                    __private.checkedKeysMap.set(__rootItem.key, true);
                                    __rootItem.checked = true;
                                } else {
                                    __private.checkedKeysMap.delete(__rootItem.key);
                                    __rootItem.checked = false;
                                }
                                __private.updateParentCheckBox();
                                __cellView.currentHoverRowChanged();
                            }

                            Connections {
                                target: __private
                                function onCheckedKeysMapChanged() {
                                    __childBox.checked = __rootItem.checked = __private.checkedKeysMap.has(__rootItem.key);
                                }
                            }
                        }
                        property alias key: __rootItem.key
                    }

                    Loader {
                        anchors.left: __childCheckBoxLoader.active ? __childCheckBoxLoader.right : parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        sourceComponent: {
                            if (control.columns[__rootItem.column]?.delegate) {
                                return control.columns[__rootItem.column].delegate;
                            } else {
                                return null;
                            }
                        }
                        property alias row: __rootItem.row
                        property alias column: __rootItem.column
                        property alias cellData: __rootItem.cellData
                        property alias cellIndex: __rootItem.index
                        property alias dataIndex: __rootItem.dataIndex
                        property alias filterInput: __rootItem.filterInput
                        property alias current: __rootItem.current
                    }
                }
            }

            Behavior on contentY { NumberAnimation {}}
        }
    }

    Loader {
        id: __resizeRectLoader
        z: 10
        width: __rowHeaderViewBg.width
        height: __columnHeaderViewBg.height
        active: control.rowHeaderVisible && control.columnHeaderVisible
        sourceComponent: DelRectangle {
            color: control.colorResizeBlockBg
            topLeftRadius: 6

            ResizeArea {
                width: parent.width
                height: 8
                minimumHeight: control.defaultColumnHeaderHeight
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -height * 0.5
                target: __columnHeaderViewBg
                isHorizontal: false
                resizeCallback: result => __columnHeaderViewBg.height = result;
            }

            ResizeArea {
                width: 8
                height: parent.height
                minimumWidth: control.defaultRowHeaderWidth
                anchors.right: parent.right
                anchors.rightMargin: -width * 0.5
                target: __rowHeaderViewBg
                isHorizontal: true
                resizeCallback: result => __rowHeaderViewBg.width = result;
            }
        }
    }

    DelScrollBar {
        id: __hScrollBar
        z: 11
        anchors.left: control.rowHeaderVisible ? __rowHeaderViewBg.right : __cellMouseArea.left
        anchors.right: __cellMouseArea.right
        anchors.bottom: __cellMouseArea.bottom
    }

    DelScrollBar {
        id: __vScrollBar
        z: 12
        anchors.right: __cellMouseArea.right
        anchors.top: control.columnHeaderVisible ? __columnHeaderViewBg.bottom : __cellMouseArea.top
        anchors.bottom: __cellMouseArea.bottom
    }
}
