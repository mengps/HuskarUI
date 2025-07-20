#ifndef HUSRADIUSGENERATOR_H
#define HUSRADIUSGENERATOR_H

#include <QtCore/QObject>
#include <QtQml/qqml.h>

#include "husglobal.h"

class HUSKARUI_EXPORT HusRadiusGenerator : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusRadiusGenerator)

public:
    HusRadiusGenerator(QObject *parent = nullptr);
    ~HusRadiusGenerator();

    Q_INVOKABLE static QList<int> generateRadius(int radiusBase);
};

#endif // HUSRADIUSGENERATOR_H
