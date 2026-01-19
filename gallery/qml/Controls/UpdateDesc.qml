import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: root

    width: parent.width
    height: column.height

    ColumnLayout {
        id: column
        width: parent.width
        spacing: 10

        HusText {
            Layout.bottomMargin: 5
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
