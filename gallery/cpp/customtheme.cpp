#include "customtheme.h"
#include "hustheme.h"

CustomTheme *CustomTheme::instance()
{
    static CustomTheme *ins = new CustomTheme;
    return ins;
}

CustomTheme *CustomTheme::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

void CustomTheme::registerAll()
{
    /*HusTheme::instance()->registerCustomComponentTheme(this, "MyControl", &m_MyControl, ":/Gallery/theme/MyControl.json");
    HusTheme::instance()->reloadTheme();*/
}

CustomTheme::CustomTheme(QObject *parent)
    : QObject{parent}
{

}
