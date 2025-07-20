#ifndef CUSTOMTHEME_H
#define CUSTOMTHEME_H

#include <QtQml/qqml.h>

#include "husdefinitions.h"

class CustomTheme : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(CustomTheme)

    HUS_PROPERTY_READONLY(QVariantMap, MyControl);

public:
    static CustomTheme *instance();
    static CustomTheme *create(QQmlEngine *, QJSEngine *);

    void registerAll();

private:
    CustomTheme(QObject *parent = nullptr);
};

#endif // CUSTOMTHEME_H
