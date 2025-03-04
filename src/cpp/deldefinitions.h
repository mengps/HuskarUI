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

#endif // DELDEFINITIONS_H
