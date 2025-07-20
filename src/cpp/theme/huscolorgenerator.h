#ifndef HUSCOLORGENERATOR_H
#define HUSCOLORGENERATOR_H

#include <QtCore/QObject>
#include <QtGui/QColor>
#include <QtQml/qqml.h>

#include "husglobal.h"

class HUSKARUI_EXPORT HusColorGenerator : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusColorGenerator)

public:
    enum class Preset
    {
        Preset_Red = 1,
        Preset_Volcano,
        Preset_Orange,
        Preset_Gold,
        Preset_Yellow,
        Preset_Lime,
        Preset_Green,
        Preset_Cyan,
        Preset_Blue,
        Preset_Geekblue,
        Preset_Purple,
        Preset_Magenta,
        Preset_Grey
    };
    Q_ENUM(Preset);

    HusColorGenerator(QObject *parent = nullptr);
    ~HusColorGenerator();

    Q_INVOKABLE static QColor reverseColor(const QColor &color);
    Q_INVOKABLE static QColor presetToColor(const QString& color);
    Q_INVOKABLE static QColor presetToColor(HusColorGenerator::Preset color);
    Q_INVOKABLE static QList<QColor> generate(HusColorGenerator::Preset color, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<QColor> generate(const QColor &color, bool light = true, const QColor &background = QColor(QColor::Invalid));
};


#endif // HUSCOLORGENERATOR_H
