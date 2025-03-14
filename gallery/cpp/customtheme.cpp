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
    /*DelTheme::instance()->registerCustomComponentTheme(this, "MyControl", &m_MyControl, ":/Gallery/theme/MyControl.json");
    DelTheme::instance()->reloadTheme();*/
}

CustomTheme::CustomTheme(QObject *parent)
    : QObject{parent}
{

}
