#ifndef DELGLOBAL_H
#define DELGLOBAL_H

#include <QtQml/qqml.h>

#if !defined(BUILD_DELEGATEUI_STATIC_LIBRARY)
#  if defined(BUILD_DELEGATEUI_LIB)
#    define DELEGATEUI_EXPORT Q_DECL_EXPORT
#  else
#    define DELEGATEUI_EXPORT Q_DECL_IMPORT
#  endif
#else
#  define DELEGATEUI_EXPORT
#endif

#define DEL_PROPERTY(type, get, set) \
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
        Type_Primary = 1
    };

    enum class ButtonShape {
        Shape_Default = 0,
        Shape_Circle = 1
    };

    Q_ENUM_NS(ButtonType);
    Q_ENUM_NS(ButtonShape);

    QML_NAMED_ELEMENT(DelButtonType);
}

#endif // DELGLOBAL_H
