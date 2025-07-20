#ifndef HUSDEFINITIONS_H
#define HUSDEFINITIONS_H

/*! 声明一般属性 */
#define HUS_PROPERTY(type, get, set) \
private:\
    Q_PROPERTY(type get READ get WRITE set NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
    void set(const type &t) { if (t != m_##get) { m_##get = t; emit get##Changed(); } } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get;


/*! 声明指针属性 */
#define HUS_PROPERTY_P(type, get, set) \
private:\
    Q_PROPERTY(type get READ get WRITE set NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
    void set(type t) { if (t != m_##get) { m_##get = t; emit get##Changed(); } } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get;


/*! 声明一般属性并初始化 */
#define HUS_PROPERTY_INIT(type, get, set, init_value) \
private:\
    Q_PROPERTY(type get READ get WRITE set NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
    void set(const type &t) { if (t != m_##get) { m_##get = t; emit get##Changed(); } } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get{init_value};


/*! 声明指针属性并初始化 */
#define HUS_PROPERTY_P_INIT(type, get, set, init_value) \
private:\
    Q_PROPERTY(type get READ get WRITE set NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
    void set(const type &t) { if (t != m_##get) { m_##get = t; emit get##Changed(); } } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get{init_value};


/*! 声明只读属性 */
#define HUS_PROPERTY_READONLY(type, get) \
private:\
    Q_PROPERTY(type get READ get NOTIFY get##Changed) \
public: \
    type get() const { return m_##get; } \
Q_SIGNAL void get##Changed(); \
private: \
    type m_##get;

#endif // HUSDEFINITIONS_H
