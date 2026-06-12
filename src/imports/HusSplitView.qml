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
import QtQuick.Templates as T
import HuskarUI.Basic

T.SplitView {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool resizable: true
    property var showCollapsibleIcon: false ?? ''
    property real handleSize: 2
    property real handleTriggerSize: 6
    property var themeSource: HusTheme.HusSplitView

    property Component collapseBarStart: HusIconButton {
        implicitWidth: control.orientation === Qt.Horizontal ? 12 : 30
        implicitHeight: control.orientation === Qt.Horizontal ? 30 : 12
        animationEnabled: false
        visible: control.showCollapsibleIcon === 'auto' ? collapseBarHovered : true
        iconSource: control.orientation === Qt.Horizontal ? HusIcon.LeftOutlined : HusIcon.UpOutlined
        leftPadding: 0
        rightPadding: 0
        colorBorder: 'transparent'
        colorBg: pressed ? control.themeSource.colorHandleActive :
                           hovered ? control.themeSource.colorHandleHover :
                                     control.themeSource.colorHandle
        radiusBg.all: 2
        onClicked: {
            const selfState = __private.getState(index);
            if (selfState.state === 'normal') {
                setItemCollapseState(index, 'collapse');
                setItemCollapseState(index + 1, 'left_expand');
            } else if (selfState.state === 'left_expand' || selfState.state === 'right_expand') {
                setItemCollapseState(index, 'normal');
                setItemCollapseState(index + 1, 'normal');
            }
        }
    }
    property Component collapseBarEnd: HusIconButton {
        implicitWidth: control.orientation === Qt.Horizontal ? 12 : 30
        implicitHeight: control.orientation === Qt.Horizontal ? 30 : 12
        animationEnabled: false
        visible: control.showCollapsibleIcon === 'auto' ? collapseBarHovered : true
        iconSource: control.orientation === Qt.Horizontal ? HusIcon.RightOutlined : HusIcon.DownOutlined
        leftPadding: 0
        rightPadding: 0
        colorBorder: 'transparent'
        colorBg: pressed ? control.themeSource.colorHandleActive :
                           hovered ? control.themeSource.colorHandleHover :
                                     control.themeSource.colorHandle
        radiusBg.all: 2
        onClicked: {
            const selfState = __private.getState(index);
            if (selfState.state === 'collapse') {
                setItemCollapseState(index, 'normal');
                setItemCollapseState(index + 1, 'normal');
            } else if (selfState.state === 'normal') {
                setItemCollapseState(index, 'right_expand');
                setItemCollapseState(index + 1, 'collapse');
            }
        }
    }

    function setItemCollapseState(index: int, collapseState: string) {
        if (index < 0 || index >= count) return;

        const item = control.itemAt(index);
        const state = __private.getState(index);
        if (control.orientation === Qt.Horizontal) {
            if (collapseState === 'collapse') {
                item.T.SplitView.preferredWidth = 0;
            } else if (collapseState === 'normal') {
                item.T.SplitView.preferredWidth = state.size;
            } else if (collapseState === 'left_expand') {
                const nextItem = control.itemAt(index - 1);
                item.T.SplitView.preferredWidth = item.width + nextItem?.width ?? 0;
            } else {
                // right_expand
                const nextItem = control.itemAt(index + 1);
                item.T.SplitView.preferredWidth = item.width + nextItem?.width ?? 0;
            }
            __private.setState(index, { 'state': collapseState, 'size': item.width });
        } else {
            if (collapseState === 'collapse') {
                item.T.SplitView.preferredHeight = 0;
            } else if (collapseState === 'normal') {
                item.T.SplitView.preferredHeight = state.size;
            } else if (collapseState === 'left_expand') {
                const nextItem = control.itemAt(index - 1);
                item.T.SplitView.preferredHeight = item.height + nextItem?.height ?? 0;
            } else {
                // right_expand
                const nextItem = control.itemAt(index + 1);
                item.T.SplitView.preferredHeight = item.height + nextItem?.height ?? 0;
            }
            __private.setState(index, { 'state': collapseState, 'size': item.height });
        }

        __private.collapseChanged(index, collapseState);
    }

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    handle: Rectangle {
        id: __handleRoot
        implicitWidth: control.orientation === Qt.Horizontal ? control.handleSize : control.width
        implicitHeight: control.orientation === Qt.Horizontal ? control.height : control.handleSize
        enabled: control.resizable
        color: {
            if (control.resizable) {
                return T.SplitHandle.pressed ? control.themeSource.colorHandleActive
                                             : T.SplitHandle.hovered ? control.themeSource.colorHandleHover :
                                                                       control.themeSource.colorHandle;
            } else {
                return control.themeSource.colorHandle;
            }
        }
        containmentMask: Item {
            x: (__handleRoot.width - width) * 0.5
            y: (__handleRoot.height - height) * 0.5
            width: control.orientation === Qt.Horizontal ? control.handleTriggerSize : control.width
            height: control.orientation === Qt.Horizontal ? control.height : control.handleTriggerSize
        }
        /*onXChanged: {
            const item = control.itemAt(index);
            if (collapseState === 'collapse' && item.width > 0) {
                control.setItemCollapseState(index, 'normal');
                control.setItemCollapseState(index + 1, 'normal');
            } else if (collapseState === 'normal' && item.width <= 0) {
                control.setItemCollapseState(index, 'collapse');
                control.setItemCollapseState(index + 1, 'left_expand');
            }
        }*/
        Component.onCompleted: {
            index = __private.instanceCount++;
        }
        Component.onDestruction: {
            __private.instanceCount--;
        }

        property int index: 0
        property string collapseState: 'normal'

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        Rectangle {
            implicitWidth: control.orientation === Qt.Horizontal ? parent.width : 20
            implicitHeight: control.orientation === Qt.Horizontal ? 20 : parent.height
            anchors.centerIn: parent
            color: control.themeSource.colorPointer
            visible: control.resizable && control.enabled

            Connections {
                target: __private
                function onCollapseChanged(index: int, collapseState: string) {
                    if (__handleRoot.index === index) {
                        __handleRoot.collapseState = collapseState;
                    }
                }
            }

            Loader {
                id: __collapseBarStartLoader
                anchors.right: control.orientation === Qt.Horizontal ? parent.left : undefined
                anchors.bottom: control.orientation === Qt.Horizontal ? undefined : parent.top
                anchors.verticalCenter: control.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
                anchors.horizontalCenter: control.orientation === Qt.Horizontal ? undefined : parent.horizontalCenter
                visible: __handleRoot.collapseState !== 'collapse'
                active: control.showCollapsibleIcon === 'auto' || control.showCollapsibleIcon === true
                sourceComponent: control.collapseBarStart
                property alias index: __handleRoot.index
                readonly property bool collapseBarHovered: __handleRoot.T.SplitHandle.hovered ||
                                                           __hoverHandlerStart.hovered || __hoverHandlerEnd.hovered

                HoverHandler {
                    id: __hoverHandlerStart
                }
            }

            Loader {
                id: __collapseBarEndLoader
                anchors.left: control.orientation === Qt.Horizontal ? parent.right : undefined
                anchors.top: control.orientation === Qt.Horizontal ? undefined : parent.bottom
                anchors.verticalCenter: control.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
                anchors.horizontalCenter: control.orientation === Qt.Horizontal ? undefined : parent.horizontalCenter
                visible: __handleRoot.collapseState !== 'left_expand' && __handleRoot.collapseState !== 'right_expand'
                active: control.showCollapsibleIcon === 'auto' || control.showCollapsibleIcon === true
                sourceComponent: control.collapseBarEnd
                property alias index: __handleRoot.index
                readonly property bool collapseBarHovered: __handleRoot.T.SplitHandle.hovered ||
                                                           __hoverHandlerStart.hovered || __hoverHandlerEnd.hovered

                HoverHandler {
                    id: __hoverHandlerEnd
                }
            }
        }
    }

    QtObject {
        id: __private

        signal collapseChanged(index: int, collapseState: string)

        property var collapseState: new Map
        property int instanceCount: 0

        function setState(index: int, value: var) {
            collapseState.set(index, value);
        }

        function getState(index: int): var {
            if (!collapseState.has(index)) {
                collapseState.set(index, { 'state': 'normal', 'size': 0 });
            }
            return collapseState.get(index);
        }
    }
}