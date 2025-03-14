#ifndef DELSYSTEMTHEMEHELPER_H
#define DELSYSTEMTHEMEHELPER_H

#include <QColor>
#include <QObject>
#include <qqmlintegration.h>

#include "delglobal.h"

QT_FORWARD_DECLARE_CLASS(QWindow);
QT_FORWARD_DECLARE_CLASS(QWidget);

QT_FORWARD_DECLARE_CLASS(DelSystemThemeHelperPrivate);

class DELEGATEUI_EXPORT DelSystemThemeHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QColor themeColor READ themeColor NOTIFY themeColorChanged)
    Q_PROPERTY(DelSystemThemeHelper::ColorScheme colorScheme READ colorScheme NOTIFY colorSchemeChanged)

    QML_NAMED_ELEMENT(DelSystemThemeHelper)

public:
    enum class ColorScheme {
        None = 0,
        Dark = 1,
        Light = 2
    };
    Q_ENUM(ColorScheme);

    DelSystemThemeHelper(QObject *parent = nullptr);
    ~DelSystemThemeHelper();

    /**
     * @brief getThemeColor 立即获取当前主题颜色{不可用于绑定}
     * @warning 此接口更快，但不会自动更新
     * @return QColor
     */
    Q_INVOKABLE QColor getThemeColor() const;
    /**
     * @brief getColorScheme 立即获取当前颜色方案{不可用于绑定}
     * @warning 此接口更快，但不会自动更新
     * @return {@link DelSystemThemeHelper::ColorScheme}
     */
    Q_INVOKABLE DelSystemThemeHelper::ColorScheme getColorScheme() const;
    /**
     * @brief colorScheme 获取当前主题颜色{可用于绑定}
     * @return QColor
     */
    QColor themeColor();
    /**
     * @brief colorScheme 获取当前颜色方案{可用于绑定}
     * @return {@link DelSystemThemeHelper::ColorScheme}
     */
    DelSystemThemeHelper::ColorScheme colorScheme();

    Q_INVOKABLE static bool setWindowTitleBarMode(QWindow *window, bool isDark);

#ifdef QT_WIDGETS_LIB
    Q_INVOKABLE static bool setWindowTitleBarMode(QWidget *window, bool isDark);
#endif

signals:
    void themeColorChanged(const QColor &color);
    void colorSchemeChanged(DelSystemThemeHelper::ColorScheme scheme);

protected:
    virtual void timerEvent(QTimerEvent *);

private:
    Q_DECLARE_PRIVATE(DelSystemThemeHelper);
    QScopedPointer<DelSystemThemeHelperPrivate> d_ptr;
};


#endif // DELSYSTEMTHEMEHELPER_H
