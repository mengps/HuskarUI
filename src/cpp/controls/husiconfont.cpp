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
