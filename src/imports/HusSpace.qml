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

import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Loader {
    id: control

    enum Type {
        Type_Compact = 0
    }

    property int type: HusSpace.Type_Compact
    property string layout: ''
    property bool autoCombineRadius: true
    property HusRadius radiusBg: HusRadius { all: HusTheme.Primary.radiusPrimary }

    /*! Row Column Grid */
    property Transition add: null
    property Transition populate: null
    property Transition move: null
    property real padding: 0
    property real leftPadding: 0
    property real rightPadding: 0
    property real topPadding: 0
    property real bottomPadding: 0

    /*! Row Column RowLayout ColunmLayout */
    property real spacing: -1

    /*! Row RowLayout ColunmLayout Grid GridLayout */
    property int layoutDirection: Qt.LeftToRight

    /*! RowLayout ColunmLayout */
    property bool uniformCellSizes: false

    /* Grid */
    property int horizontalItemAlignment: Qt.AlignHCenter
    property int verticalItemAlignment: Qt.AlignVCenter

    /* Grid GridLayout */
    property real rows: 0
    property real columns: 0
    property real rowSpacing: spacing
    property real columnSpacing: spacing
    property int flow: GridLayout.LeftToRight

    /*! GridLayout */
    property bool uniformCellWidths: false
    property bool uniformCellHeights: false

    default property list<QtObject> layoutData

    function __setItemRadiusBinding(instance: var, edge: string, hasDirection: bool) {
        if (instance.hasOwnProperty('radiusBg')) {
            instance.radiusBg.all = 0;
            switch (edge) {
            case 'left': {
                instance.radiusBg.topLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topLeft : 0) :
                            Qt.binding(() => control.radiusBg.topLeft);
                instance.radiusBg.bottomLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomLeft : 0) :
                            Qt.binding(() => control.radiusBg.bottomLeft);
                instance.radiusBg.topRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topRight : 0) :
                            Qt.binding(() => control.radiusBg.topRight);
                instance.radiusBg.bottomRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomRight : 0) :
                            Qt.binding(() => control.radiusBg.bottomRight);
            } break;
            case 'right': {
                instance.radiusBg.topRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topRight : 0) :
                            Qt.binding(() => control.radiusBg.topRight);
                instance.radiusBg.bottomRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomRight : 0) :
                            Qt.binding(() => control.radiusBg.bottomRight);
                instance.radiusBg.topLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topLeft : 0) :
                            Qt.binding(() => control.radiusBg.topLeft);
                instance.radiusBg.bottomLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomLeft : 0) :
                            Qt.binding(() => control.radiusBg.bottomLeft);
            } break;
            case 'top': {
                instance.radiusBg.topLeft = Qt.binding(() => control.radiusBg.topLeft);
                instance.radiusBg.topRight = Qt.binding(() => control.radiusBg.topRight);
            } break;
            case 'bottom': {
                instance.radiusBg.bottomLeft = Qt.binding(() => control.radiusBg.bottomLeft);
                instance.radiusBg.bottomRight = Qt.binding(() => control.radiusBg.bottomRight);
            } break;
            case 'topLeft': {
                instance.radiusBg.topLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topLeft : 0) :
                            Qt.binding(() => control.radiusBg.topLeft);
                instance.radiusBg.topRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topRight : 0) :
                            Qt.binding(() => control.radiusBg.topRight);
            } break;
            case 'topRight': {
                instance.radiusBg.topRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topRight : 0) :
                            Qt.binding(() => control.radiusBg.topRight);
                instance.radiusBg.topLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topLeft : 0) :
                            Qt.binding(() => control.radiusBg.topLeft);
            } break;
            case 'bottomLeft': {
                instance.radiusBg.bottomLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomLeft : 0) :
                            Qt.binding(() => control.radiusBg.bottomLeft);
                instance.radiusBg.bottomRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomRight : 0) :
                            Qt.binding(() => control.radiusBg.bottomRight);
            } break;
            case 'bottomRight': {
                instance.radiusBg.bottomRight = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomRight : 0) :
                            Qt.binding(() => control.radiusBg.bottomRight);
                instance.radiusBg.bottomLeft = hasDirection ?
                            Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomLeft : 0) :
                            Qt.binding(() => control.radiusBg.bottomLeft);
            } break;
            default: break;
            }
        }
    }

    function __createBindings(itemChildren: var) {
        if (!autoCombineRadius) return;

        const length = itemChildren.length;
        const createRowBinding = () => {
            itemChildren.forEach(
                (item, i) => {
                    if (i === 0) {
                        __setItemRadiusBinding(item, 'left', true);
                    } else if (i === length - 1) {
                        __setItemRadiusBinding(item, 'right', true);
                    } else {
                        __setItemRadiusBinding(item, '');
                    }
                });
        };
        const createColumnBinding = () => {
            itemChildren.forEach(
                (item, i) => {
                    if (i === 0) {
                        __setItemRadiusBinding(item, 'top');
                    } else if (i === length - 1) {
                        __setItemRadiusBinding(item, 'bottom');
                    } else {
                        __setItemRadiusBinding(item, '');
                    }
                });
        };
        const createGridBinding = () => {
            if (columns > 1 && rows > 1) {
                itemChildren.forEach(
                    (item, i) => {
                        if (i === 0) {
                            __setItemRadiusBinding(item, 'topLeft');
                        } else if (i === (columns - 1)) {
                            __setItemRadiusBinding(item, 'topRight');
                        } else if (i === columns * (rows - 1)) {
                            __setItemRadiusBinding(item, 'bottomLeft');
                        } else if (i === length - 1) {
                            __setItemRadiusBinding(item, 'bottomRight');
                        } else {
                            __setItemRadiusBinding(item, '');
                        }
                    });
            } else {
                if (rows === 1) {
                    createRowBinding();
                } else if (columns === 1) {
                    createColumnBinding();
                }
            }
        }
        const createGridLayoutBinding = () => {
            if (columns > 1 && rows > 1) {
                /* 统一清空radius */
                itemChildren.forEach(item => __setItemRadiusBinding(item, ''));
                /*! 第一行的第一个和最后一个 */
                let columnIndex = 0;
                for (let i = 0; i < length; i++) {
                    const item1 = itemChildren[i];
                    if (i === 0) {
                        __setItemRadiusBinding(item1, 'topLeft', true);
                    }
                     if (columnIndex < columns) {
                        columnIndex += item1.Layout.columnSpan;
                        if (columnIndex >= columns) {
                            __setItemRadiusBinding(item1, 'topRight', true);
                            break;
                        }
                    }
                }
                /*! 最后一行的最后一个和第一个 */
                columnIndex = 0;
                for (let j = length - 1; j > 0; j--) {
                    const item2 = itemChildren[j];
                    if (j === length - 1) {
                        __setItemRadiusBinding(item2, 'bottomRight', true);
                    }
                    if (columnIndex < columns) {
                        columnIndex += item2.Layout.columnSpan;
                        if (columnIndex >= columns) {
                            __setItemRadiusBinding(item2, 'bottomLeft', true);
                            break;
                        }
                    }
                }
            } else {
                if (rows === 1) {
                    createRowBinding();
                } else if (columns === 1) {
                    createColumnBinding();
                }
            }
        }
        if (length > 0) {
            switch (layout) {
            case 'Row':
            case 'RowLayout':
                createRowBinding();
                break;
            case 'Column':
            case 'ColumnLayout':
                createColumnBinding();
                break;
            case 'Grid':
                createGridBinding();
                break;
            case 'GridLayout':
                createGridLayoutBinding();
                break;
            }
        }
    }

    objectName: '__HusSpace__'
    sourceComponent: {
        switch (layout) {
        case 'Row': return __row;
        case 'RowLayout': return __rowLayout;
        case 'Column': return __column;
        case 'ColumnLayout': return __columnLayout;
        case 'Grid': return __grid;
        case 'GridLayout': return __gridLayout;
        }
    }

    Component {
        id: __row

        Row {
            add: control.add
            populate: control.add
            move: control.add
            padding: control.padding
            leftPadding: control.leftPadding
            rightPadding: control.rightPadding
            topPadding: control.topPadding
            bottomPadding: control.bottomPadding
            spacing: control.spacing
            layoutDirection: control.layoutDirection
            data: control.layoutData
            Component.onCompleted: control.__createBindings(children);
        }
    }

    Component {
        id: __rowLayout

        RowLayout {
            spacing: control.spacing
            layoutDirection: control.layoutDirection
            uniformCellSizes: control.uniformCellSizes
            data: control.layoutData
            Component.onCompleted: control.__createBindings(children);
        }
    }

    Component {
        id: __column

        Column {
            add: control.add
            populate: control.add
            move: control.add
            padding: control.padding
            leftPadding: control.leftPadding
            rightPadding: control.rightPadding
            topPadding: control.topPadding
            bottomPadding: control.bottomPadding
            spacing: control.spacing
            data: control.layoutData
            Component.onCompleted: control.__createBindings(children);
        }
    }

    Component {
        id: __columnLayout

        ColumnLayout {
            spacing: control.spacing
            layoutDirection: control.layoutDirection
            uniformCellSizes: control.uniformCellSizes
            data: control.layoutData
            Component.onCompleted: control.__createBindings(children);
        }
    }

    Component {
        id: __grid

        Grid {
            add: control.add
            populate: control.add
            move: control.add
            padding: control.padding
            leftPadding: control.leftPadding
            rightPadding: control.rightPadding
            topPadding: control.topPadding
            bottomPadding: control.bottomPadding
            rows: control.rows
            columns: control.columns
            spacing: control.spacing
            rowSpacing: control.rowSpacing
            columnSpacing: control.columnSpacing
            layoutDirection: control.layoutDirection
            horizontalItemAlignment: control.horizontalItemAlignment
            verticalItemAlignment: control.verticalItemAlignment
            data: control.layoutData
            Component.onCompleted: control.__createBindings(children);
        }
    }

    Component {
        id: __gridLayout

        GridLayout {
            flow: control.flow
            rows: control.rows
            columns: control.columns
            rowSpacing: control.rowSpacing
            columnSpacing: control.columnSpacing
            layoutDirection: control.layoutDirection
            uniformCellWidths: control.uniformCellWidths
            uniformCellHeights: control.uniformCellHeights
            data: control.layoutData
            Component.onCompleted: control.__createBindings(children);
        }
    }
}
