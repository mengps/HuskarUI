import QtQuick
import QtQuick.Layouts
import DelegateUI

Item {

    Grid {
        anchors.centerIn: parent
        columnSpacing: 15
        rowSpacing: 15
        columns: 5
        rows: 4

        DelButton {
            text: qsTr("默认")
        }

        DelButton {
            text: qsTr("线框")
            type: DelButtonType.Type_Outlined
        }

        DelButton {
            text: qsTr("主要")
            type: DelButtonType.Type_Primary
        }

        DelButton {
            text: qsTr("填充")
            type: DelButtonType.Type_Filled
        }

        DelButton {
            text: qsTr("文本")
            type: DelButtonType.Type_Text
        }

        DelButton {
            text: qsTr("默认")
            enabled: false
        }

        DelButton {
            text: qsTr("线框")
            type: DelButtonType.Type_Outlined
            enabled: false
        }

        DelButton {
            text: qsTr("主要")
            type: DelButtonType.Type_Primary
            enabled: false
        }

        DelButton {
            text: qsTr("填充")
            type: DelButtonType.Type_Filled
            enabled: false
        }

        DelButton {
            text: qsTr("文本")
            type: DelButtonType.Type_Text
            enabled: false
        }

        DelButton {
            text: qsTr("A")
            shape: DelButtonType.Shape_Circle
        }

        DelButton {
            text: qsTr("A")
            type: DelButtonType.Type_Outlined
            shape: DelButtonType.Shape_Circle
        }

        DelButton {
            text: qsTr("A")
            type: DelButtonType.Type_Primary
            shape: DelButtonType.Shape_Circle
        }

        DelButton {
            text: qsTr("A")
            type: DelButtonType.Type_Filled
            shape: DelButtonType.Shape_Circle
        }

        DelButton {
            text: qsTr("A")
            type: DelButtonType.Type_Text
            shape: DelButtonType.Shape_Circle
        }

        DelIconButton {
            text: qsTr("搜索")
            iconSource: DelIcon.SearchOutlined
        }

        DelIconButton {
            text: qsTr("搜索")
            type: DelButtonType.Type_Outlined
            iconSource: DelIcon.SearchOutlined
        }

        DelIconButton {
            //text: qsTr("搜索")
            type: DelButtonType.Type_Primary
            iconSource: DelIcon.SearchOutlined
        }

        DelIconButton {
            text: qsTr("搜索")
            type: DelButtonType.Type_Filled
            iconSource: DelIcon.SearchOutlined
        }

        DelIconButton {
            text: qsTr("搜索")
            type: DelButtonType.Type_Text
            iconSource: DelIcon.SearchOutlined
        }
    }

    Component.onCompleted: {
        /*const map = DelIcon.allIconNames();
        for (const key in map) {
            console.debug(key, map[key].toString(16));
        }*/
    }
}
