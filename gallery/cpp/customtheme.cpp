#include "customtheme.h"
#include "deltheme.h"

CustomTheme *CustomTheme::instance()
{
    static CustomTheme theme;
    return &theme;
}

CustomTheme *CustomTheme::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

void CustomTheme::registerAll()
{
    //DelTheme::instance()->registerCustomThemeComponent(this, "MyControl", &m_MyControl, ":/Gallery/theme/MyControl.json");
}

CustomTheme::CustomTheme(QObject *parent)
    : QObject{parent}
{

}
