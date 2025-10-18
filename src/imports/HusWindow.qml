import QtQuick
import HuskarUI.Basic

Window {
    id: window

    enum SpecialEffect {
        None = 0,

        Win_DwmBlur = 1,
        Win_AcrylicMaterial = 2,
        Win_Mica = 3,
        Win_MicaAlt = 4,

        Mac_BlurEffect = 10
    }

    property real contentHeight: height - captionBar.height
    property alias captionBar: __captionBar
    property alias windowAgent: __windowAgent
    property bool followThemeSwitch: true
    property bool initialized: false
    property int specialEffect: HusWindow.None
    property bool isDesktopPlatform: Qt.platform.os === 'windows' ||
                                     Qt.platform.os === 'osx' ||
                                     Qt.platform.os === 'linux'

    visible: true
    objectName: '__HusWindow__'
    Component.onCompleted: {
        initialized = true;
        setWindowMode(HusTheme.isDark);
        if (isDesktopPlatform)
            __captionBar.windowAgent = __windowAgent;
        if (followThemeSwitch)
            __connections.onIsDarkChanged();
    }

    function setMacSystemButtonsVisible(visible) {
        if (Qt.platform.os === 'osx') {
            windowAgent.setWindowAttribute('no-system-buttons', !visible);
        }
    }

    function setWindowMode(isDark) {
        if (isDesktopPlatform) {
            if (window.initialized)
                return windowAgent.setWindowAttribute('dark-mode', isDark);
            return false;
        } else {
            return false;
        }
    }

    function setSpecialEffect(specialEffect) {
        if (Qt.platform.os === 'windows') {
            switch (specialEffect)
            {
            case HusWindow.Win_DwmBlur:
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                if (windowAgent.setWindowAttribute('dwm-blur', true)) {
                    window.specialEffect = HusWindow.Win_DwmBlur;
                    window.color = 'transparent'
                    return true;
                } else {
                    return false;
                }
            case HusWindow.Win_AcrylicMaterial:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('mica', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                if (windowAgent.setWindowAttribute('acrylic-material', true)) {
                    window.specialEffect = HusWindow.Win_AcrylicMaterial;
                    window.color = 'transparent';
                    return true;
                } else {
                    return false;
                }
            case HusWindow.Win_Mica:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                if (windowAgent.setWindowAttribute('mica', true)) {
                    window.specialEffect = HusWindow.Win_Mica;
                    window.color = 'transparent';
                    return true;
                } else {
                    return false;
                }
            case HusWindow.Win_MicaAlt:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica', false);
                if (windowAgent.setWindowAttribute('mica-alt', true)) {
                    window.specialEffect = HusWindow.Win_MicaAlt;
                    window.color = 'transparent';
                    return true;
                } else {
                    return false;
                }
            case HusWindow.None:
            default:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                window.specialEffect = HusWindow.None;
                window.color = HusTheme.Primary.colorBgBase;
                return true;
            }
        } else if (Qt.platform.os === 'osx') {
            switch (specialEffect)
            {
            case HusWindow.Mac_BlurEffect:
                if (windowAgent.setWindowAttribute('blur-effect', HusTheme.isDark ? 'dark' : 'light')) {
                    window.specialEffect = HusWindow.Mac_BlurEffect;
                    window.color = 'transparent'
                    return true;
                } else {
                    return false;
                }
            case HusWindow.None:
            default:
                windowAgent.setWindowAttribute('blur-effect', 'none');
                window.specialEffect = HusWindow.None;
                window.color = HusTheme.Primary.colorBgBase;
                return true;
            }
        }

        return false;
    }

    Connections {
        target: HusTheme
        enabled: Qt.platform.os === 'osx' /*! 需额外为 MACOSX 处理*/
        function onIsDarkChanged() {
            if (window.specialEffect === HusWindow.Mac_BlurEffect)
                windowAgent.setWindowAttribute('blur-effect', HusTheme.isDark ? 'dark' : 'light');
        }
    }

    Connections {
        id: __connections
        target: HusTheme
        enabled: window.followThemeSwitch
        function onIsDarkChanged() {
            if (window.specialEffect == HusWindow.None)
                window.color = HusTheme.Primary.colorBgBase;
            window.setWindowMode(HusTheme.isDark);
        }
    }

    HusWindowAgent {
        id: __windowAgent
    }

    HusCaptionBar {
        id: __captionBar
        z: 65535
        width: parent.width
        height: 30
        anchors.top: parent.top
        targetWindow: window
    }
}
