import QtQuick
import DelegateUI

Item {
    id: control

    width: __row.width
    height: __row.height

    signal finished(input: string)

    property bool animationEnabled: DelTheme.animationEnabled
    property int length: 6
    property int characterLength: 1
    property int currentIndex: 0
    property string currentInput: ""
    property int itemWidth: 45
    property int itemHeight: 32
    property alias itemSpacing: __row.spacing
    property var itemValidator: IntValidator { top: 9; bottom: 0 }
    property int itemInputMethodHints: Qt.ImhHiddenText
    property bool itemPassword: false
    property string itemPasswordCharacter: ""
    property var formatter: (text) => text

    property color colorItemText: enabled ? DelTheme.DelInput.colorText : DelTheme.DelInput.colorTextDisabled
    property color colorItemBorder: enabled ? DelTheme.DelInput.colorBorder : DelTheme.DelInput.colorBorderDisabled
    property color colorItemBorderActive: enabled ? DelTheme.DelInput.colorBorderHover : DelTheme.DelInput.colorBorderDisabled
    property color colorItemBg: enabled ? DelTheme.DelInput.colorBg : DelTheme.DelInput.colorBgDisabled
    property int radiusBg: 6

    property Component dividerDelegate: Item { }

    onCurrentIndexChanged: {
        const item = __repeater.itemAt(currentIndex << 1);
        if (item && item.index % 2 == 0)
            item.item.selectThis();
    }

    function getInput() {
        let input = "";
        for (let i = 0; i < __repeater.count; i++) {
            const item = __repeater.itemAt(i);
            if (item && item.index % 2 == 0) {
                input += item.item.text;
            }
        }
        return input;
    }

    Component {
        id: __inputDelegate

        DelInput {
            id: __rootItem
            width: control.itemWidth
            height: control.itemHeight
            verticalAlignment: DelInput.AlignVCenter
            horizontalAlignment: DelInput.AlignHCenter
            enabled: control.enabled
            colorText: control.colorItemText
            colorBorder: active ? control.colorItemBorderActive : control.colorItemBorder
            colorBg: control.colorItemBg
            radiusBg: control.radiusBg
            validator: control.itemValidator
            inputMethodHints: control.itemInputMethodHints
            echoMode: control.itemPassword ? DelInput.Password : DelInput.Normal
            passwordCharacter:control.itemPasswordCharacter
            onReleased: __timer.restart();
            onTextEdited: {
                text = control.formatter(text);
                const isFull = length >= control.characterLength;
                if (isFull) selectAll();

                if (isBackspace) isBackspace = false;

                const input = control.getInput();
                control.currentInput = input;

                if (isFull) {
                    if (control.currentIndex < (control.length - 1))
                        control.currentIndex++;
                    else
                        control.finished(input);
                }
            }

            property int __index: index
            property bool isBackspace: false

            function selectThis() {
                forceActiveFocus();
                selectAll();
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace) {
                    clear();
                    const input = control.getInput();
                    control.currentInput = input;
                    isBackspace = true;
                    if (control.currentIndex != 0)
                        control.currentIndex--;
                }
            }

            Timer {
                id: __timer
                interval: 100
                onTriggered: {
                    control.currentIndex = __rootItem.__index >> 1;
                    __rootItem.selectAll();
                }
            }
        }
    }

    Row {
        id: __row
        spacing: 8

        Repeater {
            id: __repeater
            model: control.length * 2 - 1
            delegate: Loader {
                sourceComponent: index % 2 == 0 ? __inputDelegate : dividerDelegate
                required property int index
            }
        }
    }
}
