import QtQuick
import DelegateUI

Window {
    id: window

    enum SpecialEffect
    {
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
    property int specialEffect: DelWindow.None

    visible: true
    objectName: '__DelWindow__'
    Component.onCompleted: {
        initialized = true;
        setWindowMode(DelTheme.isDark);
        __captionBar.windowAgent = __windowAgent;
        if (followThemeSwitch)
            __connections.onIsDarkChanged();
    }

    function setMacSystemButtonsVisble(visible) {
        if (Qt.platform.os === 'osx') {
            windowAgent.setWindowAttribute('no-system-buttons', !visible);
        }
    }

    function setWindowMode(isDark) {
        if (window.initialized)
            return windowAgent.setWindowAttribute('dark-mode', isDark);
        return false;
    }

    function setSpecialEffect(specialEffect) {
        if (Qt.platform.os === 'windows') {
            switch (specialEffect)
            {
            case DelWindow.Win_DwmBlur:
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                if (windowAgent.setWindowAttribute('dwm-blur', true)) {
                    window.specialEffect = DelWindow.Win_DwmBlur;
                    window.color = 'transparent'
                    return true;
                } else {
                    return false;
                }
            case DelWindow.Win_AcrylicMaterial:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('mica', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                if (windowAgent.setWindowAttribute('acrylic-material', true)) {
                    window.specialEffect = DelWindow.Win_AcrylicMaterial;
                    window.color = 'transparent';
                    return true;
                } else {
                    return false;
                }
            case DelWindow.Win_Mica:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                if (windowAgent.setWindowAttribute('mica', true)) {
                    window.specialEffect = DelWindow.Win_Mica;
                    window.color = 'transparent';
                    return true;
                } else {
                    return false;
                }
            case DelWindow.Win_MicaAlt:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica', false);
                if (windowAgent.setWindowAttribute('mica-alt', true)) {
                    window.specialEffect = DelWindow.Win_MicaAlt;
                    window.color = 'transparent';
                    return true;
                } else {
                    return false;
                }
            case DelWindow.None:
            default:
                windowAgent.setWindowAttribute('dwm-blur', false);
                windowAgent.setWindowAttribute('acrylic-material', false);
                windowAgent.setWindowAttribute('mica', false);
                windowAgent.setWindowAttribute('mica-alt', false);
                window.specialEffect = DelWindow.None;
                window.color = DelTheme.Primary.colorBgBase;
                return true;
            }
        } else if (Qt.platform.os === 'osx') {
            switch (specialEffect)
            {
            case DelWindow.Mac_BlurEffect:
                if (windowAgent.setWindowAttribute('blur-effect', DelTheme.isDark ? 'dark' : 'light')) {
                    window.specialEffect = DelWindow.Mac_BlurEffect;
                    window.color = 'transparent'
                    return true;
                } else {
                    return false;
                }
            case DelWindow.None:
            default:
                windowAgent.setWindowAttribute('blur-effect', 'none');
                window.specialEffect = DelWindow.None;
                window.color = DelTheme.Primary.colorBgBase;
                return true;
            }
        }

        return false;
    }

    Connections {
        target: DelTheme
        enabled: Qt.platform.os === 'osx' /*! 需额外为 MACOSX 处理*/
        function onIsDarkChanged() {
            if (window.specialEffect === DelWindow.Mac_BlurEffect)
                windowAgent.setWindowAttribute('blur-effect', DelTheme.isDark ? 'dark' : 'light');
        }
    }

    Connections {
        id: __connections
        target: DelTheme
        enabled: window.followThemeSwitch
        function onIsDarkChanged() {
            if (window.specialEffect == DelWindow.None)
                window.color = DelTheme.Primary.colorBgBase;
            window.setWindowMode(DelTheme.isDark);
        }
    }

    DelWindowAgent {
        id: __windowAgent
    }

    DelCaptionBar {
        id: __captionBar
        z: 65535
        width: parent.width
        height: 30
        anchors.top: parent.top
        targetWindow: window
    }
}
