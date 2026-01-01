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

T.Control {
    id: control

    enum Type {
        Type_Filled = 0,
        Type_Outlined = 1
    }

    enum Size {
        Size_Auto = 0,
        Size_Fixed = 1
    }

    signal clicked(index: int, radioData: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property var model: []
    readonly property int count: model.length
    property int initCheckedIndex: -1
    property int currentCheckedIndex: -1
    property var currentCheckedValue: undefined
    property int type: HusRadioBlock.Type_Filled
    property int size: HusRadioBlock.Size_Auto
    property int radioWidth: 120
    property int radioHeight: 30
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusRadioBlock

    property Component toolTipDelegate: HusToolTip {
        animationEnabled: control.animationEnabled
        visible: hovered
        font: control.font
        locale: control.locale
        text: toolTip.text ?? ''
        delay: toolTip.delay ?? 500
        timeout: toolTip.timeout ?? -1
    }
    property Component radioDelegate: HusIconButton {
        id: __rootItem

        required property var modelData
        required property int index

        T.ButtonGroup.group: __buttonGroup
        Component.onCompleted: {
            if (control.initCheckedIndex == index) {
                checked = true;
                __buttonGroup.clicked(__rootItem);
            }
        }

        implicitWidth: control.size == HusRadioBlock.Size_Auto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                 control.radioWidth
        implicitHeight: control.size == HusRadioBlock.Size_Auto ? (implicitContentHeight + topPadding + bottomPadding) :
                                                                  control.radioHeight
        z: (hovered || checked) ? 1 : 0
        animationEnabled: control.animationEnabled
        effectEnabled: control.effectEnabled
        hoverCursorShape: control.hoverCursorShape
        enabled: control.enabled && (modelData.enabled === undefined ? true : modelData.enabled)
        themeSource: control.themeSource
        locale: control.locale
        font: control.font
        type: HusButton.Type_Default
        iconSource: modelData.iconSource ?? 0
        text: modelData.label ?? ''
        colorBorder: (enabled && checked) ? control.themeSource.colorBorderChecked :
                                            control.themeSource.colorBorder;
        colorText: {
            if (enabled) {
                if (control.type == HusRadioBlock.Type_Filled) {
                    return checked ? control.themeSource.colorTextFilledChecked :
                                     hovered ? control.themeSource.colorTextChecked :
                                               control.themeSource.colorText;
                } else {
                    return (checked || hovered) ? control.themeSource.colorTextChecked :
                                                  control.themeSource.colorText;
                }
            } else {
                return control.themeSource.colorTextDisabled;
            }
        }
        colorBg: {
            if (enabled) {
                if (control.type == HusRadioBlock.Type_Filled) {
                    return down ? (checked ? control.themeSource.colorBgActive : control.themeSource.colorBg) :
                                  hovered ? (checked ? control.themeSource.colorBgHover : control.themeSource.colorBg) :
                                            checked ? control.themeSource.colorBgChecked :
                                                      control.themeSource.colorBg;
                } else {
                    return control.themeSource.colorBg;
                }
            } else {
                return checked ? control.themeSource.colorBgCheckedDisabled : control.themeSource.colorBgDisabled;
            }
        }
        checkable: true
        background: Item {
            HusRectangleInternal {
                id: __effect
                width: __bg.width
                height: __bg.height
                anchors.centerIn: parent
                visible: __rootItem.effectEnabled
                topLeftRadius: __bg.topLeftRadius
                topRightRadius: __bg.topRightRadius
                bottomLeftRadius: __bg.bottomLeftRadius
                bottomRightRadius: __bg.bottomRightRadius
                color: 'transparent'
                border.width: 0
                border.color: __rootItem.enabled ? control.themeSource.colorEffectBg : 'transparent'
                opacity: 0.2

                ParallelAnimation {
                    id: __animation
                    onFinished: __effect.border.width = 0;
                    NumberAnimation {
                        target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                        duration: HusTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                        duration: HusTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'opacity'; from: 0.2; to: 0;
                        duration: HusTheme.Primary.durationSlow
                    }
                }

                Connections {
                    target: __rootItem
                    function onReleased() {
                        if (__rootItem.animationEnabled && __rootItem.effectEnabled) {
                            __effect.border.width = 8;
                            __animation.restart();
                        }
                    }
                }
            }

            HusRectangleInternal {
                id: __bg
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                color: __rootItem.colorBg
                topLeftRadius: index == 0 ? control.radiusBg.topLeft : 0
                topRightRadius: index === (count - 1) ? control.radiusBg.topRight : 0
                bottomLeftRadius: index == 0 ? control.radiusBg.bottomLeft : 0
                bottomRightRadius: index === (count - 1) ? control.radiusBg.bottomRight : 0
                border.width: 1
                border.color: __rootItem.colorBorder

                Behavior on color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
                Behavior on border.color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
            }
        }

        Loader {
            x: (parent.width - width) * 0.5
            active: toolTip !== undefined
            sourceComponent: control.toolTipDelegate
            property bool checked: __rootItem.released
            property bool pressed: __rootItem.pressed
            property bool hovered: __rootItem.hovered
            property var toolTip: modelData.toolTip
        }

        Connections {
            target: control
            function onCurrentCheckedIndexChanged() {
                if (__rootItem.index == control.currentCheckedIndex) {
                    __rootItem.checked = true;
                }
            }
        }
    }

    objectName: '__HusRadioBlock__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    contentItem: Loader {
        sourceComponent: Row {
            spacing: -1

            Repeater {
                id: __repeater
                model: control.model
                delegate: radioDelegate
            }
        }

        T.ButtonGroup {
            id: __buttonGroup
            onClicked:
                button => {
                    control.currentCheckedIndex = button.index;
                    control.currentCheckedValue = button.modelData.value;
                    control.clicked(button.index, button.modelData);
                }
        }
    }

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
}
