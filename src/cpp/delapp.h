#ifndef DELAPP_H
#define DELAPP_H

#include <QtQml/qqml.h>

#include "delglobal.h"

class DELEGATEUI_EXPORT DelApp : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(DelIcon)

public:
    ~DelApp();

    static void initialize(QQmlEngine *engine);

    static DelApp *instance();
    static DelApp *create(QQmlEngine *, QJSEngine *);

private:
    explicit DelApp(QObject *parent = nullptr);
};

#endif // DELAPP_H
