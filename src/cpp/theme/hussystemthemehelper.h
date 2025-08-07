#ifndef HUSSYSTEMTHEMEHELPER_H
#define HUSSYSTEMTHEMEHELPER_H

#include <QtCore/QObject>
#include <QtGui/QColor>
#include <QtQml/qqml.h>

#include "husglobal.h"

QT_FORWARD_DECLARE_CLASS(QWindow);
QT_FORWARD_DECLARE_CLASS(QWidget);

QT_FORWARD_DECLARE_CLASS(HusSystemThemeHelperPrivate);

#ifndef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM
Q_DECLARE_OPAQUE_POINTER(QWindow*);
Q_DECLARE_OPAQUE_POINTER(QWidget*);
#endif

class HUSKARUI_EXPORT HusSystemThemeHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QColor themeColor READ themeColor NOTIFY themeColorChanged)
    Q_PROPERTY(HusSystemThemeHelper::ColorScheme colorScheme READ colorScheme NOTIFY colorSchemeChanged)

    QML_NAMED_ELEMENT(HusSystemThemeHelper)

public:
    enum class ColorScheme {
        None = 0,
        Dark = 1,
        Light = 2
    };
    Q_ENUM(ColorScheme);

    HusSystemThemeHelper(QObject *parent = nullptr);
    ~HusSystemThemeHelper();

    /**
     * @brief getThemeColor 立即获取当前主题颜色{不可用于绑定}
     * @warning 此接口更快，但不会自动更新
     * @return QColor
     */
    Q_INVOKABLE QColor getThemeColor() const;
    /**
     * @brief getColorScheme 立即获取当前颜色方案{不可用于绑定}
     * @warning 此接口更快，但不会自动更新
     * @return {@link HusSystemThemeHelper::ColorScheme}
     */
    Q_INVOKABLE HusSystemThemeHelper::ColorScheme getColorScheme() const;
    /**
     * @brief colorScheme 获取当前主题颜色{可用于绑定}
     * @return QColor
     */
    QColor themeColor();
    /**
     * @brief colorScheme 获取当前颜色方案{可用于绑定}
     * @return {@link HusSystemThemeHelper::ColorScheme}
     */
    HusSystemThemeHelper::ColorScheme colorScheme();

    Q_INVOKABLE static bool setWindowTitleBarMode(QWindow *window, bool isDark);

#ifdef QT_WIDGETS_LIB
    Q_INVOKABLE static bool setWindowTitleBarMode(QWidget *window, bool isDark);
#endif

signals:
    void themeColorChanged(const QColor &color);
    void colorSchemeChanged(HusSystemThemeHelper::ColorScheme scheme);

protected:
    virtual void timerEvent(QTimerEvent *);

private:
    Q_DECLARE_PRIVATE(HusSystemThemeHelper);
    QScopedPointer<HusSystemThemeHelperPrivate> d_ptr;
};


#endif // HUSSYSTEMTHEMEHELPER_H
