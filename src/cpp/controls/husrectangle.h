#ifndef HUSRECTANGLE_H
#define HUSRECTANGLE_H

#include <QtQuick/QQuickPaintedItem>

#include "husglobal.h"
#include "husdefinitions.h"

QT_FORWARD_DECLARE_CLASS(HusRectanglePrivate)

class HUSKARUI_EXPORT HusPen: public QObject
{
    Q_OBJECT

    HUS_PROPERTY_INIT(qreal, width, setWidth, 1)
    HUS_PROPERTY_INIT(QColor, color, setColor, Qt::transparent)
    HUS_PROPERTY_INIT(int, style, setStyle, Qt::SolidLine)

    QML_NAMED_ELEMENT(HusPen)

public:
    HusPen(QObject *parent = nullptr) : QObject{parent} { }

    bool isValid() const {
        return m_width > 0 && m_color.isValid() && m_color.alpha() > 0;
    }
};

class HUSKARUI_EXPORT HusRectangle: public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged FINAL)
    Q_PROPERTY(qreal topLeftRadius READ topLeftRadius WRITE setTopLeftRadius NOTIFY topLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal topRightRadius READ topRightRadius WRITE setTopRightRadius NOTIFY topRightRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomLeftRadius READ bottomLeftRadius WRITE setBottomLeftRadius NOTIFY bottomLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomRightRadius READ bottomRightRadius WRITE setBottomRightRadius NOTIFY bottomRightRadiusChanged FINAL)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)
    Q_PROPERTY(HusPen* border READ border CONSTANT)

    QML_NAMED_ELEMENT(HusRectangle)

public:
    explicit HusRectangle(QQuickItem *parent = nullptr);
    ~HusRectangle();

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

    QColor color() const;
    void setColor(QColor color);

    HusPen *border();

protected:
    void paint(QPainter *painter) override;

signals:
    void radiusChanged();
    void topLeftRadiusChanged();
    void topRightRadiusChanged();
    void bottomLeftRadiusChanged();
    void bottomRightRadiusChanged();
    void colorChanged();

private:
    Q_DECLARE_PRIVATE(HusRectangle);
    QSharedPointer<HusRectanglePrivate> d_ptr;
};

#endif // HUSRECTANGLE_H
