#include "husthemefunctions.h"
#include "huscolorgenerator.h"
#include "hussizegenerator.h"
#include "husradiusgenerator.h"

#include <QtGui/QFontDatabase>

HusThemeFunctions::HusThemeFunctions(QObject *parent)
    : QObject{parent}
{

}

HusThemeFunctions *HusThemeFunctions::instance()
{
    static HusThemeFunctions *ins = new HusThemeFunctions;
    return ins;
}

HusThemeFunctions *HusThemeFunctions::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

QList<QColor> HusThemeFunctions::genColor(int preset, bool light, const QColor &background)
{
    return HusColorGenerator::generate(HusColorGenerator::Preset(preset), light, background);
}

QList<QColor> HusThemeFunctions::genColor(const QColor &color, bool light, const QColor &background)
{
    return HusColorGenerator::generate(color, light, background);
}

QList<QString> HusThemeFunctions::genColorString(const QColor &color, bool light, const QColor &background)
{
    QList<QString> result;
    const auto listColor = HusColorGenerator::generate(color, light, background);
    for (const auto &color: listColor)
        result.append(color.name());

    return result;
}

QList<qreal> HusThemeFunctions::genFontSize(qreal fontSizeBase)
{
    return HusSizeGenerator::generateFontSize(fontSizeBase);
}

QList<qreal> HusThemeFunctions::genFontLineHeight(qreal fontSizeBase)
{
    return HusSizeGenerator::generateFontLineHeight(fontSizeBase);
}

QList<int> HusThemeFunctions::genRadius(int radiusBase)
{
    return HusRadiusGenerator::generateRadius(radiusBase);
}

QString HusThemeFunctions::genFontFamily(const QString &familyBase)
{
    const auto families = familyBase.split(',');
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    const auto database = QFontDatabase::families();
#else
    const auto database = QFontDatabase().families();
#endif
    for(auto family: families) {
        auto normalize = family.remove('\'').remove('\"').trimmed();
        if (database.contains(normalize)) {
            return normalize.trimmed();
        }
    }
    return database.first();
}

QColor HusThemeFunctions::darker(const QColor &color, int factor)
{
    return color.darker(factor);
}

QColor HusThemeFunctions::lighter(const QColor &color, int factor)
{
    return color.lighter(factor);
}

QColor HusThemeFunctions::alpha(const QColor &color, qreal alpha)
{
    return QColor(color.red(), color.green(), color.blue(), alpha * 255);
}

QColor HusThemeFunctions::onBackground(const QColor &color, const QColor &background)
{
    const auto fg = color.toRgb();
    const auto bg = background.toRgb();
    const auto alpha = fg.alphaF() + bg.alphaF() * (1 - fg.alphaF());

    return QColor::fromRgbF(
            fg.redF() * fg.alphaF() + bg.redF() * bg.alphaF() * (1 - fg.alphaF()) / alpha,
            fg.greenF() * fg.alphaF() + bg.greenF() * bg.alphaF() * (1 - fg.alphaF()) / alpha,
            fg.blueF() * fg.alphaF() + bg.blueF() * bg.alphaF() * (1 - fg.alphaF()) / alpha,
            alpha
        );
}

qreal HusThemeFunctions::multiply(qreal num1, qreal num2)
{
    return num1 * num2;
}
