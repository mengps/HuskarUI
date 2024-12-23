#ifndef DELTHEME_P_H
#define DELTHEME_P_H

#include "deltheme.h"
#include "delsystemthemehelper.h"

#include <QFont>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QHash>

enum class Function : uint16_t
{
    GenColor,
    GenFontSize,
    GenFontLineHeight,

    Darker,
    Lighter,
    Alpha,

    Multiply
};

enum class Component : uint16_t
{
    DelButton,
    DelIconText,
    DelCaptionButton,
    DelTour,
    DelMenu,
    DelDivider,
    DelSwitch,
    DelScrollBar,

    Size
};

static QHash<QString, Component> g_componentTable
{
    { "DelButton",        Component::DelButton        },
    { "DelIconText",      Component::DelIconText      },
    { "DelCaptionButton", Component::DelCaptionButton },
    { "DelTour",          Component::DelTour          },
    { "DelMenu",          Component::DelMenu          },
    { "DelDivider",       Component::DelDivider       },
    { "DelSwitch",        Component::DelSwitch        },
    { "DelScrollBar",     Component::DelScrollBar     },
};

struct ThemeData
{
    struct Component
    {
        QString path;
        QVariantMap *varMap;
    };
    QObject *theme = nullptr;
    QMap<QString, Component> component;
};

class DelThemePrivate
{
public:
    DelThemePrivate(DelTheme *q) : q_ptr(q) { }

    Q_DECLARE_PUBLIC(DelTheme);
    DelTheme *q_ptr = nullptr;
    DelSystemThemeHelper *m_helper { nullptr };
    QString m_themeIndexPath = ":/DelegateUI/theme/Index.json";
    QJsonObject m_indexObject;
    QMap<QString, QVariant> m_indexVariableTable;
    QMap<QString, QMap<QString, QVariant>> m_componentVariableTable;

    QMap<QObject *, ThemeData> m_defaultTheme;
    QMap<QObject *, ThemeData> m_customTheme;

    void parse$(QMap<QString, QVariant> &out, const QString &varName, const QString &expr);

    QColor colorFromIndexTable(const QString &varName);
    qreal numberFromIndexTable(const QString &varName);
    void indexExprParse(const QString &varName, const QString &expr);

    void reloadIndexTheme();
    void reloadComponentTheme(QMap<QObject *, ThemeData> &dataMap);
    void reloadComponentDefaultTheme();
    void reloadComponentCustomTheme();

    void registerDefaultThemeComponent(const QString &component, const QString &themePath);
    void registerThemeComponent(QObject *theme,
                                const QString &component,
                                QVariantMap *themeMap,
                                const QString &themePath,
                                QMap<QObject *, ThemeData> &dataMap);
};

#endif // DELTHEME_P_H
