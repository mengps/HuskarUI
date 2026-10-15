// Copyright (C) 2025 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
// Qt-Security score:significant reason:default

#include "qquickdoublespinbox_p.h"

#include <private/qquickcontrol_p_p.h>
#include <private/qquickindicatorbutton_p.h>
#include <private/qquicktextinput_p.h>

#include <private/qqmlengine_p.h>

#include <QtQml/qqmlinfo.h>

QT_BEGIN_NAMESPACE

/*!
    \qmltype DoubleSpinBox
    \inherits Control
//!     \nativetype QQuickDoubleSpinBox
    \inqmlmodule QtQuick.Controls
    \ingroup qtquickcontrols-input
    \ingroup qtquickcontrols-focusscopes
    \since 6.11
    \brief Allows the user to select from a set of preset floating-point
        values.

    \image qtquickcontrols-doublespinbox.png
           {Spin box displaying decimal values}

    DoubleSpinBox is similar to \l SpinBox, except that it supports double
    values rather than integer. The user can choose a value by clicking the up
    or down indicator buttons, or by pressing up or down on the keyboard.
    Optionally, DoubleSpinBox can be also made \l editable, so the user can
    enter a text value in the input field.

    By default, DoubleSpinBox provides discrete values in the range of
    \c [0.00-99.99] with a \l stepSize of \c 1.0.

    \snippet qtquickcontrols-doublespinbox.qml 1

    \sa SpinBox, Tumbler, {Customizing DoubleSpinBox},
        {Focus Management in Qt Quick Controls}
*/

/*!
    \include qquickspinbox.qdocinc {valueModified} {DoubleSpinBox}
*/

class QQuickDoubleSpinBoxPrivate
    : public QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>::QQuickAbstractSpinBoxPrivate
{
    Q_DECLARE_PUBLIC(QQuickDoubleSpinBox)

public:
    QQuickDoubleSpinBoxPrivate();

    bool setValue(double newValue, bool wrap, ValueStatus modified) override;

    void updateValue() override;
    void updateDisplayText() override;

    void contentItemTextChanged();

    QString evaluateTextFromValue(double val, int decimals) const;
    double evaluateValueFromText(const QString &text) const;

    double round(double input) const;

    int decimals = 2;

private:
    friend class QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>::QQuickAbstractSpinBoxPrivate;
};

QQuickDoubleSpinBoxPrivate::QQuickDoubleSpinBoxPrivate()
    : QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>::QQuickAbstractSpinBoxPrivate()
{
    from = 0.0;
    to = 99.99;
}

/*!
    \internal

    modified indicates if the value was modified by the user and not programatically.
    This is then passed on to updateDisplayText to indicate that the user has modified
    the value, so it may need to trigger an update of the contentItem's text, too.
*/

bool QQuickDoubleSpinBoxPrivate::setValue(double newValue, bool wrap, ValueStatus modified)
{
    Q_Q(QQuickDoubleSpinBox);
    double correctedValue = newValue;
    if (q->isComponentComplete())
        correctedValue = boundValue(newValue, wrap);

    if (modified == ValueStatus::Unmodified && qFuzzyCompare(newValue, correctedValue)
        && qFuzzyCompare(newValue, value))
        return false;

    const bool emitSignals = (value != correctedValue);
    value = correctedValue;

    updateDisplayText();
    updateUpEnabled();
    updateDownEnabled();

    // Only emit the signals if the corrected value is not the same as the
    // original value to avoid unnecessary updates.
    if (emitSignals) {
        emit q->valueChanged();
        if (modified == ValueStatus::Modified)
            emit q->valueModified();
    }
    return true;
}

void QQuickDoubleSpinBoxPrivate::updateValue()
{
    if (!contentItem)
        return;

    const QVariant text = contentItem->property("text");
    if (text.isValid())
        setValue(evaluateValueFromText(text.toString()), false /* wrap */, ValueStatus::Modified);
}

void QQuickDoubleSpinBoxPrivate::updateDisplayText()
{
    setDisplayText(evaluateTextFromValue(value, decimals));
}

void QQuickDoubleSpinBoxPrivate::contentItemTextChanged()
{
    Q_Q(QQuickDoubleSpinBox);

    QQuickTextInput *inputTextItem = qobject_cast<QQuickTextInput *>(q->contentItem());
    if (!inputTextItem)
        return;
    setDisplayText(inputTextItem->text());
}

QString QQuickDoubleSpinBoxPrivate::evaluateTextFromValue(double val, int decimals) const
{
    Q_Q(const QQuickDoubleSpinBox);

    QString text;
    QQmlEngine *engine = qmlEngine(q);
    if (engine && textFromValue.isCallable()) {
        QJSValue loc;
#if QT_CONFIG(qml_locale)
        loc = QJSValuePrivate::fromReturnedValue(
                engine->handle()->fromData(QMetaType::fromType<QLocale>(), &locale));
#endif
        text = textFromValue.call(QJSValueList() << val << decimals << loc).toString();
    } else {
        text = locale.toString(val, 'f', decimals);
    }
    return text;
}

double QQuickDoubleSpinBoxPrivate::evaluateValueFromText(const QString &text) const
{
    Q_Q(const QQuickDoubleSpinBox);
    double value;
    QQmlEngine *engine = qmlEngine(q);
    if (engine && valueFromText.isCallable()) {
        QJSValue loc;
#if QT_CONFIG(qml_locale)
        loc = QJSValuePrivate::fromReturnedValue(
                engine->handle()->fromData(QMetaType::fromType<QLocale>(), &locale));
#endif
        value = valueFromText.call(QJSValueList() << text << loc).toNumber();
    } else {
        value = locale.toDouble(text);
    }
    return value;
}

double QQuickDoubleSpinBoxPrivate::round(double value) const
{
    return QString::number(value, 'f', decimals).toDouble();
}

QQuickDoubleSpinBox::QQuickDoubleSpinBox(QQuickItem *parent)
    : QQuickControl(*(new QQuickDoubleSpinBoxPrivate), parent),
      QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>()
{
}

QQuickDoubleSpinBox::~QQuickDoubleSpinBox() { }

/*!
    \include qquickspinbox.qdocinc {from} {double} {DoubleSpinBox} {0.0}
*/

void QQuickDoubleSpinBox::setFrom(double from)
{
    Q_D(QQuickDoubleSpinBox);
    const double newFrom = d->round(from);
    if (qFuzzyCompare(d->from, newFrom))
        return;

    d->from = newFrom;
    emit fromChanged();
    if (isComponentComplete()) {
        if (!d->setValue(d->round(d->value), false /* wrap */,
                         QQuickDoubleSpinBoxPrivate::ValueStatus::Unmodified)) {
            d->updateUpEnabled();
            d->updateDownEnabled();
        }
    }
}

/*!
    \include qquickspinbox.qdocinc {to} {double} {DoubleSpinBox} {99.99}
*/

void QQuickDoubleSpinBox::setTo(double to)
{
    Q_D(QQuickDoubleSpinBox);
    const double newTo = d->round(to);
    if (qFuzzyCompare(d->to, newTo))
        return;

    d->to = newTo;
    emit toChanged();
    if (isComponentComplete()) {
        if (!d->setValue(d->round(d->value), false /* wrap */,
                         QQuickDoubleSpinBoxPrivate::ValueStatus::Unmodified)) {
            d->updateUpEnabled();
            d->updateDownEnabled();
        }
    }
}

/*!
    \include qquickspinbox.qdocinc {value-prop} {double} {DoubleSpinBox} {0.0}
*/

void QQuickDoubleSpinBox::setValue(double value)
{
    Q_D(QQuickDoubleSpinBox);
    d->setValue(d->round(value), false /* wrap */,
                QQuickDoubleSpinBoxPrivate::ValueStatus::Unmodified);
}

/*!
    \include qquickspinbox.qdocinc {stepSize} {double} {DoubleSpinBox} {1.0}
*/

void QQuickDoubleSpinBox::setStepSize(double step)
{
    Q_D(QQuickDoubleSpinBox);
    if (qFuzzyCompare(d->stepSize, step))
        return;

    d->stepSize = step;
    emit stepSizeChanged();
}

/*!
    \qmlproperty int QtQuick.Controls::DoubleSpinBox::decimals

    This property holds how many decimals the spinbox will use for displaying
    and interpreting doubles.

    The default value is \c 2.

    Changing the value of this property may affect \l from, \l to and \l value.

    \warning The maximum value for \a decimals is \c {DBL_MAX_10_EXP +
    DBL_DIG} (\c 323) because of the limitations of the double type.
*/

int QQuickDoubleSpinBox::decimals() const
{
    Q_D(const QQuickDoubleSpinBox);

    return d->decimals;
}

void QQuickDoubleSpinBox::setDecimals(int decimals)
{
    Q_D(QQuickDoubleSpinBox);
    d->decimals = qBound(0, decimals, DBL_MAX_10_EXP + DBL_DIG);

    // Make sure values are rounded.
    setFrom(from());
    setTo(to());
    setValue(value());
    d->updateValue();
    emit decimalsChanged();
}

/*!
    \include qquickspinbox.qdocinc {editable} {DoubleSpinBox}
*/

#if QT_CONFIG(validator)
/*!
    \qmlproperty Validator QtQuick.Controls::DoubleSpinBox::validator

    This property holds the input text validator for editable spinboxes. By
    default, DoubleSpinBox uses \l DoubleValidator to accept input of double numbers.

    \code
    DoubleSpinBox {
        id: control
        validator: DoubleValidator {
            locale: control.locale.name
            bottom: Math.min(control.from, control.to)
            top: Math.max(control.from, control.to)
        }
    }
    \endcode

    \sa editable, textFromValue, valueFromText, {Control::locale}{locale},
        {Validating Input Text}
*/
#endif

/*!
    \qmlproperty function QtQuick.Controls::DoubleSpinBox::textFromValue

    This property holds a callback function that is called whenever
    a double value needs to be converted to display text.

    The default function can be overridden to display custom text for a given
    value. This applies to both editable and non-editable spinboxes;
    for example, when using the up and down buttons or a mouse wheel to
    increment and decrement the value, the new value is converted to display
    text using this function.

    The callback function signature is \c {string function(value, decimals, locale)}.
    The function can have two or three arguments, where the first argument
    is the value to be converted, the second argument is the number of decimals,
    and the optional third argument is the locale that should be used for
    the conversion, if applicable.

    The default implementation does the conversion using
    \l {string Number::toLocaleString(locale, format, precision)}{Number.toLocaleString}():

    \code
    textFromValue: function(value, decimals, locale) {
        return Number(value).toLocaleString(locale, 'f', decimals);
    }
    \endcode

    \note When applying a custom \c textFromValue implementation for editable
    spinboxes, a matching \l valueFromText implementation must be provided
    to be able to convert the custom text back to a double value.

    \sa valueFromText, validator, {Control::locale}{locale}
*/
QJSValue QQuickDoubleSpinBox::textFromValue() const
{
    Q_D(const QQuickDoubleSpinBox);
    if (!d->textFromValue.isCallable()) {
        QQmlEngine *engine = qmlEngine(this);
        if (engine) {
            d->textFromValue = engine->evaluate(
                    QStringLiteral("(function(value, decimals, locale) { return "
                                   "Number(value).toLocaleString(locale, 'f', decimals); })"));
        }
    }
    return d->textFromValue;
}

/*!
    \qmlproperty function QtQuick.Controls::DoubleSpinBox::valueFromText

    This property holds a callback function that is called whenever
    input text needs to be converted to a double value.

    This function only needs to be overridden when \l textFromValue
    is overridden for an editable spinbox.

    The callback function signature is \c {int function(text, locale)}.
    The function can have one or two arguments, where the first argument
    is the text to be converted, and the optional second argument is the
    locale that should be used for the conversion, if applicable.

    The default implementation does the conversion using
    \l {QtQml::Locale}{Number.fromLocaleString()}:

    \code
    valueFromText: function(text, locale) { return Number.fromLocaleString(locale, text); }
    \endcode

    \note When applying a custom \l textFromValue implementation for editable
    spinboxes, a matching \c valueFromText implementation must be provided
    to be able to convert the custom text back to a double value.

    \sa textFromValue, validator, {Control::locale}{locale}
*/
QJSValue QQuickDoubleSpinBox::valueFromText() const
{
    Q_D(const QQuickDoubleSpinBox);
    if (!d->valueFromText.isCallable()) {
        QQmlEngine *engine = qmlEngine(this);
        if (engine)
            d->valueFromText = engine->evaluate(QStringLiteral(
                    "(function(text, locale) { return Number.fromLocaleString(locale, text); })"));
    }
    return d->valueFromText;
}

/*!
    \include qquickindicatorbutton.qdocinc {properties} {DoubleSpinBox} {up}
    \sa increase()
*/

/*!
    \include qquickindicatorbutton.qdocinc {properties} {DoubleSpinBox} {down}
    \sa decrease()
*/

/*!
    \include qquickspinbox.qdocinc {inputMethodHints} {DoubleSpinBox}
*/

/*!
    \include qquickspinbox.qdocinc {inputMethodComposing} {DoubleSpinBox}
*/

/*!
    \since QtQuick.Controls 2.3 (Qt 5.10)
    \include qquickspinbox.qdocinc {wrap} {DoubleSpinBox}
*/

void QQuickDoubleSpinBox::setWrap(bool wrap)
{
    Q_D(QQuickDoubleSpinBox);
    if (d->wrap == wrap)
        return;

    d->wrap = wrap;
    if (qFuzzyCompare(d->value, d->from) || qFuzzyCompare(d->value, d->to)) {
        d->updateUpEnabled();
        d->updateDownEnabled();
    }
    emit wrapChanged();
}

/*!
    \qmlproperty string QtQuick.Controls::DoubleSpinBox::displayText
    \readonly

    This property holds the textual value of the spinbox.

    The value of the property is based on \l textFromValue and \l {Control::}
    {locale}, and equal to:
    \badcode
    let text = spinBox.textFromValue(spinBox.value, spinBox.decimals, spinBox.locale)
    \endcode

    \sa textFromValue
*/

/*!
    \include qquickspinbox.qdocinc {increase} {DoubleSpinBox}
*/

void QQuickDoubleSpinBox::increase()
{
    QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>::increase();
}

/*!
    \include qquickspinbox.qdocinc {decrease} {DoubleSpinBox}
*/

void QQuickDoubleSpinBox::decrease()
{
    QQuickAbstractSpinBox<QQuickDoubleSpinBox, double>::decrease();
}

void QQuickDoubleSpinBox::contentItemChange(QQuickItem *newItem, QQuickItem *oldItem)
{
    Q_D(QQuickDoubleSpinBox);
    if (QQuickTextInput *oldInput = qobject_cast<QQuickTextInput *>(oldItem)) {
        disconnect(oldInput, &QQuickTextInput::inputMethodComposingChanged, this,
                   &QQuickDoubleSpinBox::inputMethodComposingChanged);
        QObjectPrivate::disconnect(oldInput, &QQuickTextInput::textChanged, d,
                                   &QQuickDoubleSpinBoxPrivate::contentItemTextChanged);
    }

    if (newItem) {
        newItem->setActiveFocusOnTab(true);
        if (d->activeFocus)
            newItem->forceActiveFocus(static_cast<Qt::FocusReason>(d->focusReason));
#if QT_CONFIG(cursor)
        if (d->editable)
            newItem->setCursor(Qt::IBeamCursor);
#endif

        if (QQuickTextInput *newInput = qobject_cast<QQuickTextInput *>(newItem)) {
            connect(newInput, &QQuickTextInput::inputMethodComposingChanged, this,
                    &QQuickDoubleSpinBox::inputMethodComposingChanged);
            QObjectPrivate::connect(newInput, &QQuickTextInput::textChanged, d,
                                    &QQuickDoubleSpinBoxPrivate::contentItemTextChanged);
        }
    }
}

QQuickControlPrivate *QQuickDoubleSpinBox::d_base_func()
{
    Q_D(QQuickDoubleSpinBox);
    return d;
}
const QQuickControlPrivate *QQuickDoubleSpinBox::d_base_func() const
{
    Q_D(const QQuickDoubleSpinBox);
    return d;
}

QT_END_NAMESPACE

#include "moc_qquickdoublespinbox_p.cpp"
