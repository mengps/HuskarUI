#include "delapp.h"

#include <QWKQuick/qwkquickglobal.h>

DelApp::~DelApp()
{

}

void DelApp::initialize(QQmlEngine *engine)
{
    QWK::registerTypes(engine);
}

DelApp *DelApp::instance()
{
    static DelApp *ins = new DelApp;
    return ins;
}

DelApp *DelApp::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

DelApp::DelApp(QObject *parent)
    : QObject{parent}
{

}
