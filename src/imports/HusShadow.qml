import QtQuick
import QtQuick.Effects
import HuskarUI.Basic

MultiEffect {
    shadowEnabled: true
    shadowColor: HusTheme.Primary.colorTextBase
    shadowOpacity: HusTheme.isDark ? 0.4 : 0.2
    shadowScale: HusTheme.isDark ? 1.03 : 1.02
}
