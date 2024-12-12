import QtQuick
import DelegateUI

Item {
    id: secondPage

    Column {
        anchors.centerIn: parent
        spacing: 10

        DelButton {
            text: qsTr("漫游步骤")
            type: DelButtonType.Type_Primary
            onClicked: {
                tourStep.resetStep();
                tourStep.open();
            }

            DelTourStep {
                id: tourStep
                stepModel: [
                    {
                        target: tourStep1,
                        title: qsTr("步骤1"),
                        titleColor: "#3fcc9b",
                        description: qsTr("这是步骤1\n========"),
                    },
                    {
                        target: tourStep2,
                        title: qsTr("步骤2"),
                        description: qsTr("这是步骤2\n!!!!!!!!!!"),
                        descriptionColor: "#3116ff"
                    },
                    {
                        target: tourStep3,
                        cardColor: "#ffa2eb",
                        title: qsTr("步骤3"),
                        titleColor: "red",
                        description: qsTr("这是步骤3\n##############")
                    }
                ]
            }
        }

        Row {
            spacing: 10

            DelButton {
                id: tourStep1
                text: qsTr("漫游步骤1")
            }

            DelButton {
                id: tourStep2
                text: qsTr("漫游步骤2")
            }

            DelButton {
                id: tourStep3
                text: qsTr("漫游步骤3   ####")
            }
        }
    }
}
