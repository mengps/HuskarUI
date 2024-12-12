#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

#ifdef BUILD_DELEGATEUI_STATIC_LIBRARY
#include <QtQml/qqmlextensionplugin.h>
Q_IMPORT_QML_PLUGIN(DelegateUI)
#endif

#include "customtheme.h"
#include "delapp.h"

int main(int argc, char *argv[])
{
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DelApp::initialize(&engine);
    CustomTheme::instance()->registerAll();

    const QUrl url(u"qrc:/Gallery/qml/Gallery.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
