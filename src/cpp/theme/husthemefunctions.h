#ifndef HUSTHEMEFUNCTIONS_H
#define HUSTHEMEFUNCTIONS_H

#include <QtCore/QObject>
#include <QtGui/QColor>
#include <QtQml/qqml.h>

#include "husglobal.h"

class HUSKARUI_EXPORT HusThemeFunctions : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(HusThemeFunctions)

public:
    HusThemeFunctions(QObject *parent = nullptr);

    static HusThemeFunctions *instance();
    static HusThemeFunctions *create(QQmlEngine *, QJSEngine *);

    Q_INVOKABLE static QList<QColor> genColor(int preset, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<QColor> genColor(const QColor &color, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<QString> genColorString(const QColor &color, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<qreal> genFontSize(qreal fontSizeBase);
    Q_INVOKABLE static QList<qreal> genFontLineHeight(qreal fontSizeBase);
    Q_INVOKABLE static QList<int> genRadius(int radiusBase);
    Q_INVOKABLE static QString genFontFamily(const QString &fontFamilyBase);
    Q_INVOKABLE static QColor darker(const QColor &color, int factor = 140);
    Q_INVOKABLE static QColor lighter(const QColor &color, int factor = 140);
    Q_INVOKABLE static QColor alpha(const QColor &color, qreal alpha = 0.5);
    Q_INVOKABLE static QColor onBackground(const QColor &color, const QColor &background);
    Q_INVOKABLE static qreal multiply(qreal num1, qreal num2);
};

#endif // HUSTHEMEFUNCTIONS_H
