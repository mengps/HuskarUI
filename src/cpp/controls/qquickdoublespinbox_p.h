// Copyright (C) 2025 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
// Qt-Security score:significant reason:default

#ifndef QQUICKDOUBLESPINBOX_P_H
#define QQUICKDOUBLESPINBOX_P_H

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

#include <qquickabstractspinbox_p.h>
#include <QtQuickTemplates2/private/qquickcontrol_p.h>
#include <QtQml/qjsvalue.h>

QT_BEGIN_NAMESPACE

class QValidator;
class QQuickDoubleSpinBoxPrivate;
class QQuickIndicatorButton;

class QQuickDoubleSpinBox
    : public QQuickControl,
      public QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>
{
    Q_OBJECT
    Q_PROPERTY(double from READ from WRITE setFrom NOTIFY fromChanged FINAL)
    Q_PROPERTY(double to READ to WRITE setTo NOTIFY toChanged FINAL)
    Q_PROPERTY(double value READ value WRITE setValue NOTIFY valueChanged FINAL)
    Q_PROPERTY(double stepSize READ stepSize WRITE setStepSize NOTIFY stepSizeChanged FINAL)
    Q_PROPERTY(int decimals READ decimals WRITE setDecimals NOTIFY decimalsChanged FINAL)
    Q_PROPERTY(bool editable READ isEditable WRITE setEditable NOTIFY editableChanged FINAL)
    QML_NAMED_ELEMENT(DoubleSpinBox)

#if QT_CONFIG(validator)
    Q_PROPERTY(QValidator *validator READ validator WRITE setValidator
        NOTIFY validatorChanged FINAL)
#endif
    Q_PROPERTY(QJSValue textFromValue READ textFromValue WRITE setTextFromValue
        NOTIFY textFromValueChanged FINAL)
    Q_PROPERTY(QJSValue valueFromText READ valueFromText WRITE setValueFromText
        NOTIFY valueFromTextChanged FINAL)
    Q_PROPERTY(QQuickIndicatorButton *up READ up CONSTANT FINAL)
    Q_PROPERTY(QQuickIndicatorButton *down READ down CONSTANT FINAL)
    Q_PROPERTY(Qt::InputMethodHints inputMethodHints READ inputMethodHints WRITE setInputMethodHints
        NOTIFY inputMethodHintsChanged FINAL)
    Q_PROPERTY(bool inputMethodComposing READ isInputMethodComposing
        NOTIFY inputMethodComposingChanged FINAL)
  Q_PROPERTY(bool wrap READ wrap WRITE setWrap NOTIFY wrapChanged FINAL)
    Q_PROPERTY(QString displayText READ displayText NOTIFY displayTextChanged FINAL)

public:
    explicit QQuickDoubleSpinBox(QQuickItem *parent = nullptr);
    ~QQuickDoubleSpinBox();

    void setFrom(double from);

    void setTo(double to);

    void setValue(double value);

    void setStepSize(double step);

    int decimals() const;
    void setDecimals(int prec);

    QJSValue textFromValue() const;

    QJSValue valueFromText() const;

    void setWrap(bool wrap);

public Q_SLOTS:
    void increase() override;
    void decrease() override;

Q_SIGNALS:
    void fromChanged();
    void toChanged();
    void valueChanged();
    void stepSizeChanged();
    void decimalsChanged();
    void editableChanged();
#if QT_CONFIG(validator)
    void validatorChanged();
#endif
    void textFromValueChanged();
    void valueFromTextChanged();
    void valueModified();
    void inputMethodHintsChanged();
    void inputMethodComposingChanged();
    void wrapChanged();
    void displayTextChanged();

protected:
    void focusInEvent(QFocusEvent *event) override
    {
        QQuickControl::focusInEvent(event);
        handleFocusInEvent(event);
    }
    void hoverEnterEvent(QHoverEvent *event) override
    {
        QQuickControl::hoverEnterEvent(event);
        handleHoverEnterEvent(event);
    }
    void hoverMoveEvent(QHoverEvent *event) override
    {
        QQuickControl::hoverMoveEvent(event);
        handleHoverMoveEvent(event);
    }
    void hoverLeaveEvent(QHoverEvent *event) override
    {
        QQuickControl::hoverLeaveEvent(event);
        handleHoverLeaveEvent(event);
    }
    void keyPressEvent(QKeyEvent *event) override
    {
        QQuickControl::keyPressEvent(event);
        handleKeyPressEvent(event);
    }
    void keyReleaseEvent(QKeyEvent *event) override
    {
        QQuickControl::keyReleaseEvent(event);
        handleKeyReleaseEvent(event);
    }
    void timerEvent(QTimerEvent *event) override
    {
        QQuickControl::timerEvent(event);
        handleTimerEvent(event);
    }
#if QT_CONFIG(wheelevent)
    void wheelEvent(QWheelEvent *event) override
    {
        QQuickControl::wheelEvent(event);
        handleWheelEvent(event);
    }
#endif
    void classBegin() override
    {
        QQuickControl::classBegin();
        handleClassBegin();
    }
    void componentComplete() override
    {
        QQuickControl::componentComplete();
        handleComponentComplete();
    }
    void itemChange(ItemChange change, const ItemChangeData &value) override
    {
        QQuickControl::itemChange(change, value);
        handleItemChange(change, value);
    }
    void contentItemChange(QQuickItem *newItem, QQuickItem *oldItem) override;
    void localeChange(const QLocale &newLocale, const QLocale &oldLocale) override
    {
        QQuickControl::localeChange(newLocale, oldLocale);
        handleLocaleChange();
    }
    QFont defaultFont() const override
    {
        return QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>::defaultFont();
    }
#if QT_CONFIG(accessibility)
    QAccessible::Role accessibleRole() const override
    {
        return QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>::accessibleRole();
    }
    void accessibilityActiveChanged(bool active) override
    {
        QQuickControl::accessibilityActiveChanged(active);
        handleAccessibilityActiveChanged(active);
    }
#endif

private:
    Q_DISABLE_COPY(QQuickDoubleSpinBox)
    Q_DECLARE_PRIVATE(QQuickDoubleSpinBox)
    friend class QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>;
    QQuickControlPrivate *d_base_func();
    const QQuickControlPrivate *d_base_func() const;
};

QT_END_NAMESPACE

#endif // QQUICKDOUBLESPINBOX_P_H
