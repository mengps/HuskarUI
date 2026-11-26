pragma ComponentBehavior: Bound

import QtQuick
import HuskarUI.Basic

HusFrame {
    id: root

    required property var sectionData
    required property bool compact
    required property int cardSpacing
    required property int cardChromeHeight

    colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.88)
    borderBg.color: HusTheme.Primary.colorBorderSecondary

    Column {
        width: parent.width
        spacing: 18

        Row {
            spacing: 10

            HusIconText {
                iconSource: root.sectionData.iconSource
                iconSize: 18
                text: `${root.sectionData.label} (${root.sectionData.items.length})`
                font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading5
            }

            HusLabel {
                anchors.verticalCenter: parent.verticalCenter
                text: root.sectionData.key
                colorBg: HusTheme.Primary.colorFillSecondary
                colorText: HusTheme.Primary.colorTextSecondary
            }
        }

        Flow {
            width: parent.width
            spacing: root.cardSpacing

            Repeater {
                model: root.sectionData.items

                HusFrame {
                    id: card

                    required property var modelData
                    readonly property size sampleSize: root.compact ? modelData.sample.compactSize : modelData.sample.normalSize

                    width: sampleSize.width
                    height: sampleSize.height + root.cardChromeHeight
                    padding: 14
                    colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.92)
                    borderBg.color: HusTheme.Primary.colorBorderSecondary

                    Column {
                        anchors.fill: parent
                        spacing: 12

                        Row {
                            width: parent.width
                            spacing: 8

                            HusText {
                                width: card.modelData.version ? parent.width - 88 : parent.width
                                text: card.modelData.key
                                elide: Text.ElideRight
                                font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading5
                            }

                            HusTag {
                                visible: card.modelData.version !== ''
                                text: card.modelData.version
                                colorBg: HusTheme.Primary.colorInfoBg
                                colorText: HusTheme.Primary.colorInfo
                            }
                        }

                        HusText {
                            width: parent.width
                            height: 34
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            color: HusTheme.Primary.colorTextSecondary
                            text: card.modelData.description
                        }

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: HusTheme.Primary.colorBorderSecondary
                        }

                        Loader {
                            width: parent.width
                            height: card.sampleSize.height
                            clip: true
                            asynchronous: true
                            sourceComponent: card.modelData.sample.content
                        }
                    }
                }
            }
        }
    }
}
