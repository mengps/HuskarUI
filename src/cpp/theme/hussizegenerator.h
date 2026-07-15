#ifndef HUSSIZEGENERATOR_H
#define HUSSIZEGENERATOR_H

#include "husglobal.h"

#include <QtCore/QObject>
#include <QtQml/qqml.h>

class HUSKARUI_EXPORT HusSizeGenerator : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusSizeGenerator)

public:
    HusSizeGenerator(QObject *parent = nullptr);
    ~HusSizeGenerator();

    Q_INVOKABLE static QList<qreal> generateFontSize(qreal fontSizeBase);
    Q_INVOKABLE static QList<qreal> generateFontLineHeight(qreal fontSizeBase);
};

#endif // HUSSIZEGENERATOR_H
