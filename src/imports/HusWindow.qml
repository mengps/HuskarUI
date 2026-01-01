/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

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

    Component.onCompleted: {
        initialized = true;
        setWindowMode(HusTheme.isDark);
        if (isDesktopPlatform)
            __captionBar.windowAgent = __windowAgent;
        if (followThemeSwitch)
            __connections.onIsDarkChanged();
    }

    objectName: '__HusWindow__'
    visible: true

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
