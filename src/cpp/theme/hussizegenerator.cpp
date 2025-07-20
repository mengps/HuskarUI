#include "hussizegenerator.h"

#include <QtCore/qmath.h>

HusSizeGenerator::HusSizeGenerator(QObject *parent)
    : QObject{parent}
{

}

HusSizeGenerator::~HusSizeGenerator()
{

}

QList<qreal> HusSizeGenerator::generateFontSize(qreal fontSizeBase)
{
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    QList<qreal> fontSizes(10);
    for (int index = 0; index < 10; index++) {
        const auto i = index - 1;
        const auto baseSize = fontSizeBase * std::pow(M_E, i / 5.0);
        const auto intSize = (i + 1) > 1 ? std::floor(baseSize) : std::ceil(baseSize);
        // Convert to even
        fontSizes[index] = std::floor(intSize / 2) * 2;
    }
    fontSizes[1] = fontSizeBase;

    return fontSizes;
#else
    QVector<qreal> fontSizes(10);

    for (int index = 0; index < 10; index++) {
        const auto i = index - 1;
        const auto baseSize = fontSizeBase * std::pow(M_E, i / 5.0);
        const auto intSize = (i + 1) > 1 ? std::floor(baseSize) : std::ceil(baseSize);
        // Convert to even
        fontSizes[index] = std::floor(intSize / 2) * 2;
    }
    fontSizes[1] = fontSizeBase;

    return fontSizes.toList();
#endif
}

QList<qreal> HusSizeGenerator::generateFontLineHeight(qreal fontSizeBase)
{
    QList<qreal> fontLineHeights = generateFontSize(fontSizeBase);
    for (int index = 0; index < 10; index++) {
        auto fontSize = fontLineHeights[index];
        fontLineHeights[index] = (fontSize + 8) / fontSize;
    }

    return fontLineHeights;
}
