import QtQuick
import DelegateUI

Window {
    id: window

    enum SpecialEffect
    {
        None = 0,
        DwmBlur = 1,
        AcrylicMaterial = 2,
        Mica = 3,
        MicaAlt = 4
    }

    property alias captionBar: __captionBar
    property alias windowAgent: __windowAgent
    property bool followThemeSwitch: true
    property bool initialized: false
    property int specialEffect: DelWindow.None

    visible: true
    objectName: "__DelWindow__"
    Component.onCompleted: {
        initialized = true;
        setWindowMode(DelTheme.isDark);
        __captionBar.windowAgent = __windowAgent;
        if (followThemeSwitch)
            __connections.onIsDarkChanged();
    }

    function setWindowMode(isDark) {
        if (window.initialized)
            windowAgent.setWindowAttribute("dark-mode", isDark);
    }

    function setSpecialEffect(specialEffect) {
        /*! 仅支持Windows */
        if (Qt.platform.os !== "windows") return;

        switch (specialEffect)
        {
        case DelWindow.DwmBlur:
            window.color = "transparent"
            windowAgent.setWindowAttribute("acrylic-material", false);
            windowAgent.setWindowAttribute("mica", false);
            windowAgent.setWindowAttribute("mica-alt", false);
            windowAgent.setWindowAttribute("dwm-blur", true);
            window.specialEffect = DelWindow.DwmBlur;
            break;
        case DelWindow.AcrylicMaterial:
            window.color = "transparent";
            windowAgent.setWindowAttribute("dwm-blur", false);
            windowAgent.setWindowAttribute("mica", false);
            windowAgent.setWindowAttribute("mica-alt", false);
            windowAgent.setWindowAttribute("acrylic-material", true);
            window.specialEffect = DelWindow.AcrylicMaterial;
            break;
        case DelWindow.Mica:
            window.color = "transparent";
            windowAgent.setWindowAttribute("dwm-blur", false);
            windowAgent.setWindowAttribute("acrylic-material", false);
            windowAgent.setWindowAttribute("mica-alt", false);
            windowAgent.setWindowAttribute("mica", true);
            window.specialEffect = DelWindow.Mica;
            break;
        case DelWindow.MicaAlt:
            window.color = "transparent";
            windowAgent.setWindowAttribute("dwm-blur", false);
            windowAgent.setWindowAttribute("acrylic-material", false);
            windowAgent.setWindowAttribute("mica", false);
            windowAgent.setWindowAttribute("mica-alt", true);
            window.specialEffect = DelWindow.MicaAlt;
            break;
        case DelWindow.None:
        default:
            windowAgent.setWindowAttribute("dwm-blur", false);
            windowAgent.setWindowAttribute("acrylic-material", false);
            windowAgent.setWindowAttribute("mica", false);
            windowAgent.setWindowAttribute("mica-alt", false);
            window.specialEffect = DelWindow.None;
            break;
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
