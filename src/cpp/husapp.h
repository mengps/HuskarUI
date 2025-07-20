#ifndef HUSAPP_H
#define HUSAPP_H

#include <QtQml/qqml.h>

#include "husglobal.h"

class HUSKARUI_EXPORT HusApp : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(HusApp)

public:
    ~HusApp();

    static void initialize(QQmlEngine *engine);

    Q_INVOKABLE static QString libVersion();

    static HusApp *instance();
    static HusApp *create(QQmlEngine *, QJSEngine *);

private:
    explicit HusApp(QObject *parent = nullptr);
};

#endif // HUSAPP_H
