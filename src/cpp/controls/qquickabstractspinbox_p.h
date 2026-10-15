// Copyright (C) 2025 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
// Qt-Security score:significant reason:default

#ifndef QQUICKABSTRACTSPINBOX_P_H
#define QQUICKABSTRACTSPINBOX_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#include <private/qquickcontrol_p_p.h>
#include <private/qquickcontrol_p.h>
#include <private/qquicktheme_p.h>
#include <QtQml/qjsvalue.h>
#include <private/qquickindicatorbutton_p.h>
#include <private/qquickdeferredexecute_p_p.h>
#include <private/qquicktextinput_p.h>
#include <private/qqmlengine_p.h>
#include <QtQml/qqmlinfo.h>
#include <QtGui/private/qlayoutpolicy_p.h>

QT_BEGIN_NAMESPACE

class QValidator;
class QQuickIndicatorButton;

template <typename Derived, typename ValueType>
class QQuickAbstractSpinBox
{
public:
    class QQuickAbstractSpinBoxPrivate : public QQuickControlPrivate
    {
    public:
        // copied from qabstractbutton.cpp
        static constexpr int AUTO_REPEAT_DELAY = 300;
        static constexpr int AUTO_REPEAT_INTERVAL = 100;

        enum ValueStatus { Modified, Unmodified };

        QQuickAbstractSpinBoxPrivate() { }

        Derived *q_func() { return static_cast<Derived *>(q_ptr); }
        const Derived *q_func() const { return static_cast<const Derived *>(q_ptr); }

        ValueType boundValue(ValueType value, bool wrap) const
        {
            bool inverted = from > to;
            if (!wrap)
                return inverted ? qBound(to, value, from) : qBound(from, value, to);

            ValueType f = inverted ? to : from;
            ValueType t = inverted ? from : to;
            if (value < f)
                value = t;
            else if (value > t)
                value = f;

            return value;
        }

        virtual bool setValue(ValueType newValue, bool wrap, ValueStatus modified) = 0;

        bool stepBy(ValueType steps, ValueStatus modified)
        {
            return setValue(value + steps, wrap, modified);
        }

        void increase(ValueStatus modified)
        {
            setValue(value + effectiveStepSize(), wrap, modified);
        }

        void decrease(ValueStatus modified)
        {
            setValue(value - effectiveStepSize(), wrap, modified);
        }

        ValueType effectiveStepSize() const { return from > to ? -1 * stepSize : stepSize; }

        virtual void updateValue() = 0;

        virtual void updateDisplayText() = 0;

        void setDisplayText(const QString &text)
        {
            if (displayText == text)
                return;

            displayText = text;
            emit q_func()->displayTextChanged();
        }

        bool upEnabled() const
        {
            const QQuickItem *upIndicator = up->indicator();
            return upIndicator && upIndicator->isEnabled();
        }

        void updateUpEnabled()
        {
            QQuickItem *upIndicator = up->indicator();
            if (!upIndicator)
                return;

            upIndicator->setEnabled(wrap || (from < to ? value < to : value > to));
        }

        bool downEnabled() const
        {
            const QQuickItem *downIndicator = down->indicator();
            return downIndicator && downIndicator->isEnabled();
        }

        void updateDownEnabled()
        {
            QQuickItem *downIndicator = down->indicator();
            if (!downIndicator)
                return;

            downIndicator->setEnabled(wrap || (from < to ? value > from : value < from));
        }

        void updateHover(const QPointF &pos)
        {
            QQuickItem *ui = up->indicator();
            QQuickItem *di = down->indicator();
            up->setHovered(ui && ui->isEnabled() && ui->contains(q_func()->mapToItem(ui, pos)));
            down->setHovered(di && di->isEnabled() && di->contains(q_func()->mapToItem(di, pos)));
        }

        void startRepeatDelay()
        {
            stopPressRepeat();
            delayTimer = q_func()->startTimer(AUTO_REPEAT_DELAY);
        }

        void startPressRepeat()
        {
            stopPressRepeat();
            repeatTimer = q_func()->startTimer(AUTO_REPEAT_INTERVAL);
        }

        void stopPressRepeat()
        {
            if (delayTimer > 0) {
                q_func()->killTimer(delayTimer);
                delayTimer = 0;
            }
            if (repeatTimer > 0) {
                q_func()->killTimer(repeatTimer);
                repeatTimer = 0;
            }
        }

        bool handlePress(const QPointF &point, ulong timestamp) override
        {
            QQuickControlPrivate::handlePress(point, timestamp);

            QQuickItem *ui = up->indicator();
            QQuickItem *di = down->indicator();
            up->setPressed(ui && ui->isEnabled() && ui->contains(ui->mapFromItem(q_func(), point)));
            down->setPressed(di && di->isEnabled()
                             && di->contains(di->mapFromItem(q_func(), point)));

            bool pressed = up->isPressed() || down->isPressed();
            q_func()->setAccessibleProperty("pressed", pressed);
            if (pressed)
                startRepeatDelay();
            return true;
        }

        bool handleMove(const QPointF &point, ulong timestamp) override
        {
            QQuickControlPrivate::handleMove(point, timestamp);
            QQuickItem *upIndicator = up->indicator();
            const bool upIndicatorContainsPoint = upIndicator && upIndicator->isEnabled()
                    && upIndicator->contains(upIndicator->mapFromItem(q_func(), point));
            up->setHovered(QQuickControlPrivate::touchId == -1 && upIndicatorContainsPoint);
            up->setPressed(upIndicatorContainsPoint);

            QQuickItem *downIndicator = down->indicator();
            const bool downIndicatorContainsPoint = downIndicator && downIndicator->isEnabled()
                    && downIndicator->contains(downIndicator->mapFromItem(q_func(), point));
            down->setHovered(QQuickControlPrivate::touchId == -1 && downIndicatorContainsPoint);
            down->setPressed(downIndicatorContainsPoint);

            bool pressed = up->isPressed() || down->isPressed();
            q_func()->setAccessibleProperty("pressed", pressed);
            if (!pressed)
                stopPressRepeat();
            return true;
        }

        bool handleRelease(const QPointF &point, ulong timestamp) override
        {
            QQuickControlPrivate::handleRelease(point, timestamp);
            QQuickItem *ui = up->indicator();
            QQuickItem *di = down->indicator();

            double oldValue = value;
            if (up->isPressed()) {
                if (repeatTimer <= 0 && ui && ui->contains(ui->mapFromItem(q_func(), point)))
                    q_func()->increase();
                // Retain pressed state until after increasing is done in case user code binds
                // stepSize to up/down.pressed.
                up->setPressed(false);
            } else if (down->isPressed()) {
                if (repeatTimer <= 0 && di && di->contains(di->mapFromItem(q_func(), point)))
                    q_func()->decrease();
                down->setPressed(false);
            }
            if (value != oldValue)
                emit q_func()->valueModified();

            q_func()->setAccessibleProperty("pressed", false);
            stopPressRepeat();
            return true;
        }

        void handleUngrab() override
        {
            QQuickControlPrivate::handleUngrab();
            up->setPressed(false);
            down->setPressed(false);

            q_func()->setAccessibleProperty("pressed", false);
            stopPressRepeat();
        }

        void itemImplicitWidthChanged(QQuickItem *item) override
        {
            QQuickControlPrivate::itemImplicitWidthChanged(item);
            if (item == up->indicator())
                emit up->implicitIndicatorWidthChanged();
            else if (item == down->indicator())
                emit down->implicitIndicatorWidthChanged();
        }

        void itemImplicitHeightChanged(QQuickItem *item) override
        {
            QQuickControlPrivate::itemImplicitHeightChanged(item);
            if (item == up->indicator())
                emit up->implicitIndicatorHeightChanged();
            else if (item == down->indicator())
                emit down->implicitIndicatorHeightChanged();
        }

        void itemDestroyed(QQuickItem *item) override
        {
            QQuickControlPrivate::itemDestroyed(item);
            if (item == up->indicator())
                up->setIndicator(nullptr);
            else if (item == down->indicator())
                down->setIndicator(nullptr);
        }

        QPalette defaultPalette() const override
        {
            return QQuickTheme::palette(QQuickTheme::SpinBox);
        }

        bool editable = false;
        bool wrap = false;
        ValueType from; // please set it in derived class constructor
        ValueType to; // please set it in derived class constructor
        ValueType value = 0;
        ValueType stepSize = 1;
        int delayTimer = 0;
        int repeatTimer = 0;
        QString displayText;
        QQuickIndicatorButton *up = nullptr;
        QQuickIndicatorButton *down = nullptr;
#if QT_CONFIG(validator)
        QValidator *validator = nullptr;
#endif
        mutable QJSValue textFromValue;
        mutable QJSValue valueFromText;
        Qt::InputMethodHints inputMethodHints = Qt::ImhDigitsOnly;
    };

private:
    QQuickAbstractSpinBoxPrivate *d_func()
    {
        auto *derived = static_cast<Derived *>(this);
        return static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
    }

    const QQuickAbstractSpinBoxPrivate *d_func() const
    {
        const auto *derived = static_cast<const Derived *>(this);
        return static_cast<const QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
    }

public:
    ValueType from() const
    {
        return d_func()->from;
    }

    ValueType to() const
    {
        return d_func()->to;
    }

    ValueType value() const
    {
        return d_func()->value;
    }

    ValueType stepSize() const
    {
        return d_func()->stepSize;
    }

    bool isEditable() const
    {
        return d_func()->editable;
    }

    void setEditable(bool editable)
    {
        auto *derived = static_cast<Derived *>(this);
        auto *d = static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        if (d->editable == editable)
            return;

#if QT_CONFIG(cursor)
        if (d->contentItem) {
            if (editable)
                d->contentItem->setCursor(Qt::IBeamCursor);
            else
                d->contentItem->unsetCursor();
        }
#endif

        d->editable = editable;
        d->q_func()->setAccessibleProperty("editable", editable);
        emit derived->editableChanged();
    }

#if QT_CONFIG(validator)
    QValidator *validator() const
    {
        return d_func()->validator;
    }

    void setValidator(QValidator *validator)
    {
        auto *derived = static_cast<Derived *>(this);
        auto *d = static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        if (d->validator == validator)
            return;

        d->validator = validator;
        emit derived->validatorChanged();
    }
#endif

    void setTextFromValue(const QJSValue &callback)
    {
        auto *derived = static_cast<Derived *>(this);
        auto *d = static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        if (!callback.isCallable()) {
            qmlWarning(derived) << "textFromValue must be a callable function";
            return;
        }
        d->textFromValue = callback;
        emit derived->textFromValueChanged();
    }

    void setValueFromText(const QJSValue &callback)
    {
        auto *derived = static_cast<Derived *>(this);
        auto *d = static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        if (!callback.isCallable()) {
            qmlWarning(derived) << "valueFromText must be a callable function";
            return;
        }
        d->valueFromText = callback;
        emit derived->valueFromTextChanged();
    }

    QQuickIndicatorButton *up() const
    {
        auto *derived = static_cast<const Derived *>(this);
        auto *d = static_cast<const QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        return d->up;
    }

    QQuickIndicatorButton *down() const
    {
        auto *derived = static_cast<const Derived *>(this);
        auto *d = static_cast<const QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        return d->down;
    }

    Qt::InputMethodHints inputMethodHints() const
    {
        auto *derived = static_cast<const Derived *>(this);
        auto *d = static_cast<const QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        return d->inputMethodHints;
    }

    void setInputMethodHints(Qt::InputMethodHints hints)
    {
        auto *derived = static_cast<Derived *>(this);
        auto *d = static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        if (d->inputMethodHints == hints)
            return;

        d->inputMethodHints = hints;
        emit derived->inputMethodHintsChanged();
    }

    bool isInputMethodComposing() const
    {
        auto *derived = static_cast<const Derived *>(this);
        auto *d = static_cast<const QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        return d->contentItem && d->contentItem->property("inputMethodComposing").toBool();
    }

    bool wrap() const
    {
        return d_func()->wrap;
    }

    QString displayText() const
    {
        return d_func()->displayText;
    }

public:
    virtual void increase()
    {
        d_func()->increase(QQuickAbstractSpinBoxPrivate::ValueStatus::Unmodified);
    }

    virtual void decrease()
    {
        d_func()->decrease(QQuickAbstractSpinBoxPrivate::ValueStatus::Unmodified);
    }

protected:
    void handleFocusInEvent(QFocusEvent *event)
    {
        auto *d = d_func();

        // When an editable derived SpinBox gets focus, it must pass on the focus to its editor.
        if (d->editable && d->contentItem && !d->contentItem->hasActiveFocus())
            d->contentItem->forceActiveFocus(event->reason());
    }

    void handleHoverEnterEvent(QHoverEvent *event)
    {
        auto *d = d_func();

        d->updateHover(event->position());
        event->ignore();
    }

    void handleHoverMoveEvent(QHoverEvent *event)
    {
        auto *d = d_func();

        d->updateHover(event->position());
        event->ignore();
    }

    void handleHoverLeaveEvent(QHoverEvent *event)
    {
        auto *d = d_func();

        d->down->setHovered(false);
        d->up->setHovered(false);
        event->ignore();
    }

    void handleKeyPressEvent(QKeyEvent *event)
    {
        auto *d = d_func();

        switch (event->key()) {
        case Qt::Key_Up:
            if (d->upEnabled()) {
                // Update the pressed state before increasing/decreasing in case user code binds
                // stepSize to up/down.pressed.
                d->up->setPressed(true);
                d->increase(QQuickAbstractSpinBoxPrivate::ValueStatus::Modified);
                event->accept();
            }
            break;

        case Qt::Key_Down:
            if (d->downEnabled()) {
                d->down->setPressed(true);
                d->decrease(QQuickAbstractSpinBoxPrivate::ValueStatus::Modified);
                event->accept();
            }
            break;

        default:
            break;
        }

        d->q_func()->setAccessibleProperty("pressed", d->up->isPressed() || d->down->isPressed());
    }

    void handleKeyReleaseEvent(QKeyEvent *event)
    {
        auto *d = d_func();

        if (d->editable && (event->key() == Qt::Key_Enter || event->key() == Qt::Key_Return))
            d->updateValue();

        d->up->setPressed(false);
        d->down->setPressed(false);
        d->q_func()->setAccessibleProperty("pressed", false);
    }

    void handleTimerEvent(QTimerEvent *event)
    {
        auto *d = d_func();

        if (event->timerId() == d->delayTimer) {
            d->startPressRepeat();
        } else if (event->timerId() == d->repeatTimer) {
            if (d->up->isPressed())
                d->increase(QQuickAbstractSpinBoxPrivate::ValueStatus::Modified);
            else if (d->down->isPressed())
                d->decrease(QQuickAbstractSpinBoxPrivate::ValueStatus::Modified);
        }
    }

#if QT_CONFIG(wheelevent)
    void handleWheelEvent(QWheelEvent *event)
    {
        auto *d = d_func();

        if (d->wheelEnabled) {
            const QPointF angle = event->angleDelta();
            const qreal delta = (qFuzzyIsNull(angle.y()) ? angle.x() : angle.y())
                    / int(QWheelEvent::DefaultDeltasPerStep);
            d->stepBy(d->effectiveStepSize() * delta,
                      QQuickAbstractSpinBoxPrivate::ValueStatus::Modified);
        }
    }
#endif

    void handleClassBegin()
    {
        auto *derived = static_cast<Derived *>(this);
        auto *d = static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());

        QQmlContext *context = qmlContext(derived);
        if (context) {
            QQmlEngine::setContextForObject(d->up, context);
            QQmlEngine::setContextForObject(d->down, context);
        }
    }

    void handleComponentComplete()
    {
        auto *d = d_func();

        auto *upPrivate = QQuickIndicatorButtonPrivate::get(d->up);
        if (!upPrivate->indicator.wasExecuted())
            quickCompleteDeferred(d->up, QStringLiteral("indicator"), upPrivate->indicator);

        auto *downPrivate = QQuickIndicatorButtonPrivate::get(d->down);
        if (!downPrivate->indicator.wasExecuted())
            quickCompleteDeferred(d->down, QStringLiteral("indicator"), downPrivate->indicator);

        if (!d->setValue(d->value, false /* wrap */,
                         QQuickAbstractSpinBoxPrivate::ValueStatus::Unmodified)) {
            d->updateDisplayText();
            d->updateUpEnabled();
            d->updateDownEnabled();
        }
    }

    void handleItemChange(QQuickItem::ItemChange change, const QQuickItem::ItemChangeData &value)
    {
        auto *d = d_func();
        if (d->editable && change == QQuickItem::ItemActiveFocusHasChanged && !value.boolValue)
            d->updateValue();
    }

    void handleLocaleChange()
    {
        auto *d = d_func();
        d->updateDisplayText();
    }

    QFont defaultFont() const { return QQuickTheme::font(QQuickTheme::SpinBox); }

#if QT_CONFIG(accessibility)
    QAccessible::Role accessibleRole() const { return QAccessible::SpinBox; }

    void handleAccessibilityActiveChanged(bool active)
    {
        auto *d = d_func();

        if (active)
            d->q_func()->setAccessibleProperty("editable", d->editable);
    }
#endif

protected:
    QQuickAbstractSpinBox()
    {
        auto *derived = static_cast<Derived *>(this);
        auto *d = static_cast<QQuickAbstractSpinBoxPrivate *>(derived->d_base_func());
        d->up = new QQuickIndicatorButton(derived);
        d->down = new QQuickIndicatorButton(derived);
        d->setSizePolicy(QLayoutPolicy::Preferred, QLayoutPolicy::Fixed);

        derived->setFlag(QQuickItem::ItemIsFocusScope);
        derived->setFiltersChildMouseEvents(true);
        derived->setAcceptedMouseButtons(Qt::LeftButton);
#if QT_CONFIG(cursor)
        derived->setCursor(Qt::ArrowCursor);
#endif
#if QT_CONFIG(quicktemplates2_multitouch)
        derived->setAcceptTouchEvents(true);
#endif
    }

    ~QQuickAbstractSpinBox()
    {
        auto *d = d_func();
        d->removeImplicitSizeListener(d->up->indicator());
        d->removeImplicitSizeListener(d->down->indicator());
    }

    // Non-copyable
    QQuickAbstractSpinBox(const QQuickAbstractSpinBox &) = delete;
    QQuickAbstractSpinBox &operator=(const QQuickAbstractSpinBox &) = delete;
};

QT_END_NAMESPACE

#endif // QQUICKABSTRACTSPINBOX_P_H
