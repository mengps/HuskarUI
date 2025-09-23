#ifndef HUSTHEME_H
#define HUSTHEME_H

#include <QtQml/qqml.h>

#include "husglobal.h"
#include "husdefinitions.h"

QT_FORWARD_DECLARE_CLASS(HusThemePrivate)

class HUSKARUI_EXPORT HusTheme : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(HusTheme)

    Q_PROPERTY(bool isDark READ isDark NOTIFY isDarkChanged)
    Q_PROPERTY(DarkMode darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged FINAL)
    Q_PROPERTY(TextRenderType textRenderType READ textRenderType WRITE setTextRenderType NOTIFY textRenderTypeChanged FINAL)

    HUS_PROPERTY_INIT(bool, animationEnabled, setAnimationEnabled, true);

    HUS_PROPERTY_READONLY(QVariantMap, Primary); /*! 所有 {Index.json} 中的变量 */

    HUS_PROPERTY_READONLY(QVariantMap, HusButton);
    HUS_PROPERTY_READONLY(QVariantMap, HusIconText);
    HUS_PROPERTY_READONLY(QVariantMap, HusCopyableText);
    HUS_PROPERTY_READONLY(QVariantMap, HusCaptionButton);
    HUS_PROPERTY_READONLY(QVariantMap, HusTour);
    HUS_PROPERTY_READONLY(QVariantMap, HusMenu);
    HUS_PROPERTY_READONLY(QVariantMap, HusDivider);
    HUS_PROPERTY_READONLY(QVariantMap, HusSwitch);
    HUS_PROPERTY_READONLY(QVariantMap, HusScrollBar);
    HUS_PROPERTY_READONLY(QVariantMap, HusSlider);
    HUS_PROPERTY_READONLY(QVariantMap, HusTabView);
    HUS_PROPERTY_READONLY(QVariantMap, HusToolTip);
    HUS_PROPERTY_READONLY(QVariantMap, HusSelect);
    HUS_PROPERTY_READONLY(QVariantMap, HusInput);
    HUS_PROPERTY_READONLY(QVariantMap, HusRate);
    HUS_PROPERTY_READONLY(QVariantMap, HusRadio);
    HUS_PROPERTY_READONLY(QVariantMap, HusCheckBox);
    HUS_PROPERTY_READONLY(QVariantMap, HusDrawer);
    HUS_PROPERTY_READONLY(QVariantMap, HusCollapse);
    HUS_PROPERTY_READONLY(QVariantMap, HusCard);
    HUS_PROPERTY_READONLY(QVariantMap, HusPagination);
    HUS_PROPERTY_READONLY(QVariantMap, HusPopup);
    HUS_PROPERTY_READONLY(QVariantMap, HusTimeline);
    HUS_PROPERTY_READONLY(QVariantMap, HusTag);
    HUS_PROPERTY_READONLY(QVariantMap, HusTableView);
    HUS_PROPERTY_READONLY(QVariantMap, HusMessage);
    HUS_PROPERTY_READONLY(QVariantMap, HusAutoComplete);
    HUS_PROPERTY_READONLY(QVariantMap, HusProgress);
    HUS_PROPERTY_READONLY(QVariantMap, HusCarousel);
    HUS_PROPERTY_READONLY(QVariantMap, HusBreadcrumb);
    HUS_PROPERTY_READONLY(QVariantMap, HusImage);
    HUS_PROPERTY_READONLY(QVariantMap, HusMultiSelect);
    HUS_PROPERTY_READONLY(QVariantMap, HusDateTimePicker);
    HUS_PROPERTY_READONLY(QVariantMap, HusNotification);
    HUS_PROPERTY_READONLY(QVariantMap, HusPopconfirm);

public:
    enum class DarkMode {
        Light = 0,
        Dark,
        System
    };
    Q_ENUM(DarkMode);

    enum class TextRenderType {
        QtRendering = 0,
        NativeRendering = 1,
        CurveRendering = 2
    };
    Q_ENUM(TextRenderType);

    ~HusTheme();

    static HusTheme *instance();
    static HusTheme *create(QQmlEngine *, QJSEngine *);

    bool isDark() const;

    DarkMode darkMode() const;
    void setDarkMode(DarkMode mode);

    TextRenderType textRenderType() const;
    void setTextRenderType(TextRenderType renderType);

    /**
     * @brief 注册自定义组件主题
     * @param themeObject 主题对象指针
     * @param component 组件名
     * @param themeMap 主题属性映射
     * @param themePath 主题路径
     */
    void registerCustomComponentTheme(QObject *themeObject, const QString &component, QVariantMap *themeMap, const QString &themePath);

    /**
     * @brief 重新载入(重新计算)主题
     */
    Q_INVOKABLE void reloadTheme();

    /**
     * @brief 设置文本基础色{HusTheme.Primary.colorTextBase}
     * @param lightAndDark 明亮和暗黑模式颜色字符串,类似于{#000|#fff}
     */
    Q_INVOKABLE void installThemeColorTextBase(const QString &lightAndDark);
    /**
     * @brief 设置背景基础色{HusTheme.Primary.colorBgBase}
     * @param lightAndDark 明亮和暗黑模式颜色字符串,类似于{#fff|#000}
     */
    Q_INVOKABLE void installThemeColorBgBase(const QString &lightAndDark);
    /**
     * @brief 设置主基础色{HusTheme.Primary.colorPrimaryBase}
     * @param color 主基础颜色
     */
    Q_INVOKABLE void installThemePrimaryColorBase(const QColor &colorBase);
    /**
     * @brief 设置字体基础大小{HusTheme.Primary.fontSizeBase}
     * @param fontSizeBase 基础字体像素大小
     */
    Q_INVOKABLE void installThemePrimaryFontSizeBase(int fontSizeBase);
    /**
     * @brief 设置基础字体族{HusTheme.Primary.fontFamilyBase}
     * @param familiesBase 基础字体族
     */
    Q_INVOKABLE void installThemePrimaryFontFamiliesBase(const QString &familiesBase);
    /**
     * @brief 设置圆角半径基础大小{HusTheme.Primary.radiusBase}
     * @param radiusBase 基础圆角半径大小
     */
    Q_INVOKABLE void installThemePrimaryRadiusBase(int radiusBase);
    /**
     * @brief 设置动画基础速度
     * @param durationFast [Fast 动画持续时间(ms)]
     * @param durationMid  [Mid  动画持续时间(ms)]
     * @param duratoinSlow [Slow 动画持续时间(ms)]
     */
    Q_INVOKABLE void installThemePrimaryAnimationBase(int durationFast, int durationMid, int durationSlow);


    /**
     * @brief 设置Index主题
     * @param themePath 主题路径
     */
    Q_INVOKABLE void installIndexTheme(const QString &themePath);
    /**
     * @brief 设置Index主题标记
     * @param token 标记名
     * @param value 标记值
     * @warning 支持Token生成函数(genColor/genFont/genFontSize/genRadius)
     */
    Q_INVOKABLE void installIndexToken(const QString &token, const QString &value);

    /**
     * @brief 设置组件主题
     * @param component 组件名称
     * @param themePath 主题路径
     */
    Q_INVOKABLE void installComponentTheme(const QString &component, const QString &themePath);
    /**
     * @brief 设置组件主题标记
     * @param component 组件名称
     * @param token 标记名
     * @param value 标记值
     */
    Q_INVOKABLE void installComponentToken(const QString &component, const QString &token, const QString &value);

signals:
    void isDarkChanged();
    void darkModeChanged();
    void textRenderTypeChanged();

private:
    explicit HusTheme(QObject *parent = nullptr);

    Q_DECLARE_PRIVATE(HusTheme);
    QScopedPointer<HusThemePrivate> d_ptr;
};

#endif // HUSTHEME_H
