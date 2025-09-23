import QtQuick
import HuskarUI.Basic

Item {
    id: root

    width: parent.width
    height: visible ? column.height + 20 : 0
    visible: containerLoader.tagState !== ''

    Column {
        id: column
        spacing: 10

        HusText {
            text: qsTr('更新信息')
            font {
                pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                weight: Font.DemiBold
            }
        }

        HusTag {
            text: `${containerLoader.tagState}: version ${containerLoader.version}`
            presetColor: {
                if (containerLoader.tagState === 'New')
                    return 'red';
                else if (containerLoader.tagState === 'Update')
                    return 'green';
                else return '';
            }
        }

        HusTag {
            text: `${containerLoader.desc}`
            presetColor: 'purple'
        }
    }
}
