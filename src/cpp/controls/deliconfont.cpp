#include "deliconfont.h"

DelIcon::DelIcon(QObject *parent)
    : QObject{parent}
{

}

DelIcon::~DelIcon()
{

}

DelIcon *DelIcon::instance()
{
    static DelIcon *ins = new DelIcon;

    return ins;
}

DelIcon *DelIcon::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

QVariantMap DelIcon::allIconNames()
{
    QVariantMap iconMap;
    QMetaEnum me = QMetaEnum::fromType<DelIcon::Type>();
    for (int i = 0; i < me.keyCount(); i++) {
        iconMap[QString::fromLatin1(me.key(i))] = me.value(i);
    }

    return iconMap;
}
