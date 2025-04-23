#include "delthemefunctions.h"
#include "delcolorgenerator.h"
#include "delsizegenerator.h"

#include <QtGui/QFontDatabase>

DelThemeFunctions::DelThemeFunctions(QObject *parent)
    : QObject{parent}
{

}

DelThemeFunctions *DelThemeFunctions::instance()
{
    static DelThemeFunctions *ins = new DelThemeFunctions;
    return ins;
}

DelThemeFunctions *DelThemeFunctions::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

QList<QColor> DelThemeFunctions::genColor(int preset, bool light, const QColor &background)
{
    return DelColorGenerator::generate(DelColorGenerator::Preset(preset), light, background);
}

QList<QColor> DelThemeFunctions::genColor(const QColor &color, bool light, const QColor &background)
{
    return DelColorGenerator::generate(color, light, background);
}

QList<QString> DelThemeFunctions::genColorString(const QColor &color, bool light, const QColor &background)
{
    QList<QString> result;
    const auto listColor = DelColorGenerator::generate(color, light, background);
    for (const auto &color: listColor)
        result.append(color.name());

    return result;
}

QList<qreal> DelThemeFunctions::genFontSize(qreal fontSizeBase)
{
    return DelSizeGenerator::generateFontSize(fontSizeBase);
}

QList<qreal> DelThemeFunctions::genFontLineHeight(qreal fontSizeBase)
{
    return DelSizeGenerator::generateFontLineHeight(fontSizeBase);
}

QString DelThemeFunctions::genFontFamily(const QString &familyBase)
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

QColor DelThemeFunctions::darker(const QColor &color, int factor)
{
    return color.darker(factor);
}

QColor DelThemeFunctions::lighter(const QColor &color, int factor)
{
    return color.lighter(factor);
}

QColor DelThemeFunctions::alpha(const QColor &color, qreal alpha)
{
    return QColor(color.red(), color.green(), color.blue(), alpha * 255);
}

qreal DelThemeFunctions::multiply(qreal num1, qreal num2)
{
    return num1 * num2;
}
