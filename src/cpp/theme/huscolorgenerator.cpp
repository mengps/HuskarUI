#include "huscolorgenerator.h"

#include <QtCore/QHash>
#include <QtCore/qmath.h>

static const auto g_hueStep = 2; // 色相阶梯
static const auto g_saturationStep = 0.16; // 饱和度阶梯，浅色部分
static const auto g_saturationStep2 = 0.05; // 饱和度阶梯，深色部分
static const auto g_brightnessStep1 = 0.05; // 亮度阶梯，浅色部分
static const auto g_brightnessStep2 = 0.15; // 亮度阶梯，深色部分
static const auto g_lightColorCount = 5; // 浅色数量，主色上
static const auto g_darkColorCount = 4; // 深色数量，主色下

[[maybe_unused]] static auto qHash(HusColorGenerator::Preset preset)
{
    return static_cast<std::underlying_type<HusColorGenerator::Preset>::type>(preset);
}

static QColor mix(const QColor &rgb1, const QColor &rgb2, int amount)
{
    qreal p = qreal(amount) / 100.0;
    const QColor rgb = QColor::fromRgbF(
        (rgb2.redF() - rgb1.redF()) * p + rgb1.redF(),
        (rgb2.greenF() - rgb1.greenF()) * p + rgb1.greenF(),
        (rgb2.blueF() - rgb1.blueF()) * p + rgb1.blueF()
        );
    return rgb;
}

static qreal getHue(const QColor &hsv, int i, bool light = false)
{
    qreal hue;
    // 根据色相不同，色相转向不同
    if (std::round(hsv.hsvHue()) >= 60 && std::round(hsv.hsvHue()) <= 240) {
        hue = light ? hsv.hsvHue() - g_hueStep * i : hsv.hsvHue() + g_hueStep * i;
    } else {
        hue = light ? hsv.hsvHue() + g_hueStep * i : hsv.hsvHue() - g_hueStep * i;
    }

    if (hue < 0) {
        hue += 360;
    } else if (hue >= 360) {
        hue -= 360;
    }

    return hue;
}

static qreal getSaturation(const QColor &hsv, int i, bool light = false)
{
    // grey color don't change saturation
    if (hsv.hsvHue() == 0 && hsv.hsvSaturation() == 0) {
        return hsv.hsvSaturation();
    }

    qreal saturation;
    if (light) {
        saturation = hsv.hsvSaturationF() - g_saturationStep * i;
    } else if (i == g_darkColorCount) {
        saturation = hsv.hsvSaturationF() + g_saturationStep;
    } else {
        saturation = hsv.hsvSaturationF() + g_saturationStep2 * i;
    }
    // 边界值修正
    if (saturation > 1) {
        saturation = 1;
    }
    // 第一格的 s 限制在 0.06-0.1 之间
    if (light && i == g_lightColorCount && saturation > 0.1) {
        saturation = 0.1;
    }
    if (saturation < 0.06) {
        saturation = 0.06;
    }

    return saturation;
}

static qreal getValue(const QColor &hsv, int i, bool light = false)
{
    qreal value;
    if (light) {
        value = hsv.valueF() + g_brightnessStep1 * i;
    } else {
        value = hsv.valueF() - g_brightnessStep2 * i;
    }
    if (value > 1) {
        value = 1;
    }

    return value;
}

HusColorGenerator::HusColorGenerator(QObject *parent)
    : QObject{parent}
{

}

HusColorGenerator::~HusColorGenerator()
{

}

QColor HusColorGenerator::reverseColor(const QColor &color)
{
    return QColor(255 - color.red(), 255 - color.green(), 255 - color.blue(), color.alpha());
}

QColor HusColorGenerator::presetToColor(const QString &color)
{
    using PresetTableType = QHash<QString, QColor>;
    static PresetTableType g_presetTable {
        { QString("Preset_Red"),      QColor(0xF5222D) },
        { QString("Preset_Volcano"),  QColor(0xFA541C) },
        { QString("Preset_Orange"),   QColor(0xFA8C16) },
        { QString("Preset_Gold"),     QColor(0xFAAD14) },
        { QString("Preset_Yellow"),   QColor(0xFADB14) },
        { QString("Preset_Lime"),     QColor(0xA0D911) },
        { QString("Preset_Green"),    QColor(0x52C41A) },
        { QString("Preset_Cyan"),     QColor(0x13C2C2) },
        { QString("Preset_Blue"),     QColor(0x1677FF) },
        { QString("Preset_Geekblue"), QColor(0x2F54EB) },
        { QString("Preset_Purple"),   QColor(0x722ED1) },
        { QString("Preset_Magenta"),  QColor(0xEB2F96) },
        { QString("Preset_Grey"),     QColor(0x666666) }
    };

    if (g_presetTable.contains(color))
        return g_presetTable[color];
    else
        return QColor(QColor::Invalid);
}

QColor HusColorGenerator::presetToColor(HusColorGenerator::Preset color)
{
    using PresetTableType = QHash<HusColorGenerator::Preset, QColor>;
    static PresetTableType g_presetTable {
        { HusColorGenerator::Preset::Preset_Red,      QColor(0xF5222D) },
        { HusColorGenerator::Preset::Preset_Volcano,  QColor(0xFA541C) },
        { HusColorGenerator::Preset::Preset_Orange,   QColor(0xFA8C16) },
        { HusColorGenerator::Preset::Preset_Gold,     QColor(0xFAAD14) },
        { HusColorGenerator::Preset::Preset_Yellow,   QColor(0xFADB14) },
        { HusColorGenerator::Preset::Preset_Lime,     QColor(0xA0D911) },
        { HusColorGenerator::Preset::Preset_Green,    QColor(0x52C41A) },
        { HusColorGenerator::Preset::Preset_Cyan,     QColor(0x13C2C2) },
        { HusColorGenerator::Preset::Preset_Blue,     QColor(0x1677FF) },
        { HusColorGenerator::Preset::Preset_Geekblue, QColor(0x2F54EB) },
        { HusColorGenerator::Preset::Preset_Purple,   QColor(0x722ED1) },
        { HusColorGenerator::Preset::Preset_Magenta,  QColor(0xEB2F96) },
        { HusColorGenerator::Preset::Preset_Grey,     QColor(0x666666) }
    };

    if (g_presetTable.contains(color))
        return g_presetTable[color];
    else
        return QColor(QColor::Invalid);
}

QList<QColor> HusColorGenerator::generate(HusColorGenerator::Preset color, bool light, const QColor &background)
{
    return generate(presetToColor(color), light, background);
}

QList<QColor> HusColorGenerator::generate(const QColor &color, bool light, const QColor &background)
{
    QList<QColor> patterns;
    const auto hsv = color.toHsv();
    for (auto i = g_lightColorCount; i > 0; i -= 1) {
        const auto colorString = QColor::fromHsvF(getHue(hsv, i, true) / 360.0,
                                                  getSaturation(hsv, i, true),
                                                  std::max(getValue(hsv, i, true), 0.)).name();
        patterns.append(colorString);
    }
    patterns.append(color.name());

    for (auto i = 1; i <= g_darkColorCount; i += 1) {
        const auto colorString = QColor::fromHsvF(getHue(hsv, i) / 360.0,
                                                  getSaturation(hsv, i),
                                                  std::max(getValue(hsv, i), 0.)).name();
        patterns.append(colorString);
    }

    //dark theme patterns
    if (!light) {
        static const std::list<std::tuple<int, int>> g_darkColorMap = {
            std::make_tuple(7, 15),
            std::make_tuple(6, 25),
            std::make_tuple(5, 30),
            std::make_tuple(5, 45),
            std::make_tuple(5, 65),
            std::make_tuple(5, 85),
            std::make_tuple(4, 90),
            std::make_tuple(3, 95),
            std::make_tuple(2, 97),
            std::make_tuple(1, 98)
        };
        QList<QColor> darkColorString;
        std::for_each(g_darkColorMap.begin(), g_darkColorMap.end(), [&patterns, &darkColorString, background](const std::tuple<int, int> &value){
            const auto [index, amount] = value;
            darkColorString.append(mix(background.isValid() ? background : QColor(0x141414), patterns[index], amount));
        });
        return darkColorString;
    }

    return patterns;
}
