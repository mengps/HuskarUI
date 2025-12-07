/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

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
