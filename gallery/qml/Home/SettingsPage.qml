import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Basic
import DelegateUI

Item {
    id: root

    component MySlider: RowLayout {
        width: 350
        height: 30
        anchors.margins: 30
        spacing: 20

        property alias label: __label
        property alias slider: __slider
        property bool scaleVisible: false

        DelText {
            id: __label
            Layout.preferredWidth: DelTheme.Primary.fontPrimarySize * 6
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Row {
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                visible: scaleVisible
                spacing: (parent.width - 14 - ((__repeater.count - 1) * 4)) / (__repeater.count - 1)

                Repeater {
                    id: __repeater
                    model: Math.round((__slider.max - __slider.min) / __slider.stepSize) + 1
                    delegate: Rectangle {
                        width: 4
                        height: 6
                        radius: 2
                        color: __slider.colorBg

                        DelText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            anchors.topMargin: 8
                            text: (__slider.stepSize) * index + __slider.min
                        }
                    }
                }
            }

            DelSlider {
                id: __slider
                anchors.fill: parent
                min: 0.0
                max: 1.0
                stepSize: 0.1
            }
        }
    }

    component SettingsItem: Item {
        id: settingsItem
        width: parent.width
        height: column.height

        property string title: value
        property Component itemDelegate: Item { }

        Column {
            id: column
            width: parent.width
            spacing: 10

            DelText {
                text: settingsItem.title
            }

            Rectangle {
                width: parent.width
                height: itemLoader.height + 40
                radius: 6
                color: DelThemeFunctions.alpha(DelTheme.Primary.colorBgBase, 0.6)
                border.color: DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.1)

                Loader {
                    id: itemLoader
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: settingsItem.itemDelegate
                }
            }
        }
    }

    Flickable {
        anchors.fill: parent
        topMargin: 20
        bottomMargin: 20
        clip: true
        contentHeight: contentColumn.height
        ScrollBar.vertical: DelScrollBar { }

        Column {
            id: contentColumn
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 20

            SettingsItem {
                title: qsTr('常规设置')
                itemDelegate: Column {
                    spacing: 10

                    MySlider {
                        id: themeSpeed
                        label.text: qsTr('控件动画基础速度')
                        slider.min: 20
                        slider.max: 200
                        slider.stepSize: 1
                        slider.onFirstReleased: {
                            const base = slider.currentValue;
                            DelTheme.installThemePrimaryAnimationBase(base, base * 2, base * 3);
                        }
                        slider.handleToolTipDelegate: DelToolTip {
                            arrowVisible: true
                            delay: 100
                            text: themeSpeed.slider.currentValue
                            visible: handlePressed || handleHovered
                        }
                        Component.onCompleted: {
                            slider.value = DelTheme.Primary.durationFast;
                        }
                    }

                    MySlider {
                        id: effectSpeed
                        label.text: qsTr('菜单切换速度')
                        slider.min: 0
                        slider.max: 2000
                        slider.stepSize: 1
                        slider.value: gallerySwitchEffect.duration
                        slider.onFirstReleased: {
                            gallerySwitchEffect.duration = slider.currentValue;
                        }
                        slider.handleToolTipDelegate: DelToolTip {
                            arrowVisible: true
                            delay: 100
                            text: effectSpeed.slider.currentValue
                            visible: handlePressed || handleHovered
                        }
                    }

                    MySlider {
                        id: bgOpacitySlider
                        label.text: qsTr('背景透明度')
                        slider.value: galleryBackground.opacity
                        slider.snapMode: DelSlider.SnapOnRelease
                        slider.onFirstMoved: {
                            galleryBackground.opacity = slider.currentValue;
                        }
                        slider.handleToolTipDelegate: DelToolTip {
                            arrowVisible: true
                            delay: 100
                            text: bgOpacitySlider.slider.currentValue.toFixed(1)
                            visible: handlePressed || handleHovered
                        }
                    }

                    MySlider {
                        label.text: qsTr('字体大小')
                        slider.min: 12
                        slider.max: 24
                        slider.stepSize: 4
                        slider.value: DelTheme.Primary.fontPrimarySizeHeading5
                        slider.snapMode: DelSlider.SnapAlways
                        slider.onFirstReleased: {
                            DelTheme.installThemePrimaryFontSizeBase(slider.currentValue);
                        }
                        scaleVisible: true
                    }
                }
            }

            SettingsItem {
                title: qsTr('菜单切换特效')
                itemDelegate: Column {
                    spacing: 10

                    ButtonGroup { id: effectTypeGroup }

                    Repeater {
                        model: [
                            { 'label': qsTr('无'), 'value': DelSwitchEffect.Type_None, 'duration': 0 },
                            { 'label': qsTr('透明度特效'), 'value': DelSwitchEffect.Type_Opacity, 'duration': 200 },
                            { 'label': qsTr('模糊特效'), 'value': DelSwitchEffect.Type_Blurry, 'duration': 350 },
                            {
                                'label': qsTr('遮罩特效'),
                                'value': DelSwitchEffect.Type_Mask,
                                'duration': 800,
                                'maskScaleEnabled': true,
                                'maskRotationEnabled': true,
                                'maskSource': 'qrc:/DelegateUI/images/star.png'
                            },
                            {
                                'label': qsTr('百叶窗特效'),
                                'value': DelSwitchEffect.Type_Blinds,
                                'duration': 800,
                                'maskSource': 'qrc:/DelegateUI/images/hblinds.png'
                            },
                            {
                                'label': qsTr('3D翻转特效'),
                                'value': DelSwitchEffect.Type_3DFlip,
                                'duration': 800,
                                'maskSource': 'qrc:/DelegateUI/images/smoke.png'
                            },                            {
                                'label': qsTr('雷电特效'),
                                'value': DelSwitchEffect.Type_Thunder,
                                'duration': 800,
                                'maskSource': 'qrc:/DelegateUI/images/stripes.png'
                            },
                        ]
                        delegate: DelRadio {
                            text: modelData.label
                            ButtonGroup.group: effectTypeGroup
                            onClicked: {
                                gallerySwitchEffect.type = modelData.value;
                                gallerySwitchEffect.duration = modelData.duration;
                                gallerySwitchEffect.maskScaleEnabled = modelData.maskScaleEnabled ?? false;
                                gallerySwitchEffect.maskRotationEnabled = modelData.maskRotationEnabled ?? false;
                                gallerySwitchEffect.maskSource = modelData.maskSource ?? '';
                            }
                            Component.onCompleted: {
                                checked = gallerySwitchEffect.type === modelData.value;
                            }
                        }
                    }
                }
            }

            SettingsItem {
                title: qsTr('窗口效果')
                itemDelegate: Column {
                    spacing: 10

                    ButtonGroup { id: specialEffectGroup }

                    Repeater {
                        delegate: DelRadio {
                            text: modelData.label
                            ButtonGroup.group: specialEffectGroup
                            onClicked: {
                                let oldEffect = galleryWindow.specialEffect;
                                if (!galleryWindow.setSpecialEffect(modelData.value)) {
                                    galleryWindow.setSpecialEffect(oldEffect);
                                }
                            }
                            Component.onCompleted: {
                                checked = galleryWindow.specialEffect === modelData.value;
                            }
                        }
                        Component.onCompleted: {
                            if (Qt.platform.os === 'windows'){
                                model = [
                                            { 'label': qsTr('无'), 'value': DelWindow.None },
                                            { 'label': qsTr('模糊'), 'value': DelWindow.Win_DwmBlur },
                                            { 'label': qsTr('亚克力'), 'value': DelWindow.Win_AcrylicMaterial },
                                            { 'label': qsTr('云母'), 'value': DelWindow.Win_Mica },
                                            { 'label': qsTr('云母变体'), 'value': DelWindow.Win_MicaAlt }
                                        ];
                            } else if (Qt.platform.os === 'osx') {
                                model = [
                                            { 'label': qsTr('无'), 'value': DelWindow.None },
                                            { 'label': qsTr('模糊'), 'value': DelWindow.Mac_BlurEffect },
                                        ];
                            }
                        }
                    }
                }
            }

            SettingsItem {
                title: qsTr('应用主题')
                itemDelegate: Column {
                    spacing: 10

                    ButtonGroup { id: themeGroup }

                    Repeater {
                        model: [
                            { 'label': qsTr('浅色'), 'value': DelTheme.Light },
                            { 'label': qsTr('深色'), 'value': DelTheme.Dark },
                            { 'label': qsTr('跟随系统'), 'value': DelTheme.System }
                        ]
                        delegate: DelRadio {
                            id: darkModeRadio
                            text: modelData.label
                            ButtonGroup.group: themeGroup
                            onClicked: {
                                DelTheme.darkMode = modelData.value;
                            }
                            Component.onCompleted: {
                                checked = DelTheme.darkMode === modelData.value;
                            }

                            Connections {
                                target: DelTheme
                                function onDarkModeChanged() {
                                    darkModeRadio.checked = DelTheme.darkMode === modelData.value;
                                }
                            }
                        }
                    }
                }
            }

            SettingsItem {
                title: qsTr('导航模式')
                itemDelegate: DelRadioBlock {
                    id: navMode
                    model: [
                        { label: qsTr('默认'), value: false },
                        { label: qsTr('紧凑'), value: true }
                    ]
                    onClicked:
                        (index, radioData) => {
                            galleryMenu.compactMode = radioData.value;
                        }
                    Component.onCompleted: {
                        currentCheckedIndex = galleryMenu.compactMode ? 1 : 0;
                    }

                    Connections {
                        target: galleryMenu
                        function onCompactModeChanged() {
                            navMode.currentCheckedIndex = galleryMenu.compactMode ? 1 : 0;
                        }
                    }
                }
            }
        }
    }
}
