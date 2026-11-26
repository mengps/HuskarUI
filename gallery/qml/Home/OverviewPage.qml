pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic
import "Overview"

Item {
    id: page

    readonly property int __columnWidth: 500
    readonly property int __columnSpacing: 20
    readonly property int __sectionPadding: 18
    readonly property int __cardSpacing: 12
    readonly property int __cardChromeHeight: 108
    readonly property int __wideSectionThreshold: 672
    readonly property bool __viewportReady: width > 0 && height > 0
    property int __columnCount: 0
    readonly property int __sceneWidth: __columnCount * __columnWidth + Math.max(0, __columnCount - 1) * __columnSpacing

    readonly property var __sections: galleryGlobal.galleryModel.filter(section => section.menuChildren?.length).map(section => ({
        key: section.key,
        label: section.label,
        iconSource: section.iconSource,
        items: section.menuChildren.map(entry => ({
            key: entry.key,
            description: (entry.desc || '').replace(/\s+/g, ' ').trim() || entry.label || entry.key,
            version: entry.addVersion || entry.updateVersion || '',
            sample: previews.sampleFor(entry.key)
        }))
    }))
    readonly property var __layout: __columnCount > 0 ? __arrangeSections() : ({ wide: [], columns: [] })

    Component.onCompleted: Qt.callLater(__initialize)
    on__ViewportReadyChanged: {
        if (__viewportReady && __columnCount === 0)
            Qt.callLater(__initialize);
    }

    function __initialize() {
        if (!__viewportReady || __columnCount > 0)
            return;
        __columnCount = __columnsForWidth((width - 72) / canvas.zoom);
        canvas.fit();
    }

    function __columnsForWidth(width) {
        if (width >= 1820)
            return 4;
        if (width >= 1260)
            return 3;
        if (width >= 860)
            return 2;
        return 1;
    }

    function __cardRowsHeight(items, width, compact) {
        const contentWidth = width - __sectionPadding * 2;
        let rowWidth = 0;
        let rowHeight = 0;
        let height = 0;
        for (const item of items) {
            const size = compact ? item.sample.compactSize : item.sample.normalSize;
            if (rowWidth > 0 && rowWidth + __cardSpacing + size.width > contentWidth) {
                height += rowHeight + __cardSpacing;
                rowWidth = 0;
                rowHeight = 0;
            }
            rowWidth += (rowWidth > 0 ? __cardSpacing : 0) + size.width;
            rowHeight = Math.max(rowHeight, size.height + __cardChromeHeight);
        }
        return height + rowHeight;
    }

    function __arrangeSections() {
        const wide = [];
        const columns = Array.from({ length: __columnCount }, () => []);
        let columnIndex = 0;
        for (const section of __sections) {
            if (__columnCount > 1) {
                const normalHeight = __cardRowsHeight(section.items, __columnWidth, false);
                if (normalHeight > __wideSectionThreshold &&
                    __cardRowsHeight(section.items, __sceneWidth, true) < normalHeight) {
                    wide.push(section);
                    continue;
                }
            }
            columns[columnIndex].push(section);
            columnIndex = (columnIndex + 1) % __columnCount;
        }
        return { wide, columns };
    }

    OverviewPreviews {
        id: previews
    }

    component SectionCard: OverviewSection {
        padding: page.__sectionPadding
        cardSpacing: page.__cardSpacing
        cardChromeHeight: page.__cardChromeHeight
    }

    OverviewCanvas {
        id: canvas
        anchors.fill: parent
        sceneEnabled: previewEnabled.checked
        backgroundOpacity: galleryBackground.opacity

        Column {
            width: page.__sceneWidth
            spacing: page.__columnSpacing

            HusFrame {
                width: page.__sceneWidth
                padding: page.__sectionPadding
                colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.88)
                borderBg.color: HusTheme.Primary.colorBorderSecondary

                Column {
                    width: parent.width
                    spacing: 10

                    HusText {
                        text: qsTr('HuskarUI 组件全览')
                        font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                    }

                    HusText {
                        width: parent.width
                        wrapMode: Text.Wrap
                        color: HusTheme.Primary.colorTextSecondary
                        text: qsTr(' - 鼠标左键拖动画布。\n - Ctrl + 鼠标滚轮控制缩放。')
                    }
                }
            }

            Repeater {
                model: page.__layout.wide
                SectionCard {
                    required property var modelData
                    width: page.__sceneWidth
                    compact: true
                    sectionData: modelData
                }
            }

            Row {
                spacing: page.__columnSpacing

                Repeater {
                    model: page.__layout.columns
                    Column {
                        id: sectionColumn
                        required property var modelData
                        width: page.__columnWidth
                        spacing: page.__columnSpacing

                        Repeater {
                            model: sectionColumn.modelData
                            SectionCard {
                                required property var modelData
                                width: page.__columnWidth
                                compact: false
                                sectionData: modelData
                            }
                        }
                    }
                }
            }
        }
    }

    component ZoomButton: HusIconButton {
        Layout.preferredWidth: 20
        Layout.preferredHeight: 20
        Layout.alignment: Qt.AlignVCenter
        padding: 4
    }

    HusFrame {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        padding: 12
        colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.8)
        borderBg.color: HusTheme.Primary.colorBorderSecondary

        RowLayout {
            HusCheckBox {
                id: previewEnabled
                text: qsTr('Enabled')
                checked: true
            }

            HusText {
                Layout.alignment: Qt.AlignVCenter
                text: Math.round(canvas.zoom * 100) + '%'
            }

            ZoomButton {
                iconSource: HusIcon.MinusOutlined
                onClicked: canvas.zoomTo(canvas.zoom / 1.1)
            }

            HusSlider {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                min: canvas.minZoom * 100
                max: canvas.maxZoom * 100
                stepSize: 1
                value: canvas.zoom * 100
                onFirstMoved: canvas.zoomTo(currentValue / 100)
                onFirstReleased: canvas.zoomTo(currentValue / 100)
            }

            ZoomButton {
                iconSource: HusIcon.PlusOutlined
                onClicked: canvas.zoomTo(canvas.zoom * 1.1)
            }

            ZoomButton {
                iconSource: HusIcon.BorderInnerOutlined
                onClicked: {
                    canvas.fit();
                    canvas.zoomTo(1);
                }
            }

            ZoomButton {
                iconSource: HusIcon.CompressOutlined
                onClicked: canvas.fit()
            }
        }
    }
}
