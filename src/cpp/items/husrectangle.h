#ifndef HUSRECTANGLE_H
#define HUSRECTANGLE_H

#include "husglobal.h"

#include <QtQuick/QQuickPaintedItem>

QT_FORWARD_DECLARE_CLASS(HusBorder)
QT_FORWARD_DECLARE_CLASS(HusRectanglePrivate)

class HUSKARUI_EXPORT HusRectangle: public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)
    Q_PROPERTY(QJSValue gradient READ gradient WRITE setGradient RESET resetGradient)
    Q_PROPERTY(HusBorder* border READ border CONSTANT)

    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged FINAL)
    Q_PROPERTY(qreal topLeftRadius READ topLeftRadius WRITE setTopLeftRadius NOTIFY topLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal topRightRadius READ topRightRadius WRITE setTopRightRadius NOTIFY topRightRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomLeftRadius READ bottomLeftRadius WRITE setBottomLeftRadius NOTIFY bottomLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomRightRadius READ bottomRightRadius WRITE setBottomRightRadius NOTIFY bottomRightRadiusChanged FINAL)

    QML_NAMED_ELEMENT(HusRectangle)

public:
    explicit HusRectangle(QQuickItem *parent = nullptr);
    ~HusRectangle();

    QColor color() const;
    void setColor(QColor color);

    HusBorder *border();

    QJSValue gradient() const;
    void setGradient(const QJSValue &gradient);
    void resetGradient();

    qreal radius() const;
    void setRadius(qreal radius);

    qreal topLeftRadius() const;
    void setTopLeftRadius(qreal radius);

    qreal topRightRadius() const;
    void setTopRightRadius(qreal radius);

    qreal bottomLeftRadius() const;
    void setBottomLeftRadius(qreal radius);

    qreal bottomRightRadius() const;
    void setBottomRightRadius(qreal radius);

signals:
    void colorChanged();
    void radiusChanged();
    void topLeftRadiusChanged();
    void topRightRadiusChanged();
    void bottomLeftRadiusChanged();
    void bottomRightRadiusChanged();

protected:
    void paint(QPainter *painter) override;

private Q_SLOTS:
    void doUpdate();

private:
    Q_DECLARE_PRIVATE(HusRectangle);
    QSharedPointer<HusRectanglePrivate> d_ptr;
};

#if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
# include <QtQuick/private/qquickrectangle_p.h>

/*! 内部矩形, 作为高版本基础控件时在内部使用, 但无法使用 border.style */
class HusRectangleInternal: public QQuickRectangle
{
    Q_OBJECT

    QML_NAMED_ELEMENT(HusRectangleInternal)

public:
    explicit HusRectangleInternal(QQuickItem *parent = nullptr) : QQuickRectangle{parent} { }
    ~HusRectangleInternal() { }
};

#else

class HusRectangleInternal: public HusRectangle
{
    Q_OBJECT

    QML_NAMED_ELEMENT(HusRectangleInternal)

public:
    explicit HusRectangleInternal(QQuickItem *parent = nullptr) : HusRectangle{parent} { }
    ~HusRectangleInternal() { }
};

#endif

#endif // HUSRECTANGLE_H
