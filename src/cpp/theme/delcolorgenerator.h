#ifndef DELCOLORGENERATOR_H
#define DELCOLORGENERATOR_H

#include <QObject>
#include <QColor>
#include <qqmlintegration.h>

#include "delglobal.h"

class DELEGATEUI_EXPORT DelColorGenerator : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(DelColorGenerator)

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

    DelColorGenerator(QObject *parent = nullptr);
    ~DelColorGenerator();

    Q_INVOKABLE static QColor reverseColor(const QColor &color);
    Q_INVOKABLE static QColor presetToColor(const QString& color);
    Q_INVOKABLE static QColor presetToColor(DelColorGenerator::Preset color);
    Q_INVOKABLE static QList<QColor> generate(DelColorGenerator::Preset color, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<QColor> generate(const QColor &color, bool light = true, const QColor &background = QColor(QColor::Invalid));
};


#endif // DELCOLORGENERATOR_H
