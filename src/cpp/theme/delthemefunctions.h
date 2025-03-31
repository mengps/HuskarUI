#ifndef DELTHEMEFUNCTIONS_H
#define DELTHEMEFUNCTIONS_H

#include <QObject>
#include <QColor>
#include <QtQml/qqml.h>

#include "delglobal.h"

class DELEGATEUI_EXPORT DelThemeFunctions : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(DelThemeFunctions)

public:
    DelThemeFunctions(QObject *parent = nullptr);

    static DelThemeFunctions *instance();
    static DelThemeFunctions *create(QQmlEngine *, QJSEngine *);

    Q_INVOKABLE static QList<QColor> genColor(int preset, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<QColor> genColor(const QColor &color, bool light = true, const QColor &background = QColor(QColor::Invalid));
    Q_INVOKABLE static QList<qreal> genFontSize(qreal fontSizeBase);
    Q_INVOKABLE static QList<qreal> genFontLineHeight(qreal fontSizeBase);
    Q_INVOKABLE static QString genFontFamily(const QString &fontFamilyBase);
    Q_INVOKABLE static QColor darker(const QColor &color, int factor = 140);
    Q_INVOKABLE static QColor lighter(const QColor &color, int factor = 140);
    Q_INVOKABLE static QColor alpha(const QColor &color, qreal alpha = 0.5);
    Q_INVOKABLE static qreal multiply(qreal num1, qreal num2);
};

#endif // DELTHEMEFUNCTIONS_H
