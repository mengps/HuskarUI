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

#include "husapp.h"

#include <QtGui/QFontDatabase>

/*
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0) && defined(Q_OS_WIN)
# include <QtGui/private/qguiapplication_p.h>
# include <QtGui/qpa/qplatformintegration.h>
#endif
*/

Q_GLOBAL_STATIC_WITH_ARGS(bool, g_initialized, (false));

HusApp::~HusApp()
{

}

void HusApp::initialize(QQmlEngine *engine)
{
    QFontDatabase::addApplicationFont(":/HuskarUI/resources/font/HuskarUI-Icons.ttf");

    *g_initialized = true;
}

QString HusApp::libName()
{
    return "HuskarUI";
}

QString HusApp::libVersion()
{
    return HUSKARUI_LIBRARY_VERSION;
}

HusApp *HusApp::instance()
{
    static HusApp *ins = new HusApp;
    return ins;
}

HusApp *HusApp::create(QQmlEngine *qmlEngine, QJSEngine *)
{
    /*! 移除Qt窗口的暗黑模式, 但会造成`QGuiApplication::styleHints()->colorScheme()`失效, 暂时不使用 */
    /*
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0) && defined(Q_OS_WIN)
    using QWindowsApplication = QNativeInterface::Private::QWindowsApplication;
    auto nativeWindowsApp = dynamic_cast<QWindowsApplication *>(QGuiApplicationPrivate::platformIntegration());
    if (nativeWindowsApp)
        nativeWindowsApp->setDarkModeHandling(QWindowsApplication::DarkModeStyle);
#endif
*/

    if (!*g_initialized)
        initialize(qmlEngine);

    return instance();
}

HusApp::HusApp(QObject *parent)
    : QObject{parent}
{

}
