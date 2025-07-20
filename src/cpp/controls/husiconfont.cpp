#include "husiconfont.h"

HusIcon::HusIcon(QObject *parent)
    : QObject{parent}
{

}

HusIcon::~HusIcon()
{

}

HusIcon *HusIcon::instance()
{
    static HusIcon *ins = new HusIcon;

    return ins;
}

HusIcon *HusIcon::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

QVariantMap HusIcon::allIconNames()
{
    QVariantMap iconMap;
    QMetaEnum me = QMetaEnum::fromType<HusIcon::Type>();
    for (int i = 0; i < me.keyCount(); i++) {
        iconMap[QString::fromLatin1(me.key(i))] = me.value(i);
    }

    return iconMap;
}
