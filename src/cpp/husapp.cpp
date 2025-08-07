#include "husapp.h"

#ifdef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM
#include <QWKQuick/qwkquickglobal.h>
#endif

#include <QtGui/QFontDatabase>

/*
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0) && defined(Q_OS_WIN)
# include <private/qguiapplication_p.h>
# include <qpa/qplatformintegration.h>
#endif
*/

HusApp::~HusApp()
{

}

void HusApp::initialize(QQmlEngine *engine)
{
#ifdef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM
    QWK::registerTypes(engine);
#endif

    QFontDatabase::addApplicationFont(":/HuskarUI/resources/font/HuskarUI-Icons.ttf");
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

HusApp *HusApp::create(QQmlEngine *, QJSEngine *)
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

    return instance();
}

HusApp::HusApp(QObject *parent)
    : QObject{parent}
{

}
