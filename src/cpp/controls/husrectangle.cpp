#include "husrectangle.h"

#include <QtGui/QPainter>
#include <QtGui/QPainterPath>

#include <private/qqmlglobal_p.h>

class HusRectanglePrivate
{
public:
    QColor m_color = { 0xffffff };
    HusPen *m_pen = nullptr;
    qreal m_radius = 0;
    qreal m_topLeftRadius = 0;
    qreal m_topRightRadius = 0;
    qreal m_bottomLeftRadius = 0;
    qreal m_bottomRightRadius = 0;
};

HusRectangle::HusRectangle(QQuickItem *parent)
    : QQuickPaintedItem{parent}
    , d_ptr(new HusRectanglePrivate)
{

}

HusRectangle::~HusRectangle()
{

}

qreal HusRectangle::radius() const
{
    Q_D(const HusRectangle);

    return d->m_radius;
}

void HusRectangle::setRadius(qreal radius)
{
    Q_D(HusRectangle);

    if (d->m_radius != radius) {
        d->m_radius = radius;
        d->m_topLeftRadius = radius;
        d->m_topRightRadius = radius;
        d->m_bottomLeftRadius = radius;
        d->m_bottomRightRadius = radius;
        emit radiusChanged();
        emit topLeftRadiusChanged();
        emit topRightRadiusChanged();
        emit bottomLeftRadiusChanged();
        emit bottomRightRadiusChanged();
        update();
    }
}

qreal HusRectangle::topLeftRadius() const
{
    Q_D(const HusRectangle);

    return d->m_topLeftRadius;
}

void HusRectangle::setTopLeftRadius(qreal radius)
{
    Q_D(HusRectangle);

    if (d->m_topLeftRadius != radius) {
        d->m_topLeftRadius = radius;
        emit topLeftRadiusChanged();
        update();
    }
}

qreal HusRectangle::topRightRadius() const
{
    Q_D(const HusRectangle);

    return d->m_topRightRadius;
}

void HusRectangle::setTopRightRadius(qreal radius)
{
    Q_D(HusRectangle);

    if (d->m_topRightRadius != radius) {
        d->m_topRightRadius = radius;
        emit topRightRadiusChanged();
        update();
    }
}

qreal HusRectangle::bottomLeftRadius() const
{
    Q_D(const HusRectangle);

    return d->m_bottomLeftRadius;
}

void HusRectangle::setBottomLeftRadius(qreal radius)
{
    Q_D(HusRectangle);

    if (d->m_bottomLeftRadius != radius) {
        d->m_bottomLeftRadius = radius;
        emit bottomLeftRadiusChanged();
        update();
    }
}

qreal HusRectangle::bottomRightRadius() const
{
    Q_D(const HusRectangle);

    return d->m_bottomRightRadius;
}

void HusRectangle::setBottomRightRadius(qreal radius)
{
    Q_D(HusRectangle);

    if (d->m_bottomRightRadius != radius) {
        d->m_bottomRightRadius = radius;
        emit bottomRightRadiusChanged();
        update();
    }
}

QColor HusRectangle::color() const
{
    Q_D(const HusRectangle);

    return d->m_color;
}

void HusRectangle::setColor(QColor color)
{
    Q_D(HusRectangle);

    if (d->m_color != color) {
        d->m_color = color;
        emit colorChanged();
        update();
    }
}

HusPen *HusRectangle::border()
{
    Q_D(HusRectangle);

    if (!d->m_pen) {
        d->m_pen = new HusPen;
        QQml_setParent_noEvent(d->m_pen, this);
        connect(d->m_pen, &HusPen::colorChanged, this, [this]{ update(); });
        connect(d->m_pen, &HusPen::widthChanged, this, [this]{ update(); });
        connect(d->m_pen, &HusPen::styleChanged, this, [this]{ update(); });
        update();
    }

    return d->m_pen;
}

void HusRectangle::paint(QPainter *painter)
{
    Q_D(HusRectangle);

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    auto rect = boundingRect();
    if (d->m_pen && d->m_pen->isValid()) {
        rect = boundingRect();
        if (rect.width() > d->m_pen->width() * 2) {
            auto dx = d->m_pen->width() * 0.5;
            rect.adjust(dx, 0, -dx, 0);
        }
        if (rect.height() > d->m_pen->width() * 2) {
            auto dy = d->m_pen->width() * 0.5;
            rect.adjust(0, dy, 0, -dy);
        }
        painter->setPen(QPen(d->m_pen->color(), d->m_pen->width(), Qt::PenStyle(d->m_pen->style()), Qt::SquareCap, Qt::SvgMiterJoin));
    } else {
        painter->setPen(QPen(Qt::transparent));
    }

    auto maxRadius = height() * 0.5;
    auto topLeftRadius = std::min(d->m_topLeftRadius, maxRadius);
    auto topRightRadius = std::min(d->m_topRightRadius, maxRadius);
    auto bottomLeftRadius = std::min(d->m_bottomLeftRadius, maxRadius);
    auto bottomRightRadius = std::min(d->m_bottomRightRadius, maxRadius);

    QPainterPath path;
    path.moveTo(rect.bottomRight() - QPointF(0, bottomRightRadius));
    path.lineTo(rect.topRight() + QPointF(0, topRightRadius));
    path.arcTo(QRectF(QPointF(rect.topRight() - QPointF(topRightRadius * 2, 0)),
                      QSize(topRightRadius * 2, topRightRadius * 2)), 0, 90);
    path.lineTo(rect.topLeft() + QPointF(topLeftRadius, 0));
    path.arcTo(QRectF(QPointF(rect.topLeft()), QSize(topLeftRadius * 2, topLeftRadius * 2)), 90, 90);
    path.lineTo(rect.bottomLeft() - QPointF(0, bottomLeftRadius));
    path.arcTo(QRectF(QPointF(rect.bottomLeft().x(), rect.bottomLeft().y() - bottomLeftRadius * 2),
                      QSize(bottomLeftRadius * 2, bottomLeftRadius * 2)), 180, 90);
    path.lineTo(rect.bottomRight() - QPointF(bottomRightRadius, 0));
    path.arcTo(QRectF(QPointF(rect.bottomRight() - QPointF(bottomRightRadius * 2, bottomRightRadius * 2)),
                      QSize(bottomRightRadius * 2, bottomRightRadius * 2)), 270, 90);

    painter->setBrush(d->m_color);

    painter->drawPath(path);

    painter->restore();
}
