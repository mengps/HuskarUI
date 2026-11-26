import QtQuick
import HuskarUI.Basic

QtObject {
    id: root

    readonly property list<QtObject> __groups: [
        OverviewGeneralPreviews {},
        OverviewLayoutNavigationPreviews {},
        OverviewDataEntryPreviews {},
        OverviewDataDisplayPreviews {},
        OverviewEffectsAndUtilitiesPreviews {},
        OverviewFeedbackPreviews {},
        OverviewThemeAndApiPreviews {}
    ]
    readonly property var __samples: {
        const samples = new Map();
        for (const group of root.__groups) {
            for (const sample of group.samples)
                samples.set(sample.key, sample);
        }
        return samples;
    }

    function sampleFor(key) {
        return __samples.get(key) ?? __fallback;
    }

    readonly property OverviewSample __fallback: OverviewSample {
        key: ''
        content: Item {
            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                spacing: 8

                HusText {
                    width: parent.width
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading5
                    text: 'Preview Pending'
                }
                HusText {
                    width: parent.width
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    color: HusTheme.Primary.colorTextSecondary
                    text: 'This component preview can be expanded here.'
                }
            }
        }
    }
}
