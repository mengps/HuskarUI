#ifndef DELTHEME_H
#define DELTHEME_H

#include <QtQml/qqml.h>

#include "delglobal.h"
#include "deldefinitions.h"

QT_FORWARD_DECLARE_CLASS(DelThemePrivate)

class DELEGATEUI_EXPORT DelTheme : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(DelTheme)

    Q_PROPERTY(bool isDark READ isDark NOTIFY isDarkChanged)
    Q_PROPERTY(DarkMode darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged FINAL)

    DEL_PROPERTY_INIT(bool, animationEnabled, setAnimationEnabled, true);

    DEL_PROPERTY_READONLY(QVariantMap, Primary); /*! 所有 {Index.json} 中的变量 */

    DEL_PROPERTY_READONLY(QVariantMap, DelButton);
    DEL_PROPERTY_READONLY(QVariantMap, DelIconText);
    DEL_PROPERTY_READONLY(QVariantMap, DelCopyableText);
    DEL_PROPERTY_READONLY(QVariantMap, DelCaptionButton);
    DEL_PROPERTY_READONLY(QVariantMap, DelTour);
    DEL_PROPERTY_READONLY(QVariantMap, DelMenu);
    DEL_PROPERTY_READONLY(QVariantMap, DelDivider);
    DEL_PROPERTY_READONLY(QVariantMap, DelSwitch);
    DEL_PROPERTY_READONLY(QVariantMap, DelScrollBar);
    DEL_PROPERTY_READONLY(QVariantMap, DelSlider);
    DEL_PROPERTY_READONLY(QVariantMap, DelTabView);
    DEL_PROPERTY_READONLY(QVariantMap, DelToolTip);
    DEL_PROPERTY_READONLY(QVariantMap, DelSelect);
    DEL_PROPERTY_READONLY(QVariantMap, DelInput);
    DEL_PROPERTY_READONLY(QVariantMap, DelRate);
    DEL_PROPERTY_READONLY(QVariantMap, DelRadio);
    DEL_PROPERTY_READONLY(QVariantMap, DelCheckBox);
    DEL_PROPERTY_READONLY(QVariantMap, DelTimePicker);
    DEL_PROPERTY_READONLY(QVariantMap, DelDrawer);
    DEL_PROPERTY_READONLY(QVariantMap, DelCollapse);
    DEL_PROPERTY_READONLY(QVariantMap, DelCard);
    DEL_PROPERTY_READONLY(QVariantMap, DelPagination);
    DEL_PROPERTY_READONLY(QVariantMap, DelPopup);
    DEL_PROPERTY_READONLY(QVariantMap, DelTimeline);
    DEL_PROPERTY_READONLY(QVariantMap, DelTag);
    DEL_PROPERTY_READONLY(QVariantMap, DelTableView);
    DEL_PROPERTY_READONLY(QVariantMap, DelMessage);

public:
    enum class DarkMode {
        Light = 0,
        Dark,
        System
    };
    Q_ENUM(DarkMode);

    ~DelTheme();

    static DelTheme *instance();
    static DelTheme *create(QQmlEngine *, QJSEngine *);

    bool isDark() const;

    DarkMode darkMode() const;
    void setDarkMode(DarkMode mode);

    void registerCustomComponentTheme(QObject *themeObject, const QString &component, QVariantMap *themeMap, const QString &themePath);

    Q_INVOKABLE void reloadTheme();

    Q_INVOKABLE void installThemePrimaryColor(const QColor &color);
    Q_INVOKABLE void installThemePrimaryFontSize(int fontSize);
    Q_INVOKABLE void installThemePrimaryFontFamilies(const QString &families);

    /**
     * @brief 安装Index主题
     * @param themePath 主题路径
     */
    Q_INVOKABLE void installIndexTheme(const QString &themePath);
    /**
     * @brief 安装Index主题键值对
     * @param key 变量键
     * @param value 值
     * @warning 支持变量生成(genColor/genFont/genFontSize)
     */
    Q_INVOKABLE void installIndexThemeKV(const QString &key, const QString &value);

    /**
     * @brief 安装组件主题
     * @param component 组件名称
     * @param themePath 主题路径
     */
    Q_INVOKABLE void installComponentTheme(const QString &component, const QString &themePath);
    /**
     * @brief 安装组件主题键值对
     * @param component 组件名称
     * @param key 变量键
     * @param value 值
     */
    Q_INVOKABLE void installComponentThemeKV(const QString &component, const QString &key, const QString &value);

signals:
    void isDarkChanged();
    void darkModeChanged();

private:
    explicit DelTheme(QObject *parent = nullptr);

    Q_DECLARE_PRIVATE(DelTheme);
    QScopedPointer<DelThemePrivate> d_ptr;
};

#endif // DELTHEME_H
