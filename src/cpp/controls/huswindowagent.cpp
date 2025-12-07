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

#include "huswindowagent.h"

HusWindowAgent::HusWindowAgent(QObject *parent)
#ifdef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM
    : QWK::QuickWindowAgent{parent}
#else
    : QObject{parent}
#endif
{

}

HusWindowAgent::~HusWindowAgent()
{

}

void HusWindowAgent::classBegin()
{
    auto p = parent();
    Q_ASSERT_X(p, "HusWindowAgent", "parent() return nullptr!");
    if (p) {
#ifdef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM
# if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        if (p->objectName() == QLatin1StringView("__HusWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
# else
        if (p->objectName() == QLatin1String("__HusWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
# endif
#endif
    }
}

void HusWindowAgent::componentComplete()
{

}
