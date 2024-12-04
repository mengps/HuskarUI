#include "delsizegenerator.h"

#include <cmath>

DelSizeGenerator::DelSizeGenerator(QObject *parent)
    : QObject{parent}
{

}

DelSizeGenerator::~DelSizeGenerator()
{

}

QList<qreal> DelSizeGenerator::generateFontSize(qreal fontSizeBase)
{
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
}

QList<qreal> DelSizeGenerator::generateFontLineHeight(qreal fontSizeBase)
{
    QList<qreal> fontLineHeights = generateFontSize(fontSizeBase);
    for (int index = 0; index < 10; index++) {
        auto fontSize = fontLineHeights[index];
        fontLineHeights[index] = (fontSize + 8) / fontSize;
    }

    return fontLineHeights;
}
