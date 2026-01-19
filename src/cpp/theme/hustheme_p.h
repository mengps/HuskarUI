#ifndef HUSTHEME_P_H
#define HUSTHEME_P_H

#include <QtCore/QHash>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>

#include "hustheme.h"
#include "hussystemthemehelper.h"

enum class Function : uint16_t
{
    GenColor,
    GenFontFamily,
    GenFontSize,
    GenFontLineHeight,
    GenRadius,

    Darker,
    Lighter,
    Brightness,
    Alpha,
    OnBackground,

    Multiply
};

using ComponentPropertyHash = QHash<QString, QVariantMap*>;
Q_GLOBAL_STATIC(ComponentPropertyHash, g_componentTable);

struct ThemeData
{
    struct Component
    {
        QString path;
        QVariantMap *tokenMap;
        QMap<QString, QString> installTokenMap;
    };
    QObject *themeObject = nullptr;
    QMap<QString, Component> componentMap;
};

class HusThemePrivate
{
public:
    HusThemePrivate(HusTheme *q) : q_ptr(q) { }

    Q_DECLARE_PUBLIC(HusTheme);

    HusTheme *q_ptr { nullptr };
    HusTheme::DarkMode m_darkMode = HusTheme::DarkMode::Light;
    HusTheme::TextRenderType m_textRenderType = HusTheme::TextRenderType::QtRendering;
    HusSystemThemeHelper *m_helper { nullptr };
    QString m_themeIndexPath = ":/HuskarUI/resources/theme/Index.json";
    QJsonObject m_indexObject;
    QMap<QString, QVariant> m_indexTokenTable;
    QMap<QString, QMap<QString, QVariant>> m_componentTokenTable;

    QMap<QObject *, ThemeData> m_defaultTheme;
    QMap<QObject *, ThemeData> m_customTheme;

    QVariantMap m_sizeHintMap;

    static HusThemePrivate *get(HusTheme *theme) { return theme->d_func(); }

    void initializeComponentPropertyHash();

    void parse$(QMap<QString, QVariant> &out, const QString &tokenName, const QString &expr);

    QColor colorFromIndexTable(const QString &tokenName);
    qreal numberFromIndexTable(const QString &tokenName);
    void parseIndexExpr(const QString &tokenName, const QString &expr);
    void parseComponentExpr(QVariantMap *tokenMapPtr, const QString &tokenName, const QString &expr);

    void reloadIndexTheme();
    void reloadComponentTheme(const QMap<QObject *, ThemeData> &dataMap);
    bool reloadComponentImport(QJsonObject &style, const QString &componentName);
    void reloadComponentThemeFile(QObject *themeObject, const QString &componentName, const ThemeData::Component &componentTheme);
    void reloadDefaultComponentTheme();
    void reloadCustomComponentTheme();

    void registerDefaultComponentTheme(const QString &component, const QString &themePath);
    void registerComponentTheme(QObject *theme,
                                const QString &component,
                                QVariantMap *themeMap,
                                const QString &themePath,
                                QMap<QObject *, ThemeData> &dataMap);
};

#endif // HUSTHEME_P_H
