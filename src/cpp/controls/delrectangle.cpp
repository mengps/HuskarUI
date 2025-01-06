#include "delrectangle.h"

#include <QPainter>
#include <QPainterPath>

#include <private/qqmlglobal_p.h>

class DelRectanglePrivate
{
public:
    QColor m_color = { 0xffffff };
    DelPen *m_pen = nullptr;
    qreal m_radius = 0;
    qreal m_topLeftRadius = 0;
    qreal m_topRightRadius = 0;
    qreal m_bottomLeftRadius = 0;
    qreal m_bottomRightRadius = 0;
};

DelRectangle::DelRectangle(QQuickItem *parent)
    : QQuickPaintedItem{parent}
    , d_ptr(new DelRectanglePrivate)
{

}

DelRectangle::~DelRectangle()
{

}

qreal DelRectangle::radius() const
{
    Q_D(const DelRectangle);

    return d->m_radius;
}

void DelRectangle::setRadius(qreal radius)
{
    Q_D(DelRectangle);

    if (d->m_radius != radius) {
        d->m_radius = radius;
        emit radiusChanged();
        update();
    }
}

qreal DelRectangle::topLeftRadius() const
{
    Q_D(const DelRectangle);

    return d->m_topLeftRadius;
}

void DelRectangle::setTopLeftRadius(qreal radius)
{
    Q_D(DelRectangle);

    if (d->m_topLeftRadius != radius) {
        d->m_topLeftRadius = radius;
        emit topLeftRadiusChanged();
        update();
    }
}

qreal DelRectangle::topRightRadius() const
{
    Q_D(const DelRectangle);

    return d->m_topRightRadius;
}

void DelRectangle::setTopRightRadius(qreal radius)
{
    Q_D(DelRectangle);

    if (d->m_topRightRadius != radius) {
        d->m_topRightRadius = radius;
        emit topRightRadiusChanged();
        update();
    }
}

qreal DelRectangle::bottomLeftRadius() const
{
    Q_D(const DelRectangle);

    return d->m_bottomLeftRadius;
}

void DelRectangle::setBottomLeftRadius(qreal radius)
{
    Q_D(DelRectangle);

    if (d->m_bottomLeftRadius != radius) {
        d->m_bottomLeftRadius = radius;
        emit bottomLeftRadiusChanged();
        update();
    }
}

qreal DelRectangle::bottomRightRadius() const
{
    Q_D(const DelRectangle);

    return d->m_bottomRightRadius;
}

void DelRectangle::setBottomRightRadius(qreal radius)
{
    Q_D(DelRectangle);

    if (d->m_bottomRightRadius != radius) {
        d->m_bottomRightRadius = radius;
        emit bottomRightRadiusChanged();
        update();
    }
}

QColor DelRectangle::color() const
{
    Q_D(const DelRectangle);

    return d->m_color;
}

void DelRectangle::setColor(QColor color)
{
    Q_D(DelRectangle);

    if (d->m_color != color) {
        d->m_color = color;
        emit colorChanged();
        update();
    }
}

DelPen *DelRectangle::border()
{
    Q_D(DelRectangle);

    if (!d->m_pen) {
        d->m_pen = new DelPen;
        QQml_setParent_noEvent(d->m_pen, this);
        connect(d->m_pen, &DelPen::colorChanged, this, [this]{ update(); });
        connect(d->m_pen, &DelPen::widthChanged, this, [this]{ update(); });
        update();
    }

    return d->m_pen;
}

void DelRectangle::paint(QPainter *painter)
{
    Q_D(DelRectangle);

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    QPainterPath path;
    QRectF rect = boundingRect();
    path.moveTo(rect.bottomRight() - QPointF(0, d->m_bottomRightRadius));
    path.lineTo(rect.topRight() + QPointF(0, d->m_topRightRadius));
    path.arcTo(QRectF(QPointF(rect.topRight() - QPointF(d->m_topRightRadius * 2, 0)),
                      QSize(d->m_topRightRadius * 2, d->m_topRightRadius * 2)), 0, 90);
    path.lineTo(rect.topLeft() + QPointF(d->m_topLeftRadius, 0));
    path.arcTo(QRectF(QPointF(rect.topLeft()), QSize(d->m_topLeftRadius * 2, d->m_topLeftRadius * 2)), 90, 90);
    path.lineTo(rect.bottomLeft() - QPointF(0, d->m_bottomLeftRadius));
    path.arcTo(QRectF(QPointF(rect.bottomLeft().x(), rect.bottomLeft().y() - d->m_bottomLeftRadius * 2),
                      QSize(d->m_bottomLeftRadius * 2, d->m_bottomLeftRadius * 2)), 180, 90);
    path.lineTo(rect.bottomRight() - QPointF(d->m_bottomRightRadius, 0));
    path.arcTo(QRectF(QPointF(rect.bottomRight() - QPointF(d->m_bottomRightRadius * 2, d->m_bottomRightRadius * 2)),
                      QSize(d->m_bottomRightRadius * 2, d->m_bottomRightRadius * 2)), 270, 90);
    painter->fillPath(path, d->m_color);

    if (d->m_pen) {
        painter->strokePath(path, QPen(d->m_pen->color(), d->m_pen->width()));
    }

    painter->restore();
}
