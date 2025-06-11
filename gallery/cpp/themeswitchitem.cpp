#include "themeswitchitem.h"

#include <QGuiApplication>
#include <QPropertyAnimation>
#include <QPainter>
#include <QPainterPath>
#include <QQuickItemGrabResult>

ThemeSwitchItem::ThemeSwitchItem(QQuickItem *parent)
    : QQuickPaintedItem{parent}
    , m_isDark{false}
    , m_target{nullptr}
    , m_radius{0}
    , m_duration{300}
{
    m_animation = new QPropertyAnimation(this, "radius", this);
    m_animation->setDuration(m_duration);
    m_animation->setEasingCurve(QEasingCurve::OutCubic);

    setVisible(false);

    connect(m_animation, &QPropertyAnimation::finished, this, [this] {
        update();
        setVisible(false);
        emit animationFinished();
    });
    connect(this, &ThemeSwitchItem::radiusChanged, this, &QQuickItem::update);
    connect(this, &ThemeSwitchItem::durationChanged, this, [this] { m_animation->setDuration(m_duration); });
}

void ThemeSwitchItem::paint(QPainter *painter)
{
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    painter->drawImage(QRect(0, 0, width(), height()), m_source);

    QPainterPath path;
    path.moveTo(m_center.x(), m_center.y());
    path.addEllipse(QPointF(m_center.x(), m_center.y()), m_radius, m_radius);

    painter->setCompositionMode(QPainter::CompositionMode_Xor);
    if (m_isDark) {
        painter->fillPath(path, m_colorBg);
    } else {
        QPainterPath outerRect;
        outerRect.addRect(0, 0, width(), height());
        outerRect = outerRect.subtracted(path);
        painter->fillPath(outerRect, m_colorBg);
    }

    painter->restore();
}

void ThemeSwitchItem::start(int width, int height, const QPoint &center, int radius)
{
    if (!m_target) return;

    if (m_animation->state() == QAbstractAnimation::Running) {
        m_animation->stop();
        int currentRadius = m_radius;
        m_animation->setStartValue(currentRadius);
        m_animation->setEndValue(m_isDark ? 0 : radius);
    } else {
        if (m_isDark) {
            m_animation->setStartValue(radius);
            m_animation->setEndValue(0);
        } else {
            m_animation->setStartValue(0);
            m_animation->setEndValue(radius);
        }
    }

    m_center = center;
    m_grabResult = m_target->grabToImage(QSize(width, height));
    connect(m_grabResult.data(), &QQuickItemGrabResult::ready, this, [this] {
        m_source = m_grabResult.data()->image();
        update();
        setVisible(true);
        emit switchStarted();
        m_animation->start();
    });
}
