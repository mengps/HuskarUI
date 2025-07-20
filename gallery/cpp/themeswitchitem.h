#ifndef THEMESWITCHITEM_H
#define THEMESWITCHITEM_H

#include <QImage>
#include <QQuickPaintedItem>

#include "husdefinitions.h"

QT_FORWARD_DECLARE_CLASS(QPropertyAnimation)

class ThemeSwitchItem : public QQuickPaintedItem
{
    Q_OBJECT
    QML_NAMED_ELEMENT(ThemeSwitchItem)

    HUS_PROPERTY(int, radius, setRadius)
    HUS_PROPERTY(int, duration, setDuration)
    HUS_PROPERTY(QColor, colorBg, setColorBg)
    HUS_PROPERTY(bool, isDark, setIsDark)
    HUS_PROPERTY_P(QQuickItem*, target, setTarget)

public:
    explicit ThemeSwitchItem(QQuickItem *parent = nullptr);

    Q_INVOKABLE void start(int width, int height, const QPoint &center, int radius);

signals:
    void switchStarted();
    void animationFinished();

protected:
    void paint(QPainter *painter) override;

private:
    QImage m_source;
    QPoint m_center;
    QSharedPointer<QQuickItemGrabResult> m_grabResult;
    QPropertyAnimation *m_animation { nullptr };
};

#endif // THEMESWITCHITEM_H
