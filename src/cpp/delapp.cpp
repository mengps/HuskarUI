#include "delapp.h"

#include <QWKQuick/qwkquickglobal.h>

#include <QtGui/QFontDatabase>

/*
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0) && defined(Q_OS_WIN)
# include <private/qguiapplication_p.h>
# include <qpa/qplatformintegration.h>
#endif
*/

DelApp::~DelApp()
{

}

void DelApp::initialize(QQmlEngine *engine)
{
    QWK::registerTypes(engine);

    QFontDatabase::addApplicationFont(":/DelegateUI/resources/font/DelegateUI-Icons.ttf");
}

QString DelApp::libVersion()
{
    return DELEGATEUI_LIBRARY_VERSION;
}

DelApp *DelApp::instance()
{
    static DelApp *ins = new DelApp;
    return ins;
}

DelApp *DelApp::create(QQmlEngine *, QJSEngine *)
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

DelApp::DelApp(QObject *parent)
    : QObject{parent}
{

}
