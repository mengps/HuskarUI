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

    DEL_PROPERTY(int, darkMode, setDarkMode);
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

public:
    enum class DarkMode {
        System,
        Dark,
        Light
    };
    Q_ENUM(DarkMode);

    ~DelTheme();

    static DelTheme *instance();
    static DelTheme *create(QQmlEngine *, QJSEngine *);

    bool isDark() const;

    void registerComponentCustomTheme(QObject *theme, const QString &component, QVariantMap *themeMap, const QString &themePath);

    Q_INVOKABLE void reloadDefaultTheme();

    Q_INVOKABLE void installThemePrimaryColor(const QColor &color);
    Q_INVOKABLE void installThemePrimaryFontSize(int fontSize);
    Q_INVOKABLE void installThemePrimaryFontFamily(const QString &family);

    Q_INVOKABLE void installIndexTheme(const QString &themePath);
    Q_INVOKABLE void installIndexThemeKV(const QString &key, const QString &value);
    Q_INVOKABLE void installIndexThemeJSON(const QString &json);

    Q_INVOKABLE void installComponentTheme(const QString &componenet, const QString &themePath);
    Q_INVOKABLE void installComponentThemeKV(const QString &componenet, const QString &key, const QString &value);
    Q_INVOKABLE void installComponentThemeJSON(const QString &componenet, const QString &json);

signals:
    void isDarkChanged();

private:
    explicit DelTheme(QObject *parent = nullptr);

    Q_DECLARE_PRIVATE(DelTheme);
    QScopedPointer<DelThemePrivate> d_ptr;
};

#endif // DELTHEME_H
