#ifndef DELTHEME_P_H
#define DELTHEME_P_H

#include "deltheme.h"
#include "delsystemthemehelper.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QHash>

enum class Function : uint16_t
{
    GenColor,
    GenFontFamily,
    GenFontSize,
    GenFontLineHeight,

    Darker,
    Lighter,
    Alpha,
    OnBackground,

    Multiply
};

enum class Component : uint16_t
{
    DelButton,
    DelIconText,
    DelCopyableText,
    DelCaptionButton,
    DelTour,
    DelMenu,
    DelDivider,
    DelSwitch,
    DelScrollBar,
    DelSlider,
    DelTabView,
    DelToolTip,
    DelSelect,
    DelInput,
    DelRate,
    DelRadio,
    DelCheckBox,
    DelTimePicker,
    DelDrawer,
    DelCollapse,
    DelCard,
    DelPagination,
    DelPopup,
    DelTimeline,
    DelTag,
    DelTableView,
    DelMessage,
    DelAutoComplete,
    DelDatePicker,
    DelProgress,
    DelCarousel,

    Size
};

static QHash<QString, Component> g_componentTable
{
    { "DelButton",        Component::DelButton        },
    { "DelIconText",      Component::DelIconText      },
    { "DelCopyableText",  Component::DelCopyableText  },
    { "DelCaptionButton", Component::DelCaptionButton },
    { "DelTour",          Component::DelTour          },
    { "DelMenu",          Component::DelMenu          },
    { "DelDivider",       Component::DelDivider       },
    { "DelSwitch",        Component::DelSwitch        },
    { "DelScrollBar",     Component::DelScrollBar     },
    { "DelSlider",        Component::DelSlider        },
    { "DelTabView",       Component::DelTabView       },
    { "DelToolTip",       Component::DelToolTip       },
    { "DelSelect",        Component::DelSelect        },
    { "DelInput",         Component::DelInput         },
    { "DelRate",          Component::DelRate          },
    { "DelRadio",         Component::DelRadio         },
    { "DelCheckBox",      Component::DelCheckBox      },
    { "DelTimePicker",    Component::DelTimePicker    },
    { "DelDrawer",        Component::DelDrawer        },
    { "DelCollapse",      Component::DelCollapse      },
    { "DelCard",          Component::DelCard          },
    { "DelPagination",    Component::DelPagination    },
    { "DelPopup",         Component::DelPopup         },
    { "DelTimeline",      Component::DelTimeline      },
    { "DelTableView",     Component::DelTableView     },
    { "DelTag",           Component::DelTag           },
    { "DelMessage",       Component::DelMessage       },
    { "DelAutoComplete",  Component::DelAutoComplete  },
    { "DelDatePicker",    Component::DelDatePicker    },
    { "DelProgress",      Component::DelProgress      },
    { "DelCarousel",      Component::DelCarousel      },
};

struct ThemeData
{
    struct Component
    {
        QString path;
        QVariantMap *varMap;
        QMap<QString, QString> installVarMap;
    };
    QObject *themeObject = nullptr;
    QMap<QString, Component> componentMap;
};

class DelThemePrivate
{
public:
    DelThemePrivate(DelTheme *q) : q_ptr(q) { }

    Q_DECLARE_PUBLIC(DelTheme);
    DelTheme *q_ptr = nullptr;
    DelTheme::DarkMode m_darkMode = DelTheme::DarkMode::Light;
    DelTheme::TextRenderType m_textRenderType = DelTheme::TextRenderType::QtRendering;
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
    void parseIndexExpr(const QString &varName, const QString &expr);
    void parseComponentExpr(QVariantMap *varMapPtr, const QString &varName, const QString &expr);

    void reloadIndexTheme();
    void extracted(std::map<QString, ThemeData::Component> &map);
    void reloadComponentTheme(const QMap<QObject *, ThemeData> &dataMap);
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

#endif // DELTHEME_P_H
