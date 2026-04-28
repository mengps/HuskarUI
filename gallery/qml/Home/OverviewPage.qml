import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import HuskarUI.Basic
import ".."

Item {
    id: control

    property real zoom: 0.76
    property real minZoom: 0.25
    property real maxZoom: 4.0
    property real panX: 0
    property real panY: 0
    property int canvasPadding: 36
    property int waterfallColumnWidth: 500
    property int waterfallSpacing: 20
    property int sceneWidth: Math.max(1, waterfallContentWidth)
    property int fitReferenceHeight: 980
    property int waterfallColumnCount: 0//columnCountForWidth((Math.max(1, canvasViewport.width) - canvasPadding * 2) / Math.max(zoom, 0.01))
    property int waterfallContentWidth: waterfallColumnCount * waterfallColumnWidth + Math.max(0, waterfallColumnCount - 1) * waterfallSpacing
    property int sectionContentPadding: 36
    property int sectionInnerSpacing: 12
    property int wideSectionHeightThreshold: 760
    property int cameraMargin: 1600
    property var overviewSections: buildSections()

    onZoomChanged: gridCanvas.requestPaint();
    onPanXChanged: gridCanvas.requestPaint();
    onPanYChanged: gridCanvas.requestPaint();
    Component.onCompleted: {
        waterfallColumnCount = columnCountForWidth((Math.max(1, canvasViewport.width) - canvasPadding * 2) / Math.max(zoom, 0.01));
        fitScene();
    }

    component PreviewItemCard: HusFrame {
        width: control.sampleWidthFor(componentData.key, compactMode)
        height: control.previewCardTotalHeight(componentData.key, compactMode)
        padding: 14
        colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.92)
        colorBorder: HusTheme.Primary.colorBorderSecondary

        required property var componentData
        property bool compactMode: false

        Column {
            anchors.fill: parent
            spacing: 12

            Row {
                width: parent.width
                spacing: 8

                HusText {
                    width: componentData.version ? parent.width - 88 : parent.width
                    text: componentData.key
                    elide: Text.ElideRight
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading5
                }

                HusTag {
                    visible: componentData.version !== ''
                    text: componentData.version
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
                text: componentData.desc || componentData.label
            }

            Rectangle {
                width: parent.width
                height: 1
                color: HusTheme.Primary.colorBorderSecondary
            }

            Item {
                width: parent.width
                height: control.sampleHeightFor(componentData.key, compactMode)
                clip: true

                Loader {
                    anchors.fill: parent
                    asynchronous: true
                    sourceComponent: control.previewComponentFor(componentData.key)
                }
            }
        }
    }

    component SectionCard: HusFrame {
        id: sectionCard
        width: control.sectionWidthFor(sectionData)
        padding: 18
        colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.88)
        colorBorder: HusTheme.Primary.colorBorderSecondary

        required property var sectionData
        property bool compactMode: control.isWideSection(sectionData)

        Column {
            width: parent.width
            spacing: 18

            Row {
                width: parent.width
                spacing: 10

                HusIconText {
                    iconSource: sectionData.iconSource
                    iconSize: 18
                    text: `${sectionData.label} (${sectionData.items.length})`
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading5
                }

                HusLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: sectionData.key
                    colorBg: HusTheme.Primary.colorFillSecondary
                    colorText: HusTheme.Primary.colorTextSecondary
                }
            }

            Flow {
                width: parent.width
                spacing: 12

                Repeater {
                    model: sectionData.items
                    delegate: PreviewItemCard {
                        required property var modelData
                        componentData: modelData
                        compactMode: sectionCard.compactMode
                    }
                }
            }
        }
    }

    function normalizeText(value) {
        return `${value || ''}`.replace(/\s+/g, ' ').trim();
    }

    function buildSections() {
        const result = [];
        const source = galleryGlobal.galleryModel;
        for (let i = 0; i < source.length; ++i) {
            const section = source[i];
            if (!section.menuChildren || section.menuChildren.length === 0)
                continue;
            const items = [];
            for (let j = 0; j < section.menuChildren.length; ++j) {
                const entry = section.menuChildren[j];
                items.push({
                    key: entry.key,
                    label: entry.label || entry.key,
                    desc: normalizeText(entry.desc),
                    version: entry.addVersion || entry.updateVersion || ''
                });
            }
            result.push({
                key: section.key,
                label: section.label,
                iconSource: section.iconSource,
                items: items
            });
        }
        return result;
    }

    function galleryImage(name) {
        return Qt.resolvedUrl(`../../images/${name}`);
    }

    function columnCountForWidth(width) {
        if (width >= 1820)
            return 4;
        if (width >= 1260)
            return 3;
        if (width >= 860)
            return 2;
        return 1;
    }

    function previewCardTotalHeight(key, compactMode) {
        return sampleHeightFor(key, compactMode) + 108;
    }

    function estimateSectionHeight(sectionData, sectionWidth, compactMode) {
        if (!sectionData || !sectionData.items || sectionData.items.length === 0)
            return 0;
        const contentWidth = Math.max(1, sectionWidth - sectionContentPadding);
        let currentRowWidth = 0;
        let currentRowHeight = 0;
        let rowsHeight = 0;
        for (let i = 0; i < sectionData.items.length; ++i) {
            const item = sectionData.items[i];
            const itemWidth = sampleWidthFor(item.key, compactMode);
            const itemHeight = previewCardTotalHeight(item.key, compactMode);
            const nextWidth = currentRowWidth === 0 ? itemWidth : currentRowWidth + sectionInnerSpacing + itemWidth;
            if (currentRowWidth > 0 && nextWidth > contentWidth) {
                rowsHeight += currentRowHeight + sectionInnerSpacing;
                currentRowWidth = itemWidth;
                currentRowHeight = itemHeight;
            } else {
                currentRowWidth = nextWidth;
                currentRowHeight = Math.max(currentRowHeight, itemHeight);
            }
        }
        if (currentRowHeight > 0)
            rowsHeight += currentRowHeight;
        return 70 + 18 + rowsHeight;
    }

    function isWideSection(sectionData) {
        if (!sectionData || !sectionData.items || waterfallColumnCount < 2)
            return false;
        const normalHeight = estimateSectionHeight(sectionData, waterfallColumnWidth, false);
        const wideHeight = estimateSectionHeight(sectionData, waterfallContentWidth, true);
        return normalHeight > wideSectionHeightThreshold && wideHeight < normalHeight;
    }

    function wideSections() {
        const sections = [];
        for (let i = 0; i < overviewSections.length; ++i) {
            if (isWideSection(overviewSections[i]))
                sections.push(overviewSections[i]);
        }
        return sections;
    }

    function sectionsForColumn(columnIndex) {
        const sections = [];
        const count = Math.max(1, waterfallColumnCount);
        for (let i = 0; i < overviewSections.length; ++i) {
            if (isWideSection(overviewSections[i]))
                continue;
            if ((sections.length % count) === columnIndex)
                sections.push(overviewSections[i]);
        }
        return sections;
    }

    function sectionWidthFor(sectionData) {
        return isWideSection(sectionData) ? waterfallContentWidth : waterfallColumnWidth;
    }

    function sampleWidthFor(key, compactMode) {
        switch (key) {
        case 'HusMenu':
        case 'HusContextMenu':
        case 'HusPage':
        case 'HusTabView':
        case 'HusCollapse':
        case 'HusCarousel':
        case 'HusImagePreview':
        case 'HusTableView':
        case 'HusTransfer':
        case 'HusTreeView':
        case 'HusSwitchEffect':
        case 'HusWatermark':
            return compactMode ? 328 : 388;
        case 'HusTourStep':
        case 'HusDrawer':
        case 'HusNotification':
        case 'HusModal':
        case 'HusWindow':
            return compactMode ? 300 : 336;
        default:
            return compactMode ? 248 : 288;
        }
    }

    function sampleHeightFor(key, compactMode) {
        switch (key) {
        case 'HusWindow':
        case 'HusPage':
        case 'HusMenu':
        case 'HusContextMenu':
        case 'HusTransfer':
        case 'HusWatermark':
        case 'HusSwitchEffect':
            return compactMode ? 240 : 258;
        case 'HusTableView':
        case 'HusTreeView':
        case 'HusImagePreview':
        case 'HusCarousel':
            return compactMode ? 220 : 236;
        case 'HusTourStep':
        case 'HusDrawer':
        case 'HusNotification':
        case 'HusModal':
        case 'HusTourFocus':
        case 'HusCaptionBar':
            return compactMode ? 196 : 212;
        case 'HusTabView':
        case 'HusCollapse':
        case 'HusPopover':
        case 'HusPopconfirm':
        case 'HusDateTimePickerPanel':
        case 'HusColorPickerPanel':
            return compactMode ? 174 : 188;
        default:
            return compactMode ? 126 : 136;
        }
    }

    function clampValue(value, minValue, maxValue) {
        return Math.max(minValue, Math.min(maxValue, value));
    }

    function sceneWidthForZoom(zoomValue) {
        const viewportWidth = Math.max(1, canvasViewport.width);
        const availableWidth = (viewportWidth - canvasPadding * 2) / Math.max(zoomValue, 0.01);
        const columnCount = columnCountForWidth(availableWidth);
        return Math.max(1, columnCount * waterfallColumnWidth + Math.max(0, columnCount - 1) * waterfallSpacing);
    }

    function horizontalSceneWidth(zoomValue) {
        return sceneWidthForZoom(zoomValue);
    }

    function visibleWorldWidth(zoomValue) {
        return Math.max(1, canvasViewport.width) / zoomValue;
    }

    function visibleWorldHeight(zoomValue) {
        return Math.max(1, canvasViewport.height) / zoomValue;
    }

    function sceneContentLeft() {
        return sceneStack.childrenRect.x;
    }

    function sceneContentWidth() {
        return Math.max(1, sceneStack.childrenRect.width);
    }

    function minPanX() {
        return -cameraMargin;
    }

    function minPanY() {
        return -cameraMargin;
    }

    function maxPanXFor(zoomValue) {
        return Math.max(minPanX(), horizontalSceneWidth(zoomValue) + cameraMargin - visibleWorldWidth(zoomValue));
    }

    function maxPanYFor(zoomValue) {
        return Math.max(minPanY(), sceneStack.height + cameraMargin - visibleWorldHeight(zoomValue));
    }

    function panRangeXFor(zoomValue) {
        return Math.max(0, maxPanXFor(zoomValue) - minPanX());
    }

    function panRangeYFor(zoomValue) {
        return Math.max(0, maxPanYFor(zoomValue) - minPanY());
    }

    function setPan(nextPanX, nextPanY) {
        panX = clampValue(nextPanX, minPanX(), maxPanXFor(zoom));
        panY = clampValue(nextPanY, minPanY(), maxPanYFor(zoom));
    }

    function horizontalBarSize() {
        return clampValue(visibleWorldWidth(zoom) / (horizontalSceneWidth(zoom) + cameraMargin * 2), 0, 1);
    }

    function verticalBarSize() {
        return clampValue(visibleWorldHeight(zoom) / (sceneStack.height + cameraMargin * 2), 0, 1);
    }

    function horizontalBarPosition() {
        const range = panRangeXFor(zoom);
        return range === 0 ? 0 : (panX - minPanX()) / range;
    }

    function verticalBarPosition() {
        const range = panRangeYFor(zoom);
        return range === 0 ? 0 : (panY - minPanY()) / range;
    }

    function fitScene() {
        const viewportWidth = Math.max(1, canvasViewport.width);
        const viewportHeight = Math.max(1, canvasViewport.height);
        const heightZoom = (viewportHeight - canvasPadding * 4) / fitReferenceHeight;
        let nextZoom = clampValue(heightZoom, minZoom, 1.0);
        for (let i = 0; i < 2; ++i) {
            const widthZoom = (viewportWidth - canvasPadding * 4) / sceneWidthForZoom(nextZoom);
            nextZoom = clampValue(Math.min(widthZoom, heightZoom), minZoom, 1.0);
        }
        zoom = nextZoom;
        const targetPanX = (sceneWidthForZoom(zoom) - visibleWorldWidth(zoom)) * 0.5;
        setPan(targetPanX, Math.max(panY, minPanY()));
    }

    function setZoomAt(nextZoom, viewportX, viewportY) {
        nextZoom = clampValue(nextZoom, minZoom, maxZoom);
        if (Math.abs(nextZoom - zoom) < 0.001)
            return;
        const localX = clampValue(viewportX, 0, canvasViewport.width);
        const localY = clampValue(viewportY, 0, canvasViewport.height);
        const worldX = panX + localX / zoom;
        const worldY = panY + localY / zoom;
        zoom = nextZoom;
        setPan(worldX - localX / zoom, worldY - localY / zoom);
    }

    function setZoomTo(nextZoom) {
        setZoomAt(nextZoom, canvasViewport.width * 0.5, canvasViewport.height * 0.5);
    }

    function zoomBy(factor) {
        setZoomTo(zoom * factor);
    }

    function previewComponentFor(key) {
        switch (key) {
        case 'HusWindow':
            return previewHusWindowComponent;
        case 'HusButton':
            return previewHusButtonComponent;
        case 'HusIconButton':
            return previewHusIconButtonComponent;
        case 'HusCaptionButton':
            return previewHusCaptionButtonComponent;
        case 'HusIconText':
            return previewHusIconTextComponent;
        case 'HusCopyableText':
            return previewHusCopyableTextComponent;
        case 'HusRectangle':
            return previewHusRectangleComponent;
        case 'HusPopup':
            return previewHusPopupComponent;
        case 'HusText':
            return previewHusTextComponent;
        case 'HusButtonBlock':
            return previewHusButtonBlockComponent;
        case 'HusMoveMouseArea':
            return previewHusMoveMouseAreaComponent;
        case 'HusResizeMouseArea':
            return previewHusResizeMouseAreaComponent;
        case 'HusCaptionBar':
            return previewHusCaptionBarComponent;
        case 'HusRadius':
            return previewHusRadiusComponent;
        case 'HusLabel':
            return previewHusLabelComponent;
        case 'HusFrame':
            return previewHusFrameComponent;
        case 'HusPage':
            return previewHusPageComponent;
        case 'HusDivider':
            return previewHusDividerComponent;
        case 'HusSpace':
            return previewHusSpaceComponent;
        case 'HusGroupBox':
            return previewHusGroupBoxComponent;
        case 'HusMenu':
            return previewHusMenuComponent;
        case 'HusScrollBar':
            return previewHusScrollBarComponent;
        case 'HusPagination':
            return previewHusPaginationComponent;
        case 'HusContextMenu':
            return previewHusContextMenuComponent;
        case 'HusBreadcrumb':
            return previewHusBreadcrumbComponent;
        case 'HusSwitch':
            return previewHusSwitchComponent;
        case 'HusSlider':
            return previewHusSliderComponent;
        case 'HusSelect':
            return previewHusSelectComponent;
        case 'HusInput':
            return previewHusInputComponent;
        case 'HusOTPInput':
            return previewHusOTPInputComponent;
        case 'HusRate':
            return previewHusRateComponent;
        case 'HusRadio':
            return previewHusRadioComponent;
        case 'HusRadioBlock':
            return previewHusRadioBlockComponent;
        case 'HusCheckBox':
            return previewHusCheckBoxComponent;
        case 'HusAutoComplete':
            return previewHusAutoCompleteComponent;
        case 'HusMultiSelect':
            return previewHusMultiSelectComponent;
        case 'HusDateTimePicker':
            return previewHusDateTimePickerComponent;
        case 'HusTextArea':
            return previewHusTextAreaComponent;
        case 'HusInputInteger':
            return previewHusInputIntegerComponent;
        case 'HusInputNumber':
            return previewHusInputNumberComponent;
        case 'HusColorPickerPanel':
            return previewHusColorPickerPanelComponent;
        case 'HusColorPicker':
            return previewHusColorPickerComponent;
        case 'HusDateTimePickerPanel':
            return previewHusDateTimePickerPanelComponent;
        case 'HusTransfer':
            return previewHusTransferComponent;
        case 'HusMultiCheckBox':
            return previewHusMultiCheckBoxComponent;
        case 'HusToolTip':
            return previewHusToolTipComponent;
        case 'HusTourFocus':
            return previewHusTourFocusComponent;
        case 'HusTourStep':
            return previewHusTourStepComponent;
        case 'HusTabView':
            return previewHusTabViewComponent;
        case 'HusCollapse':
            return previewHusCollapseComponent;
        case 'HusAvatar':
            return previewHusAvatarComponent;
        case 'HusCard':
            return previewHusCardComponent;
        case 'HusTimeline':
            return previewHusTimelineComponent;
        case 'HusTag':
            return previewHusTagComponent;
        case 'HusTableView':
            return previewHusTableViewComponent;
        case 'HusBadge':
            return previewHusBadgeComponent;
        case 'HusCarousel':
            return previewHusCarouselComponent;
        case 'HusImage':
            return previewHusImageComponent;
        case 'HusImagePreview':
            return previewHusImagePreviewComponent;
        case 'HusEmpty':
            return previewHusEmptyComponent;
        case 'HusQrCode':
            return previewHusQrCodeComponent;
        case 'HusAnimatedImage':
            return previewHusAnimatedImageComponent;
        case 'HusCheckerBoard':
            return previewHusCheckerBoardComponent;
        case 'HusTreeView':
            return previewHusTreeViewComponent;
        case 'HusSegmented':
            return previewHusSegmentedComponent;
        case 'HusAcrylic':
            return previewHusAcrylicComponent;
        case 'HusLiquidGlass':
            return previewHusLiquidGlassComponent;
        case 'HusSwitchEffect':
            return previewHusSwitchEffectComponent;
        case 'HusShadow':
            return previewHusShadowComponent;
        case 'HusAsyncHasher':
            return previewHusAsyncHasherComponent;
        case 'HusRouter':
            return previewHusRouterComponent;
        case 'HusWatermark':
            return previewHusWatermarkComponent;
        case 'HusDrawer':
            return previewHusDrawerComponent;
        case 'HusMessage':
            return previewHusMessageComponent;
        case 'HusProgress':
            return previewHusProgressComponent;
        case 'HusNotification':
            return previewHusNotificationComponent;
        case 'HusPopconfirm':
            return previewHusPopconfirmComponent;
        case 'HusPopover':
            return previewHusPopoverComponent;
        case 'HusModal':
            return previewHusModalComponent;
        case 'HusSpin':
            return previewHusSpinComponent;
        case 'HusTheme':
            return previewHusThemeComponent;
        case 'HusApi':
            return previewHusApiComponent;
        default:
            return previewFallbackComponent;
        }
    }

    Component {
        id: previewFallbackComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

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

    Component {
        id: previewHusWindowComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.fill: parent
                spacing: 12

                Row {
                    spacing: 8

                    HusButton {
                        text: previewLoader.visible ? '隐藏窗口' : '显示窗口'
                        type: HusButton.Type_Primary
                        onClicked: previewLoader.visible = !previewLoader.visible
                    }

                    HusButton {
                        text: '暗色'
                        type: HusButton.Type_Outlined
                        onClicked: {
                            if (previewLoader.item)
                                previewLoader.item.setWindowMode(true);
                        }
                    }
                }

                HusText {
                    width: parent.width
                    wrapMode: Text.Wrap
                    color: HusTheme.Primary.colorTextSecondary
                    text: '使用官方推荐方式通过 Loader 动态创建 HusWindow，并提供独立窗口开关。'
                }
            }

            Loader {
                id: previewLoader
                visible: false
                sourceComponent: HusWindow {
                    width: 500
                    height: 320
                    visible: previewLoader.visible
                    title: 'HusWindow Preview'
                    captionBar.winIconWidth: 0
                    captionBar.winIconHeight: 0
                    captionBar.winIconDelegate: Item {}
                    captionBar.closeCallback: () => previewLoader.visible = false

                    Item {
                        anchors.fill: parent

                        HusCard {
                            anchors.centerIn: parent
                            width: 260
                            title: 'Window Content'
                            bodyTitle: 'Detached Preview'
                            bodyDescription: 'This preview runs in a real HusWindow.'
                        }
                    }
                }
            }
        }
    }

    Component {
        id: previewHusButtonComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 10

                HusButton {
                    text: 'primary'
                    type: HusButton.Type_Primary
                }

                HusButton {
                    text: 'link'
                    type: HusButton.Type_Link
                }
            }
        }
    }

    Component {
        id: previewHusIconButtonComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusIconButton {
                anchors.centerIn: parent
                type: HusButton.Type_Outlined
                iconSource: HusIcon.SearchOutlined
                text: 'Search'
            }
        }
    }

    Component {
        id: previewHusCaptionButtonComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 10

                HusCaptionButton {
                    iconSource: HusIcon.LineOutlined
                }

                HusCaptionButton {
                    iconSource: HusIcon.SwitcherTwotonePath3
                }

                HusCaptionButton {
                    isError: true
                    iconSource: HusIcon.CloseOutlined
                }
            }
        }
    }

    Component {
        id: previewHusIconTextComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusIconText {
                anchors.centerIn: parent
                iconSource: HusIcon.InfoCircleOutlined
                text: 'Overview item'
                iconSize: 18
            }
        }
    }

    Component {
        id: previewHusCopyableTextComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusCopyableText {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                wrapMode: Text.Wrap
                text: 'Click and copy HuskarUI gallery.'
            }
        }
    }

    Component {
        id: previewHusRectangleComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusRectangle {
                anchors.centerIn: parent
                width: 150
                height: 86
                radius: 18
                topRightRadius: 4
                bottomLeftRadius: 30
                color: HusTheme.Primary.colorInfoBg
                border.color: HusTheme.Primary.colorInfo
            }
        }
    }

    Component {
        id: previewHusPopupComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusButton {
                anchors.centerIn: parent
                text: 'Open Popup'
                type: HusButton.Type_Primary
                onClicked: popup.open()

                HusPopup {
                    id: popup
                    x: (parent.width - width) * 0.5
                    y: parent.height + 8
                    width: 220
                    height: 110

                    HusFrame {
                        anchors.fill: parent
                        colorBg: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'HusPopup Content'
                        }
                    }
                }
            }
        }
    }

    Component {
        id: previewHusTextComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 6

                HusText {
                    text: '统一字体文本'
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading5
                }

                HusText {
                    text: 'Secondary description'
                    color: HusTheme.Primary.colorTextSecondary
                }
            }
        }
    }

    Component {
        id: previewHusButtonBlockComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusButtonBlock {
                    model: [
                        {
                            label: 'Apple'
                        },
                        {
                            label: 'Pear'
                        },
                        {
                            label: 'Orange'
                        }
                    ]
                }

                HusButtonBlock {
                    model: [
                        {
                            iconSource: HusIcon.PlusOutlined
                        },
                        {
                            iconSource: HusIcon.MinusOutlined
                        },
                        {
                            iconSource: HusIcon.CloseOutlined
                        }
                    ]
                }
            }
        }
    }

    Component {
        id: previewHusMoveMouseAreaComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 24
                height: parent.height - 24
                color: 'transparent'
                border.color: HusTheme.Primary.colorBorder
                clip: true

                Rectangle {
                    width: 70
                    height: 70
                    x: 16
                    y: 16
                    radius: 12
                    color: HusTheme.Primary.colorPrimary

                    HusMoveMouseArea {
                        anchors.fill: parent
                        target: parent
                        preventStealing: true
                    }
                }
            }
        }
    }

    Component {
        id: previewHusResizeMouseAreaComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 24
                height: parent.height - 24
                color: 'transparent'
                border.color: HusTheme.Primary.colorBorder
                clip: true

                Rectangle {
                    width: 86
                    height: 70
                    x: 16
                    y: 16
                    radius: 12
                    color: HusTheme.Primary.colorSuccess

                    HusResizeMouseArea {
                        anchors.fill: parent
                        target: parent
                        movable: true
                        preventStealing: true
                        minimumWidth: 60
                        minimumHeight: 50
                    }
                }
            }
        }
    }

    Component {
        id: previewHusCaptionBarComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusCaptionBar {
                width: parent.width
                height: 42
                anchors.top: parent.top
                winTitle: 'Overview'
                winIcon: control.galleryImage('huskarui_new_square.svg')
                showReturnButton: true
                showThemeButton: true
                showTopButton: true
                showMinimizeButton: false
                showMaximizeButton: false
                showCloseButton: false
            }

            HusText {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                color: HusTheme.Primary.colorTextSecondary
                text: 'HusWindow 默认会内置 HusCaptionBar'
            }
        }
    }

    Component {
        id: previewHusRadiusComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 12

                HusButton {
                    text: 'Capsule Radius'
                    type: HusButton.Type_Primary
                    radiusBg: HusRadius {
                        all: height * 0.5
                    }
                }

                HusRectangle {
                    visible: false
                }

                HusButton {
                    text: 'Mixed Radius'
                    type: HusButton.Type_Outlined
                    radiusBg: HusRadius {
                        topLeft: 24
                        topRight: 6
                        bottomLeft: 6
                        bottomRight: 24
                    }
                }
            }
        }
    }

    Component {
        id: previewHusLabelComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 10

                HusLabel {
                    text: 'Status'
                }

                HusLabel {
                    text: 'NEW'
                    colorBg: HusTheme.Primary.colorInfoBg
                    colorText: HusTheme.Primary.colorInfo
                }
            }
        }
    }

    Component {
        id: previewHusFrameComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusFrame {
                anchors.centerIn: parent
                width: Math.min(parent.width - 16, 230)
                height: 90
                padding: 12
                colorBg: HusTheme.Primary.colorBgBase

                Column {
                    anchors.fill: parent
                    spacing: 8

                    HusText {
                        text: 'Nested HusFrame'
                    }

                    HusDivider {
                        width: parent.width
                    }

                    HusCheckBox {
                        text: 'Enable card'
                    }
                }
            }
        }
    }

    Component {
        id: previewHusPageComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusPage {
                anchors.fill: parent
                header: HusText {
                    width: parent.width
                    padding: 8
                    horizontalAlignment: Text.AlignHCenter
                    text: 'Page Header'
                }
                contentItem: Item {
                    HusDivider {
                        width: parent.width
                    }

                    HusText {
                        anchors.centerIn: parent
                        text: 'Page Content'
                    }
                }
                footer: HusText {
                    width: parent.width
                    padding: 8
                    horizontalAlignment: Text.AlignHCenter
                    text: 'Page Footer'
                }
            }
        }
    }

    Component {
        id: previewHusDividerComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                spacing: 12

                HusText {
                    text: 'Before'
                }

                HusDivider {
                    width: parent.width
                }

                HusText {
                    text: 'After'
                }
            }
        }
    }

    Component {
        id: previewHusSpaceComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusSpace {
                anchors.centerIn: parent
                layout: 'RowLayout'
                spacing: 10

                HusButton {
                    text: 'Alpha'
                }

                HusButton {
                    text: 'Beta'
                    type: HusButton.Type_Primary
                }

                HusButton {
                    text: 'Gamma'
                    type: HusButton.Type_Outlined
                }
            }
        }
    }

    Component {
        id: previewHusGroupBoxComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusGroupBox {
                anchors.centerIn: parent
                width: Math.min(parent.width - 16, 240)
                title: 'Deploy Options'

                Column {
                    anchors.fill: parent
                    spacing: 8

                    HusCheckBox {
                        text: 'Build Release'
                    }
                    HusCheckBox {
                        text: 'Upload Symbols'
                    }
                }
            }
        }
    }

    Component {
        id: previewHusMenuComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusMenu {
                anchors.fill: parent
                defaultMenuWidth: parent.width
                initModel: [
                    {
                        label: 'Home',
                        iconSource: HusIcon.HomeOutlined
                    },
                    {
                        label: 'Workspace',
                        iconSource: HusIcon.AppstoreOutlined,
                        menuChildren: [
                            {
                                label: 'Boards',
                                iconSource: HusIcon.BarsOutlined
                            },
                            {
                                label: 'Tasks',
                                iconSource: HusIcon.UnorderedListOutlined
                            }
                        ]
                    },
                    {
                        label: 'Settings',
                        iconSource: HusIcon.SettingOutlined
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusScrollBarComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Flickable {
                anchors.fill: parent
                contentWidth: width
                contentHeight: 520
                clip: true
                ScrollBar.vertical: HusScrollBar {}

                Column {
                    width: parent.width - 12
                    spacing: 8

                    Repeater {
                        model: 16

                        HusFrame {
                            width: parent.width
                            height: 30

                            HusText {
                                anchors.centerIn: parent
                                text: 'Item ' + (index + 1)
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: previewHusPaginationComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusPagination {
                anchors.centerIn: parent
                currentPageIndex: 3
                total: 240
                pageSizeModel: [
                    {
                        label: '10 / page',
                        value: 10
                    },
                    {
                        label: '20 / page',
                        value: 20
                    },
                    {
                        label: '30 / page',
                        value: 30
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusContextMenuComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: function (mouse) {
                    if (mouse.button === Qt.RightButton) {
                        contextMenu.x = mouse.x;
                        contextMenu.y = mouse.y;
                        contextMenu.open();
                    }
                }

                HusCopyableText {
                    anchors.fill: parent
                    text: '在此区域右键打开 HusContextMenu'
                }

                HusContextMenu {
                    id: contextMenu
                    initModel: [
                        {
                            key: 'new',
                            label: 'New',
                            iconSource: HusIcon.FileOutlined
                        },
                        {
                            key: 'open',
                            label: 'Open',
                            iconSource: HusIcon.FormOutlined
                        },
                        {
                            type: 'divider'
                        },
                        {
                            key: 'exit',
                            label: 'Exit',
                            iconSource: HusIcon.CloseOutlined
                        }
                    ]
                }
            }
        }
    }

    Component {
        id: previewHusBreadcrumbComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusBreadcrumb {
                anchors.centerIn: parent
                initModel: [
                    {
                        label: 'Home'
                    },
                    {
                        label: 'Gallery'
                    },
                    {
                        label: 'Overview'
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusSwitchComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 12

                HusSwitch {
                    checkedText: 'ON'
                    uncheckedText: 'OFF'
                }

                HusSwitch {
                    checkedIconSource: HusIcon.CheckOutlined
                    uncheckedIconSource: HusIcon.CloseOutlined
                }
            }
        }
    }

    Component {
        id: previewHusSliderComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width - 24, 220)
                spacing: 8

                HusSlider {
                    id: slider
                    width: parent.width
                    min: 0
                    max: 100
                    value: 64
                    handleToolTipDelegate: HusToolTip {
                        visible: handleHovered || handlePressed
                        text: slider.currentValue.toFixed(0)
                    }
                }

                HusText {
                    text: 'Value: ' + slider.currentValue.toFixed(0)
                }
            }
        }
    }

    Component {
        id: previewHusSelectComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusSelect {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                placeholderText: 'Choose city'
                model: [
                    {
                        label: 'Hangzhou',
                        value: 'hz'
                    },
                    {
                        label: 'Shanghai',
                        value: 'sh'
                    },
                    {
                        label: 'Shenzhen',
                        value: 'sz'
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusInputComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusInput {
                    width: Math.min(parent.width - 20, 220)
                    iconSource: HusIcon.UserOutlined
                    placeholderText: 'Username'
                }

                HusInput {
                    width: Math.min(parent.width - 20, 220)
                    clearEnabled: 'active'
                    placeholderText: 'Search'
                }
            }
        }
    }

    Component {
        id: previewHusOTPInputComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusOTPInput {
                anchors.centerIn: parent
                length: 6
            }
        }
    }

    Component {
        id: previewHusRateComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusRate {
                anchors.centerIn: parent
                count: 5
                value: 3
            }
        }
    }

    Component {
        id: previewHusRadioComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 8

                HusRadio {
                    text: 'Option A'
                    checked: true
                }

                HusRadio {
                    text: 'Option B'
                }
            }
        }
    }

    Component {
        id: previewHusRadioBlockComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusRadioBlock {
                anchors.centerIn: parent
                initCheckedIndex: 1
                model: [
                    {
                        label: 'Daily',
                        value: 'day'
                    },
                    {
                        label: 'Weekly',
                        value: 'week'
                    },
                    {
                        label: 'Monthly',
                        value: 'month'
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusCheckBoxComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 8

                HusCheckBox {
                    text: 'Mail'
                    checked: true
                }

                HusCheckBox {
                    text: 'Calendar'
                }
            }
        }
    }

    Component {
        id: previewHusAutoCompleteComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusAutoComplete {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                placeholderText: 'Search'
                iconSource: HusIcon.SearchOutlined
                options: [
                    {
                        label: 'HusButton'
                    },
                    {
                        label: 'HusTableView'
                    },
                    {
                        label: 'HusMenu'
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusMultiSelectComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusMultiSelect {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 240)
                options: [
                    {
                        key: 'ui',
                        label: 'UI'
                    },
                    {
                        key: 'qml',
                        label: 'QML'
                    },
                    {
                        key: 'cpp',
                        label: 'C++'
                    }
                ]
                defaultSelectedKeys: ['ui', 'qml']
            }
        }
    }

    Component {
        id: previewHusDateTimePickerComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusDateTimePicker {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
            }
        }
    }

    Component {
        id: previewHusTextAreaComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusTextArea {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 240)
                height: 90
                placeholderText: 'Write your note...'
                text: 'HuskarUI overview sample'
            }
        }
    }

    Component {
        id: previewHusInputIntegerComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusInputInteger {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                value: 42
                min: 0
                max: 100
            }
        }
    }

    Component {
        id: previewHusInputNumberComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusInputNumber {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                value: 3.14
                precision: 2
                step: 0.25
            }
        }
    }

    Component {
        id: previewHusColorPickerPanelComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusColorPickerPanel {
                anchors.centerIn: parent
            }
        }
    }

    Component {
        id: previewHusColorPickerComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 12

                HusColorPicker {
                    id: picker
                    autoChange: false
                    changeValue: HusTheme.Primary.colorPrimary
                    onChange: function (color) {
                        changeValue = color;
                    }
                }

                HusRectangle {
                    width: 56
                    height: 56
                    radius: 14
                    color: picker.value
                }
            }
        }
    }

    Component {

        id: previewHusDateTimePickerPanelComponent
        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusDateTimePickerPanel {
                anchors.centerIn: parent
            }
        }
    }

    Component {
        id: previewHusTransferComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusTransfer {
                anchors.fill: parent
                titles: ['Source', 'Target']
                showSearch: true
                dataSource: [
                    {
                        key: '1',
                        title: 'Content 1'
                    },
                    {
                        key: '2',
                        title: 'Content 2'
                    },
                    {
                        key: '3',
                        title: 'Content 3'
                    },
                    {
                        key: '4',
                        title: 'Content 4'
                    },
                    {
                        key: '5',
                        title: 'Content 5'
                    }
                ]
                targetKeys: ['2', '4']
            }
        }
    }

    Component {
        id: previewHusMultiCheckBoxComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusMultiCheckBox {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 240)
                options: [
                    {
                        key: 'apple',
                        label: 'Apple'
                    },
                    {
                        key: 'pear',
                        label: 'Pear'
                    },
                    {
                        key: 'orange',
                        label: 'Orange'
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusToolTipComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusButton {
                anchors.centerIn: parent
                text: 'Hover me'
                type: HusButton.Type_Outlined

                HusToolTip {
                    visible: parent.hovered
                    position: HusToolTip.Position_Bottom
                    text: 'Tooltip Preview'
                }
            }
        }
    }

    Component {
        id: previewHusTourFocusComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusButton {
                    text: 'Open Focus'
                    type: HusButton.Type_Primary
                    onClicked: focusPopup.open()
                }

                Row {
                    spacing: 8

                    HusButton {
                        id: focusTarget
                        text: 'Target'
                        type: HusButton.Type_Outlined
                    }

                    HusButton {
                        text: 'Close'
                        type: HusButton.Type_Outlined
                        onClicked: focusPopup.close()
                    }
                }

                HusSlider {
                    id: focusMarginSlider
                    width: 180
                    min: 0
                    max: 16
                    value: 6
                }
            }

            HusTourFocus {
                id: focusPopup
                target: focusTarget
                penetrationEvent: true
                focusMargin: focusMarginSlider.currentValue
                focusRadius: 8
                closePolicy: Popup.CloseOnEscape
            }
        }
    }

    Component {
        id: previewHusTourStepComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusButton {
                    text: 'Start Tour'
                    type: HusButton.Type_Primary
                    onClicked: {
                        tour.resetStep();
                        tour.open();
                    }

                    HusTourStep {
                        id: tour
                        stepModel: [
                            {
                                target: stepOne,
                                title: 'Step 1',
                                description: 'Choose a source'
                            },
                            {
                                target: stepTwo,
                                title: 'Step 2',
                                description: 'Confirm the action'
                            }
                        ]
                    }
                }

                Row {
                    spacing: 10

                    HusButton {
                        id: stepOne
                        text: 'Source'
                        type: HusButton.Type_Outlined
                    }

                    HusButton {
                        id: stepTwo
                        text: 'Confirm'
                        type: HusButton.Type_Outlined
                    }
                }
            }
        }
    }

    Component {
        id: previewHusTabViewComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Component {
                id: tabOneDelegate

                HusText {
                    anchors.centerIn: parent
                    text: 'Tab Content 1'
                }
            }

            Component {
                id: tabTwoDelegate

                HusText {
                    anchors.centerIn: parent
                    text: 'Tab Content 2'
                }
            }

            Component {
                id: tabThreeDelegate

                HusText {
                    anchors.centerIn: parent
                    text: 'Tab Content 3'
                }
            }

            HusTabView {
                anchors.fill: parent
                initModel: [
                    {
                        title: 'Tab 1',
                        contentDelegate: tabOneDelegate
                    },
                    {
                        title: 'Tab 2',
                        contentDelegate: tabTwoDelegate
                    },
                    {
                        title: 'Tab 3',
                        contentDelegate: tabThreeDelegate
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusCollapseComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Component {
                id: collapseAlphaDelegate

                HusText {
                    text: 'Alpha'
                    padding: 10
                }
            }

            Component {
                id: collapseBetaDelegate

                HusText {
                    text: 'Beta'
                    padding: 10
                }
            }

            HusCollapse {
                anchors.fill: parent
                initModel: [
                    {
                        title: 'Panel A',
                        contentDelegate: collapseAlphaDelegate
                    },
                    {
                        title: 'Panel B',
                        contentDelegate: collapseBetaDelegate
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusAvatarComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 12

                HusAvatar {
                    size: 44
                    textSource: 'HU'
                }

                HusAvatar {
                    size: 44
                    iconSource: HusIcon.UserOutlined
                }
            }
        }
    }

    Component {
        id: previewHusCardComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusCard {
                anchors.centerIn: parent
                width: Math.min(parent.width - 12, 240)
                title: 'Card title'
                showShadow: true
                extraDelegate: HusButton {
                    text: 'More'
                    type: HusButton.Type_Link
                }
                bodyDescription: 'Card content\\nCard content\\nCard content'
            }
        }
    }

    Component {
        id: previewHusTimelineComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusTimeline {
                anchors.fill: parent
                initModel: [
                    {
                        title: 'Draft',
                        desc: 'Create overview sketch'
                    },
                    {
                        title: 'Build',
                        desc: 'Add live previews'
                    },
                    {
                        title: 'Preview',
                        desc: 'Verify result'
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusTagComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Flow {
                anchors.centerIn: parent
                width: Math.min(parent.width, 220)
                spacing: 8

                HusTag {
                    text: 'default'
                }

                HusTag {
                    text: 'success'
                    tagState: HusTag.State_Success
                }

                HusTag {
                    text: 'closable'
                    closeIconSource: HusIcon.CloseOutlined
                }
            }
        }
    }

    Component {
        id: previewHusTableViewComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Component {
                id: tableTextDelegate

                HusText {
                    leftPadding: 8
                    rightPadding: 8
                    text: cellData
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Component {
                id: actionDelegate

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    HusButton {
                        text: 'Edit'
                        type: HusButton.Type_Link
                    }

                    HusButton {
                        text: 'Delete'
                        type: HusButton.Type_Link
                    }
                }
            }

            HusTableView {
                anchors.fill: parent
                alternatingRow: true
                showColumnGrid: true
                initModel: [
                    {
                        key: '1',
                        name: 'John Brown',
                        age: '32',
                        role: 'Developer'
                    },
                    {
                        key: '2',
                        name: 'Jim Green',
                        age: '42',
                        role: 'Designer'
                    },
                    {
                        key: '3',
                        name: 'Joe Black',
                        age: '29',
                        role: 'Teacher'
                    }
                ]
                columns: [
                    {
                        title: 'Name',
                        dataIndex: 'name',
                        delegate: tableTextDelegate,
                        width: 120
                    },
                    {
                        title: 'Age',
                        dataIndex: 'age',
                        delegate: tableTextDelegate,
                        width: 70,
                        align: 'center'
                    },
                    {
                        title: 'Role',
                        dataIndex: 'role',
                        delegate: tableTextDelegate,
                        width: 110
                    },
                    {
                        title: 'Action',
                        dataIndex: 'action',
                        delegate: actionDelegate,
                        width: 120
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusBadgeComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 18

                HusAvatar {
                    size: 42
                    iconSource: HusIcon.UserOutlined

                    HusBadge {
                        count: 8
                    }
                }

                HusIconText {
                    iconSource: HusIcon.NotificationOutlined
                    iconSize: 22

                    HusBadge {
                        dot: true
                    }
                }
            }
        }
    }

    Component {
        id: previewHusCarouselComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusCarousel {
                anchors.fill: parent
                autoplay: true
                autoplaySpeed: 2400
                initModel: [
                    {
                        coverSource: control.galleryImage('switch_effect1.jpg')
                    },
                    {
                        coverSource: control.galleryImage('switch_effect2.jpg')
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusImageComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusImage {
                anchors.centerIn: parent
                width: Math.min(parent.width - 16, 220)
                height: Math.min(parent.height - 16, 130)
                source: control.galleryImage('switch_effect1.jpg')
            }
        }
    }

    Component {
        id: previewHusImagePreviewComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 10

                HusImage {
                    width: 110
                    height: 76
                    previewEnabled: false
                    source: control.galleryImage('switch_effect1.jpg')

                    TapHandler {
                        onTapped: {
                            imagePreview.currentIndex = 0;
                            imagePreview.open();
                        }
                    }
                }

                HusImage {
                    width: 110
                    height: 76
                    previewEnabled: false
                    source: control.galleryImage('switch_effect2.jpg')

                    TapHandler {
                        onTapped: {
                            imagePreview.currentIndex = 1;
                            imagePreview.open();
                        }
                    }
                }
            }

            HusImagePreview {
                id: imagePreview
                items: [
                    {
                        url: control.galleryImage('switch_effect1.jpg')
                    },
                    {
                        url: control.galleryImage('switch_effect2.jpg')
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusEmptyComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusEmpty {
                anchors.centerIn: parent
                description: 'No component data'
            }
        }
    }

    Component {
        id: previewHusQrCodeComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusQrCode {
                anchors.centerIn: parent
                width: 110
                height: 110
                text: 'https://github.com/mengps/HuskarUI'
            }
        }
    }

    Component {
        id: previewHusAnimatedImageComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusAnimatedImage {
                anchors.centerIn: parent
                width: 150
                height: 110
                source: 'https://media.giphy.com/media/ICOgUNjpvO0PC/giphy.gif'
            }
        }
    }

    Component {
        id: previewHusCheckerBoardComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusCheckerBoard {
                anchors.centerIn: parent
                width: 180
                height: 120
            }
        }
    }

    Component {
        id: previewHusTreeViewComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusTreeView {
                anchors.fill: parent
                checkable: true
                Component.onCompleted: expandForKeys(['0'])
                initModel: [
                    {
                        title: 'Project',
                        key: '0',
                        children: [
                            {
                                title: 'gallery',
                                key: '0-0'
                            },
                            {
                                title: 'src',
                                key: '0-1'
                            },
                            {
                                title: 'docs',
                                key: '0-2'
                            }
                        ]
                    }
                ]
            }
        }
    }

    Component {
        id: previewHusSegmentedComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusSegmented {
                    options: ['Daily', 'Weekly', 'Monthly']
                }

                HusSegmented {
                    options: [
                        {
                            label: 'List',
                            iconSource: HusIcon.BarsOutlined
                        },
                        {
                            label: 'Kanban',
                            iconSource: HusIcon.AppstoreOutlined
                        }
                    ]
                }
            }
        }
    }

    Component {
        id: previewHusAcrylicComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0.2, 0.45, 0.95, 0.08)

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: control.galleryImage('switch_effect1.jpg')
                }

                HusAcrylic {
                    anchors.centerIn: parent
                    width: 180
                    height: 100

                    HusText {
                        anchors.centerIn: parent
                        text: 'Acrylic'
                    }
                }
            }
        }
    }

    Component {
        id: previewHusLiquidGlassComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Rectangle {
                anchors.fill: parent
                color: HusTheme.Primary.colorInfoBg

                HusLiquidGlass {
                    anchors.centerIn: parent
                    width: 190
                    height: 96

                    HusText {
                        anchors.centerIn: parent
                        text: 'Liquid Glass'
                    }

                    HusResizeMouseArea {
                        anchors.fill: parent
                        target: parent
                        movable: true
                        preventStealing: true
                        minimumWidth: 140
                        minimumHeight: 70
                    }
                }
            }
        }
    }

    Component {
        id: previewHusSwitchEffectComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.fill: parent
                spacing: 10

                HusButton {
                    id: switchButton
                    text: 'Switch'
                    type: HusButton.Type_Primary
                    onClicked: {
                        showingFirst = !showingFirst;
                        if (showingFirst) {
                            switchEffect.startSwitch(card2, card1);
                        } else {
                            switchEffect.startSwitch(card1, card2);
                        }
                    }
                    property bool showingFirst: true
                }

                Item {
                    width: parent.width
                    height: parent.height - switchButton.height - 10

                    Image {
                        id: card1
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: control.galleryImage('switch_effect1.jpg')
                        visible: true
                    }

                    Image {
                        id: card2
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: control.galleryImage('switch_effect2.jpg')
                        visible: false
                    }

                    HusSwitchEffect {
                        id: switchEffect
                        anchors.fill: parent
                        type: HusSwitchEffect.Type_Opacity
                        duration: 900
                        onFinished: {
                            card1.visible = switchButton.showingFirst;
                            card2.visible = !switchButton.showingFirst;
                        }
                    }
                }
            }
        }
    }

    Component {
        id: previewHusShadowComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Item {
                anchors.fill: parent

                Rectangle {
                    id: shadowSource
                    width: 140
                    height: 80
                    radius: 18
                    anchors.centerIn: parent
                    color: HusTheme.Primary.colorPrimary
                }

                HusShadow {
                    anchors.fill: shadowSource
                    source: shadowSource
                }
            }
        }
    }

    Component {
        id: previewHusAsyncHasherComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 260)
                spacing: 10

                HusInput {
                    id: hashInput
                    width: parent.width
                    text: 'HuskarUI'
                }

                HusButton {
                    text: 'Create Hash'
                    type: HusButton.Type_Primary
                    onClicked: hasher.sourceText = hashInput.text
                }

                HusCopyableText {
                    width: parent.width
                    wrapMode: Text.WrapAnywhere
                    text: hasher.hashValue || '等待生成摘要'
                }
            }

            HusAsyncHasher {
                id: hasher
                sourceText: 'HuskarUI'
            }
        }
    }

    Component {
        id: previewHusRouterComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            QtObject {
                id: routeState
                property string currentText: '/'
            }

            Column {
                anchors.centerIn: parent
                spacing: 10

                Row {
                    spacing: 8

                    HusButton {
                        text: '/overview'
                        type: HusButton.Type_Outlined
                        onClicked: router.push('/overview');
                    }

                    HusButton {
                        text: '/gallery'
                        type: HusButton.Type_Primary
                        onClicked: router.push('/gallery');
                    }
                }

                HusCopyableText {
                    text: routeState.currentText
                }
            }

            HusRouter {
                id: router
                onCurrentUrlChanged: routeState.currentText = 'Current URL: ' + currentUrl
            }
        }
    }

    Component {
        id: previewHusWatermarkComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.fill: parent
                spacing: 10

                HusSlider {
                    id: angleSlider
                    width: Math.min(parent.width - 20, 220)
                    min: 0
                    max: 360
                    value: 20
                }

                Rectangle {
                    width: parent.width
                    height: parent.height - angleSlider.height - 10
                    color: 'transparent'
                    border.color: HusTheme.Primary.colorBorder

                    HusWatermark {
                        anchors.fill: parent
                        anchors.margins: 1
                        text: 'HUSKARUI'
                        rotate: angleSlider.currentValue
                        offset.x: -40
                        offset.y: -40
                        colorText: '#55ff4d4f'
                        font.family: HusTheme.Primary.fontPrimaryFamily
                    }

                    HusText {
                        anchors.centerIn: parent
                        text: 'Watermark Preview'
                    }
                }
            }
        }
    }

    Component {
        id: previewHusDrawerComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 260)
                spacing: 10

                HusButton {
                    text: 'Open Drawer'
                    type: HusButton.Type_Primary
                    onClicked: drawer.open()

                    HusDrawer {
                        id: drawer
                        title: 'Basic Drawer'
                        edge: drawerEdgeRadio.currentCheckedValue ?? Qt.RightEdge
                        contentDelegate: HusCopyableText {
                            leftPadding: 15
                            text: 'Some contents...\nSome contents...\nSome contents...'
                        }
                    }
                }

                HusRadioBlock {
                    id: drawerEdgeRadio
                    initCheckedIndex: 3
                    model: [
                        {
                            label: 'Top',
                            value: Qt.TopEdge
                        },
                        {
                            label: 'Bottom',
                            value: Qt.BottomEdge
                        },
                        {
                            label: 'Left',
                            value: Qt.LeftEdge
                        },
                        {
                            label: 'Right',
                            value: Qt.RightEdge
                        }
                    ]
                }
            }
        }
    }

    Component {
        id: previewHusMessageComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusMessage {
                id: message
                width: parent.width
            }

            Row {
                anchors.centerIn: parent
                spacing: 10

                HusButton {
                    text: 'Success'
                    type: HusButton.Type_Primary
                    onClicked: message.success('Success message')
                }

                HusButton {
                    text: 'Warning'
                    type: HusButton.Type_Outlined
                    onClicked: message.warning('Warning message')
                }
            }
        }
    }

    Component {
        id: previewHusProgressComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width - 20, 220)
                spacing: 10

                HusProgress {
                    width: parent.width
                    percent: 68
                }

                HusProgress {
                    width: parent.width
                    type: HusProgress.Type_Circle
                    percent: 82
                }
            }
        }
    }

    Component {
        id: previewHusNotificationComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusNotification {
                id: notification
                anchors.fill: parent
                position: HusNotification.Position_TopRight
                showProgress: true
                stackMode: true
            }

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusText {
                    text: '统一点击触发'
                    color: HusTheme.Primary.colorTextSecondary
                }

                Row {
                    spacing: 10

                    HusButton {
                        text: 'Success'
                        type: HusButton.Type_Primary
                        onClicked: notification.success('Notification Title', 'This is a success notification!')
                    }

                    HusButton {
                        text: 'Info'
                        type: HusButton.Type_Outlined
                        onClicked: notification.info('Notification Title', 'This is an info notification!')
                    }

                    HusButton {
                        text: 'Warning'
                        type: HusButton.Type_Outlined
                        onClicked: notification.warning('Notification Title', 'This is a warning notification!')
                    }
                }
            }
        }
    }

    Component {
        id: previewHusPopconfirmComponent
        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160
            HusMessage {
                id: popMessage
                width: parent.width
            }

            Row {
                anchors.centerIn: parent
                spacing: 12

                HusButton {
                    text: 'Add'
                    type: HusButton.Type_Primary
                    onClicked: addConfirm.open()

                    HusPopconfirm {
                        id: addConfirm
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        width: 260
                        iconSource: HusIcon.QuestionCircleOutlined
                        title: 'Add the task'
                        description: 'Are you sure to add this task?'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirm: {
                            popMessage.success('Added');
                            close();
                        }
                        onCancel: {
                            popMessage.warning('Canceled');
                            close();
                        }
                    }
                }

                HusButton {
                    text: 'Delete'
                    type: HusButton.Type_Outlined
                    onClicked: deleteConfirm.open()

                    HusPopconfirm {
                        id: deleteConfirm
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        width: 260
                        title: 'Delete the task'
                        description: 'Are you sure to delete this task?'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirm: {
                            popMessage.error('Deleted');
                            close();
                        }
                        onCancel: {
                            popMessage.info('Kept');
                            close();
                        }
                    }
                }
            }
        }
    }

    Component {
        id: previewHusPopoverComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusText {
                    text: '统一点击触发'
                    color: HusTheme.Primary.colorTextSecondary
                }

                Row {
                    spacing: 12

                    HusButton {
                        text: 'Details'
                        type: HusButton.Type_Primary
                        onClicked: detailPopover.open()

                        HusPopover {
                            id: detailPopover
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 260
                            title: 'Click details'
                            description: 'This is a HusPopover preview.'
                        }
                    }

                    HusButton {
                        text: 'Help'
                        type: HusButton.Type_Outlined
                        onClicked: helpPopover.open()

                        HusPopover {
                            id: helpPopover
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 260
                            iconSource: HusIcon.InfoCircleOutlined
                            title: 'Help content'
                            description: 'Use the same click-trigger pattern across feedback components.'
                        }
                    }
                }
            }
        }
    }

    Component {
        id: previewHusModalComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            HusButton {
                anchors.centerIn: parent
                text: 'Open Modal'
                type: HusButton.Type_Primary
                onClicked: modal.open()

                HusModal {
                    id: modal
                    width: 320
                    title: 'Basic Modal'
                    description: 'Some contents...\\nSome contents...'
                    confirmText: 'Yes'
                    cancelText: 'No'
                    onConfirm: close()
                    onCancel: close()
                }
            }
        }
    }

    Component {
        id: previewHusSpinComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Row {
                anchors.centerIn: parent
                spacing: 18

                HusSpin {
                    sizeHint: 'small'
                }
                HusSpin {
                    sizeHint: 'normal'
                }
                HusSpin {
                    sizeHint: 'large'
                }
            }
        }
    }

    Component {
        id: previewHusThemeComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            Column {
                anchors.centerIn: parent
                spacing: 10

                HusButton {
                    text: 'Toggle Dark Mode'
                    type: HusButton.Type_Primary
                    onClicked: HusTheme.darkMode = HusTheme.isDark ? HusTheme.Light : HusTheme.Dark
                }

                HusButton {
                    text: 'Toggle Animation'
                    type: HusButton.Type_Outlined
                    onClicked: HusTheme.animationEnabled = !HusTheme.animationEnabled
                }

                HusCopyableText {
                    text: 'isDark=' + HusTheme.isDark + ', animation=' + HusTheme.animationEnabled
                }
            }
        }
    }

    Component {
        id: previewHusApiComponent

        Item {
            width: parent ? parent.width : 280
            height: parent ? parent.height : 160

            QtObject {
                id: apiState
                property string text: 'Click buttons to call HusApi'
            }

            Column {
                anchors.centerIn: parent
                spacing: 10

                Row {
                    spacing: 8

                    HusButton {
                        text: 'Clamp 148'
                        type: HusButton.Type_Primary
                        onClicked: apiState.text = 'clamp(148, 0, 100) = ' + HusApi.clamp(148, 0, 100)
                    }

                    HusButton {
                        text: 'Platform'
                        type: HusButton.Type_Outlined
                        onClicked: apiState.text = 'platform = ' + Qt.platform.os
                    }
                }

                HusCopyableText {
                    width: 240
                    wrapMode: Text.WrapAnywhere
                    text: apiState.text
                }
            }
        }
    }

    HoverHandler {
        cursorShape: Qt.ClosedHandCursor
    }

    Canvas {
        id: gridCanvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext('2d');
            ctx.clearRect(0, 0, width, height);
            ctx.fillStyle = HusTheme.isDark ? HusThemeFunctions.alpha('#121212', galleryBackground.opacity) :
                                              HusThemeFunctions.alpha('#f7f8fa', galleryBackground.opacity);
            ctx.fillRect(0, 0, width, height);

            const minorSpacing = Math.max(12, 24 * control.zoom);
            const majorSpacing = minorSpacing * 5;
            const minorOffsetX = ((-control.panX * control.zoom) % minorSpacing + minorSpacing) % minorSpacing;
            const minorOffsetY = ((-control.panY * control.zoom) % minorSpacing + minorSpacing) % minorSpacing;
            const majorOffsetX = ((-control.panX * control.zoom) % majorSpacing + majorSpacing) % majorSpacing;
            const majorOffsetY = ((-control.panY * control.zoom) % majorSpacing + majorSpacing) % majorSpacing;

            ctx.lineWidth = 1;
            ctx.strokeStyle = HusTheme.isDark ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.05)';

            for (let x1 = minorOffsetX; x1 < width; x1 += minorSpacing) {
                ctx.beginPath();
                ctx.moveTo(Math.round(x1) + 0.5, 0);
                ctx.lineTo(Math.round(x1) + 0.5, height);
                ctx.stroke();
            }

            for (let y1 = minorOffsetY; y1 < height; y1 += minorSpacing) {
                ctx.beginPath();
                ctx.moveTo(0, Math.round(y1) + 0.5);
                ctx.lineTo(width, Math.round(y1) + 0.5);
                ctx.stroke();
            }

            ctx.strokeStyle = HusTheme.isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)';

            for (let x2 = majorOffsetX; x2 < width; x2 += majorSpacing) {
                ctx.beginPath();
                ctx.moveTo(Math.round(x2) + 0.5, 0);
                ctx.lineTo(Math.round(x2) + 0.5, height);
                ctx.stroke();
            }

            for (let y2 = majorOffsetY; y2 < height; y2 += majorSpacing) {
                ctx.beginPath();
                ctx.moveTo(0, Math.round(y2) + 0.5);
                ctx.lineTo(width, Math.round(y2) + 0.5);
                ctx.stroke();
            }
        }

        Connections {
            target: HusTheme
            function onIsDarkChanged() {
                gridCanvas.requestPaint();
            }
        }

        Connections {
            target: galleryBackground
            function onOpacityChanged() {
                gridCanvas.requestPaint();
            }
        }
    }

    Item {
        id: canvasViewport
        anchors.fill: parent
        clip: true
        z: 1

        WheelHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            acceptedModifiers: Qt.ControlModifier

            onWheel: function (wheel) {
                const factor = wheel.angleDelta.y > 0 ? 1.1 : 1 / 1.1;
                control.setZoomAt(control.zoom * factor, wheel.x, wheel.y);
                wheel.accepted = true;
            }
        }

        DragHandler {
            id: canvasDragHandler
            target: null
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            grabPermissions: PointerHandler.CanTakeOverFromItems

            property real startPanX: 0
            property real startPanY: 0

            onActiveChanged: {
                if (active) {
                    startPanX = control.panX;
                    startPanY = control.panY;
                }
            }

            onTranslationChanged: {
                control.setPan(startPanX - translation.x / control.zoom, startPanY - translation.y / control.zoom);
            }
        }

        Item {
            id: sceneViewportItem
            x: -(control.panX + control.sceneContentLeft()) * control.zoom
            y: -control.panY * control.zoom
            width: sceneWidth
            height: sceneStack.height
            scale: control.zoom
            transformOrigin: Item.TopLeft

            Column {
                id: sceneStack
                width: control.sceneWidth
                spacing: 20

                HusFrame {
                    width: waterfallRow.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    padding: 18
                    colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.88)
                    colorBorder: HusTheme.Primary.colorBorderSecondary

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

                Column {
                    width: waterfallRow.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: control.waterfallSpacing

                    Repeater {
                        model: control.wideSections()
                        delegate: SectionCard {
                            required property var modelData
                            sectionData: modelData
                        }
                    }
                }

                Row {
                    id: waterfallRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: control.waterfallSpacing

                    Repeater {
                        model: control.waterfallColumnCount
                        delegate: Column {
                            required property int index
                            width: control.waterfallColumnWidth
                            spacing: control.waterfallSpacing

                            Repeater {
                                model: control.sectionsForColumn(index)
                                delegate: SectionCard {
                                    required property var modelData
                                    sectionData: modelData
                                }
                            }
                        }
                    }
                }
            }
        }

        HusScrollBar {
            id: verticalCanvasBar
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            orientation: Qt.Vertical
            size: control.verticalBarSize()
            position: control.verticalBarPosition()
            onPositionChanged: {
                if (pressed) {
                    control.setPan(control.panX, control.minPanY() + position * control.panRangeYFor(control.zoom));
                }
            }
        }

        HusScrollBar {
            id: horizontalCanvasBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: verticalCanvasBar.width
            orientation: Qt.Horizontal
            size: control.horizontalBarSize()
            position: control.horizontalBarPosition()
            onPositionChanged: {
                if (pressed) {
                    control.setPan(control.minPanX() + position * control.panRangeXFor(control.zoom), control.panY);
                }
            }
        }
    }

    HusFrame {
        z: 100
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16
        padding: 12
        colorBg: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.8)
        colorBorder: HusTheme.Primary.colorBorderSecondary

        RowLayout {

            HusCheckBox {
                text: qsTr('Enabled')
                checked: true
                onToggled: {
                    sceneViewportItem.enabled = checked;
                }
            }

            HusText {
                Layout.alignment: Qt.AlignVCenter
                text: qsTr(`${Math.round(control.zoom * 100)}%`)
            }

            HusIconButton {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                padding: 4
                iconSource: HusIcon.MinusOutlined
                onClicked: control.zoomBy(1 / 1.1);
            }

            HusSlider {
                id: zoomSlider
                Layout.preferredWidth: 180
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                min: control.minZoom * 100
                max: control.maxZoom * 100
                stepSize: 1
                value: control.zoom * 100
                onFirstMoved: control.setZoomTo(currentValue / 100);
                onFirstReleased: control.setZoomTo(currentValue / 100);
            }

            HusIconButton {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                padding: 4
                iconSource: HusIcon.PlusOutlined
                onClicked: control.zoomBy(1.1);
            }

            HusIconButton {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                padding: 4
                iconSource: HusIcon.BorderInnerOutlined
                onClicked: {
                    control.fitScene();
                    control.setZoomTo(1);
                }
            }

            HusIconButton {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                padding: 4
                iconSource: HusIcon.CompressOutlined
                onClicked: control.fitScene();
            }
        }
    }
}
