import QtQuick
import QtQuick.Templates as T
import Qt.labs.qmlmodels
import HuskarUI.Basic

HusRectangle {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool propagateWheelEvent: false
    property bool alternatingRow: false
    property int defaultColumnHeaderHeight: 40
    property int defaultRowHeaderWidth: 40
    property var rowHeightProvider: (row, key) => minimumRowHeight
    property bool showColumnGrid: false
    property bool showRowGrid: false
    property real minimumRowHeight: 40
    property real maximumRowHeight: Number.MAX_VALUE
    property var initModel: []
    readonly property int rowCount: __cellModel.rowCount
    property var columns: []
    property var checkedKeys: []

    property bool showColumnHeader: true
    property font columnHeaderTitleFont: Qt.font({
                                                     family: HusTheme.HusTableView.fontFamily,
                                                     pixelSize: parseInt(HusTheme.HusTableView.fontSize)
                                                 })
    property color colorColumnHeaderTitle: HusTheme.HusTableView.colorColumnTitle
    property color colorColumnHeaderBg: HusTheme.HusTableView.colorColumnHeaderBg

    property bool showRowHeader: true
    property font rowHeaderTitleFont: Qt.font({
                                                  family: HusTheme.HusTableView.fontFamily,
                                                  pixelSize: parseInt(HusTheme.HusTableView.fontSize)
                                              })
    property color colorRowHeaderTitle: HusTheme.HusTableView.colorRowTitle
    property color colorRowHeaderBg: HusTheme.HusTableView.colorRowHeaderBg

    property color colorGridLine: HusTheme.HusTableView.colorGridLine
    property color colorResizeBlockBg: HusTheme.HusTableView.colorResizeBlockBg

    property Component columnHeaderDelegate: Item {
        id: __columnHeaderDelegate

        property var model: parent.model
        property var headerData: parent.headerData
        property bool editable: headerData?.editable ?? false
        property string align: headerData?.align ?? 'center'
        property string selectionType: headerData?.selectionType ?? ''
        property var sorter: headerData?.sorter
        property var sortDirections: headerData?.sortDirections ?? []
        property var onFilter: headerData?.onFilter

        HusText {
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
            text: headerData?.title ?? ''
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
            sourceComponent: HusCheckBox {
                id: __parentBox
                animationEnabled: control.animationEnabled

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
                    __private.updateParentCheckBox();
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
            property int column: __columnHeaderDelegate?.model?.column ?? -1
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
            property int column: __columnHeaderDelegate?.model?.column ?? -1
            property alias onFilter: __columnHeaderDelegate.onFilter
        }
    }
    property Component rowHeaderDelegate: Item {
        HusText {
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

            HusIconText {
                visible: sortDirections.indexOf('ascend') !== -1
                colorIcon: sortMode === 'ascend' ? HusTheme.HusTableView.colorIconHover :
                                                   HusTheme.HusTableView.colorIcon
                iconSource: HusIcon.CaretUpOutlined
                iconSize: parseInt(HusTheme.HusTableView.fontSize) - 2
            }

            HusIconText {
                visible: sortDirections.indexOf('descend') !== -1
                colorIcon: sortMode === 'descend' ? HusTheme.HusTableView.colorIconHover :
                                                    HusTheme.HusTableView.colorIcon
                iconSource: HusIcon.CaretDownOutlined
                iconSize: parseInt(HusTheme.HusTableView.fontSize) - 2
            }
        }
    }
    property Component columnHeaderFilterIconDelegate: Item {
        width: __headerFilterIcon.width
        height: __headerFilterIcon.height + 12

        HoverIcon {
            id: __headerFilterIcon
            anchors.centerIn: parent
            iconSource: HusIcon.SearchOutlined
            colorIcon: hovered ? HusTheme.HusTableView.colorIconHover : HusTheme.HusTableView.colorIcon
            onClicked: {
                __filterPopup.open();
            }
        }

        HusPopup {
            id: __filterPopup
            x: -width * 0.5
            y: parent.height
            padding: 5
            animationEnabled: control.animationEnabled
            contentItem: Column {
                spacing: 5

                HusInput {
                    id: __searchInput
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: qsTr('Search ') + control.columns[column]?.dataIndex ?? ''
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

                    HusIconButton {
                        id: __searchButton
                        animationEnabled: control.animationEnabled
                        text: qsTr('Search')
                        iconSource: HusIcon.SearchOutlined
                        type: HusButton.Type_Primary
                        onClicked: {
                            if (__searchInput.text.length === 0)
                                __filterPopup.close();
                            control.columns[column].filterInput = __searchInput.text;
                            control.filter();
                        }
                    }

                    HusButton {
                        animationEnabled: control.animationEnabled
                        text: qsTr('Reset')
                        onClicked: {
                            if (__searchInput.text.length === 0)
                                __filterPopup.close();
                            __searchInput.clear();
                            control.columns[column].filterInput = '';
                            control.filter();
                        }
                    }

                    HusButton {
                        animationEnabled: control.animationEnabled
                        text: qsTr('Close')
                        type: HusButton.Type_Link
                        onClicked: {
                            __filterPopup.close();
                        }
                    }
                }
            }
            Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
        }
    }

    objectName: '__HusTableView__'
    clip: true
    color: HusTheme.HusTableView.colorBg
    topLeftRadius: HusTheme.HusTableView.radiusBg
    topRightRadius: HusTheme.HusTableView.radiusBg
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
        if (showColumnHeader) {
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
        keys.forEach(key => __private.checkedKeysMap.set(key, true));
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

    function getTableModel() {
        return [...__private.model];
    }

    function appendRow(object: var) {
        __cellModel.appendRow(__private.toCellObject(object));
        __private.model.push(object);
        __private.updateRowHeader();
    }

    function getRow(rowIndex) {
        if (rowIndex >= 0 && rowIndex < __private.model.length) {
            return __private.model[rowIndex];
        }
        return undefined;
    }

    function insertRow(rowIndex, object: var) {
        __cellModel.insertRow(rowIndex, __private.toCellObject(object));
        __private.model.splice(rowIndex, 0, object);
        __private.updateRowHeader();
    }

    function moveRow(fromRowIndex, toRowIndex, count = 1) {
        if (fromRowIndex >= 0 && fromRowIndex < __private.model.length &&
                toRowIndex >= 0 && toRowIndex < __private.model.length) {
            const objects = __private.model.splice(from, count);
            __cellModel.moveRow(fromRowIndex, toRowIndex, count);
            __private.model.splice(to, 0, ...objects);
            __private.updateRowHeader();
        }
    }

    function removeRow(rowIndex, count = 1) {
        if (rowIndex >= 0 && rowIndex < __private.model.length) {
            __cellModel.removeRow(rowIndex, count);
            __private.model.splice(rowIndex, count);
            __private.updateRowHeader();
        }
    }

    function setRow(rowIndex, object: var) {
        if (rowIndex >= 0 && rowIndex < __private.model.length) {
            __cellModel.setRow(rowIndex, __private.toCellObject(object));
            __private.model[rowIndex] = object;
            __private.updateRowHeader();
        }
    }

    function getCellData(rowIndex, columnIndex) {
        if (rowIndex >= 0 && rowIndex < __private.model.length
                && columnIndex >= 0 && columnIndex < columns.length) {
            return __cellModel.data(__cellModel.index(rowIndex, columnIndex), 'display');
        }
        return undefined;
    }

    function setCellData(rowIndex, columnIndex, data: var) {
        if (rowIndex >= 0 && rowIndex < __private.model.length
                && columnIndex >= 0 && columnIndex < columns.length) {
            __cellModel.setData(__cellModel.index(rowIndex, columnIndex), 'display', data);
        }
    }

    component HoverIcon: HusIconText {
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

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

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

        function updateRowHeader() {
            __rowHeaderModel.rows = model;
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
                            let data = {};
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

    HusRectangleInternal {
        id: __columnHeaderViewBg
        height: control.defaultColumnHeaderHeight
        anchors.left: control.showRowHeader ? __rowHeaderViewBg.right : parent.left
        anchors.right: parent.right
        topLeftRadius: control.showRowHeader ? 0 : HusTheme.HusTableView.radiusBg
        topRightRadius: HusTheme.HusTableView.radiusBg
        color: control.colorColumnHeaderBg
        visible: control.showColumnHeader

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
            columnWidthProvider: (column) => control.columns[column].width
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
                property real maximumWidth: display.maximumWidth ?? Number.MAX_VALUE

                TableView.onReused: {
                    if (selectionType == 'checkbox')
                        __private.updateParentCheckBox();
                }

                TableView.editDelegate: HusInput {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: sorter !== undefined ? 50 : 20
                    anchors.verticalCenter: parent.verticalCenter
                    animationEnabled: control.animationEnabled
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
        anchors.top: control.showColumnHeader ? __columnHeaderViewBg.bottom : __cellMouseArea.top
        anchors.bottom: __cellMouseArea.bottom
        color: control.colorRowHeaderBg
        visible: control.showRowHeader

        TableView {
            id: __rowHeaderView
            anchors.fill: parent
            syncDirection: Qt.Vertical
            syncView: __cellView
            rowSpacing: __cellView.rowSpacing
            columnSpacing: __cellView.columnSpacing
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            model: TableModel {
                id: __rowHeaderModel
                TableModelColumn { }
            }
            delegate: Item {
                id: __rowHeaderItem
                implicitWidth: __rowHeaderView.width
                implicitHeight: control.minimumRowHeight
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
        anchors.top: control.showColumnHeader ? __columnHeaderViewBg.bottom : parent.top
        anchors.bottom: parent.bottom
        anchors.left: __columnHeaderViewBg.left
        anchors.right: __columnHeaderViewBg.right
        hoverEnabled: true
        onExited: __cellView.currentHoverRow = -1;
        onWheel: wheel => wheel.accepted = !control.propagateWheelEvent;

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
                implicitHeight: Math.max(control.minimumRowHeight, Math.min(control.rowHeightProvider(row, key), control.maximumRowHeight))
                visible: implicitHeight >= 0
                clip: true
                color: {
                    if (__private.checkedKeysMap.has(key)) {
                        if (row == __cellView.currentHoverRow)
                            return HusTheme.isDark ? HusTheme.HusTableView.colorCellBgDarkHoverChecked :
                                                     HusTheme.HusTableView.colorCellBgHoverChecked;
                        else
                            return HusTheme.isDark ? HusTheme.HusTableView.colorCellBgDarkChecked :
                                                     HusTheme.HusTableView.colorCellBgChecked;
                    } else {
                        return row == __cellView.currentHoverRow ? HusTheme.HusTableView.colorCellBgHover :
                                                                   control.alternatingRow && __rootItem.row % 2 !== 0 ?
                                                                       HusTheme.HusTableView.colorCellBgHover : HusTheme.HusTableView.colorCellBg;
                    }
                }

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

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
                        sourceComponent: HusCheckBox {
                            id: __childBox
                            animationEnabled: control.animationEnabled

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

                Loader {
                    active: control.showRowGrid
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    sourceComponent: Rectangle { color: control.colorGridLine }
                }

                Loader {
                    active: control.showColumnGrid
                    width: 1
                    height: parent.height
                    anchors.right: parent.right
                    sourceComponent: Rectangle { color: control.colorGridLine }
                }
            }
        }
    }

    Loader {
        id: __resizeRectLoader
        z: 10
        width: __rowHeaderViewBg.width
        height: __columnHeaderViewBg.height
        active: control.showRowHeader && control.showColumnHeader
        sourceComponent: HusRectangleInternal {
            color: control.colorResizeBlockBg
            topLeftRadius: HusTheme.HusTableView.radiusBg

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

    HusScrollBar {
        id: __hScrollBar
        z: 11
        anchors.left: control.showRowHeader ? __rowHeaderViewBg.right : __cellMouseArea.left
        anchors.right: __cellMouseArea.right
        anchors.bottom: __cellMouseArea.bottom
        animationEnabled: control.animationEnabled
    }

    HusScrollBar {
        id: __vScrollBar
        z: 12
        anchors.right: __cellMouseArea.right
        anchors.top: control.showColumnHeader ? __columnHeaderViewBg.bottom : __cellMouseArea.top
        anchors.bottom: __cellMouseArea.bottom
        animationEnabled: control.animationEnabled
    }
}
