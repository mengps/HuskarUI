#include "delthemefunctions.h"
#include "delcolorgenerator.h"
#include "delsizegenerator.h"

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

QList<QColor> DelThemeFunctions::genColor(const QColor &color, bool light, const QColor &background)
{
    return DelColorGenerator::generate(color, light, background);
}

QList<qreal> DelThemeFunctions::genFontSize(qreal fontSizeBase)
{
    return DelSizeGenerator::generateFontSize(fontSizeBase);
}

QList<qreal> DelThemeFunctions::genFontLineHeight(qreal fontSizeBase)
{
    return DelSizeGenerator::generateFontLineHeight(fontSizeBase);
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
