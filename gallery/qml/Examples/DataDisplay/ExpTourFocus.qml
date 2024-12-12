import QtQuick
import DelegateUI

Item {
    id: firstPage

    Column {
        anchors.centerIn: parent
        spacing: 10

        DelButton {
            text: qsTr("漫游焦点")
            type: DelButtonType.Type_Primary
            onClicked: {
                tourFocus.open();
            }

            DelTourFocus {
                id: tourFocus
                currentTarget: tourFocus1
            }
        }

        Row {
            spacing: 10

            DelButton {
                id: tourFocus1
                text: qsTr("漫游焦点1")
                type: DelButtonType.Type_Outlined
            }
        }
    }
}
