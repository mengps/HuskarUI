#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

#ifdef BUILD_HUSKARUI_STATIC_LIBRARY
#include <QtQml/qqmlextensionplugin.h>
Q_IMPORT_QML_PLUGIN(HuskarUI_ImplPlugin)
Q_IMPORT_QML_PLUGIN(HuskarUI_BasicPlugin)
#endif

#include "customtheme.h"
#include "husapp.h"

int main(int argc, char *argv[])
{
#ifndef Q_OS_MAC
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
#endif
    QQuickWindow::setDefaultAlphaBuffer(true);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("MenPenS");
    app.setApplicationName("HuskarUI");
    app.setApplicationDisplayName("HuskarUI Gallery");
    app.setApplicationVersion(HusApp::libVersion());

    QQmlApplicationEngine engine;

    CustomTheme::instance()->registerAll();

    const QUrl url = QUrl(QStringLiteral("qrc:/Gallery/qml/Gallery.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.addImportPath(HUSKARUI_IMPORT_PATH);
    engine.load(url);

    return app.exec();
}
