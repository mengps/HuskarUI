#ifndef DELDEFINITIONS_H
#define DELDEFINITIONS_H

#include <QtQml/qqml.h>

#define DEL_PROPERTY(type, get, set) \
private:\
    Q_PROPERTY(type get READ get WRITE set NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
    void set(const type &t) { if (t != m_##get) { m_##get = t; emit get##Changed(); } } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get;

#define DEL_PROPERTY_INIT(type, get, set, init_value) \
private:\
    Q_PROPERTY(type get READ get WRITE set NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
    void set(const type &t) { if (t != m_##get) { m_##get = t; emit get##Changed(); } } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get{init_value};

#define DEL_PROPERTY_READONLY(type, get) \
private:\
    Q_PROPERTY(type get READ get NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get;

namespace DelButtonType {
    Q_NAMESPACE

    enum class ButtonType {
        Type_Default = 0,
        Type_Outlined = 1,
        Type_Primary = 2,
        Type_Filled = 3,
        Type_Text = 4
    };

    enum class ButtonShape {
        Shape_Default = 0,
        Shape_Circle = 1
    };

    enum class ButtonIconPosition {
        Position_Start = 0,
        Position_End = 1
    };

    Q_ENUM_NS(ButtonType);
    Q_ENUM_NS(ButtonShape);
    Q_ENUM_NS(ButtonIconPosition);

    QML_NAMED_ELEMENT(DelButtonType);
}

namespace DelWindowSpecialEffect {
    Q_NAMESPACE

    enum class SpecialEffect
    {
        None = 0,
        DwmBlur = 1,
        AcrylicMaterial = 2,
        Mica = 3,
        MicaAlt = 4
    };

    Q_ENUM_NS(SpecialEffect);

    QML_NAMED_ELEMENT(DelWindowSpecialEffect);
}

namespace DelDividerType {
    Q_NAMESPACE

    enum class Align
    {
        Left = 0,
        Center = 1,
        Right = 2
    };

    enum class Style
    {
        SolidLine = 0,
        DashLine = 1
    };

    Q_ENUM_NS(Align);
    Q_ENUM_NS(Style);

    QML_NAMED_ELEMENT(DelDividerType);
}

namespace DelSliderType {
    Q_NAMESPACE

    enum class SnapMode
    {
        NoSnap = 0,
        SnapAlways = 1,
        SnapOnRelease = 2
    };

    Q_ENUM_NS(SnapMode);

    QML_NAMED_ELEMENT(DelSliderType);
}

#endif // DELDEFINITIONS_H
