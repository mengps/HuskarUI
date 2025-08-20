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
    Alpha,
    OnBackground,

    Multiply
};

enum class Component : uint16_t
{
    HusButton,
    HusIconText,
    HusCopyableText,
    HusCaptionButton,
    HusTour,
    HusMenu,
    HusDivider,
    HusSwitch,
    HusScrollBar,
    HusSlider,
    HusTabView,
    HusToolTip,
    HusSelect,
    HusInput,
    HusRate,
    HusRadio,
    HusCheckBox,
    HusTimePicker,
    HusDrawer,
    HusCollapse,
    HusCard,
    HusPagination,
    HusPopup,
    HusTimeline,
    HusTag,
    HusTableView,
    HusMessage,
    HusAutoComplete,
    HusDatePicker,
    HusProgress,
    HusCarousel,
    HusBreadcrumb,
    HusImage,
    HusMultiSelect,

    Size
};

static QHash<QString, Component> g_componentTable
{
    { "HusButton",        Component::HusButton        },
    { "HusIconText",      Component::HusIconText      },
    { "HusCopyableText",  Component::HusCopyableText  },
    { "HusCaptionButton", Component::HusCaptionButton },
    { "HusTour",          Component::HusTour          },
    { "HusMenu",          Component::HusMenu          },
    { "HusDivider",       Component::HusDivider       },
    { "HusSwitch",        Component::HusSwitch        },
    { "HusScrollBar",     Component::HusScrollBar     },
    { "HusSlider",        Component::HusSlider        },
    { "HusTabView",       Component::HusTabView       },
    { "HusToolTip",       Component::HusToolTip       },
    { "HusSelect",        Component::HusSelect        },
    { "HusInput",         Component::HusInput         },
    { "HusRate",          Component::HusRate          },
    { "HusRadio",         Component::HusRadio         },
    { "HusCheckBox",      Component::HusCheckBox      },
    { "HusTimePicker",    Component::HusTimePicker    },
    { "HusDrawer",        Component::HusDrawer        },
    { "HusCollapse",      Component::HusCollapse      },
    { "HusCard",          Component::HusCard          },
    { "HusPagination",    Component::HusPagination    },
    { "HusPopup",         Component::HusPopup         },
    { "HusTimeline",      Component::HusTimeline      },
    { "HusTableView",     Component::HusTableView     },
    { "HusTag",           Component::HusTag           },
    { "HusMessage",       Component::HusMessage       },
    { "HusAutoComplete",  Component::HusAutoComplete  },
    { "HusDatePicker",    Component::HusDatePicker    },
    { "HusProgress",      Component::HusProgress      },
    { "HusCarousel",      Component::HusCarousel      },
    { "HusBreadcrumb",    Component::HusBreadcrumb    },
    { "HusImage",         Component::HusImage         },
    { "HusMultiSelect",   Component::HusMultiSelect   },
};

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

    HusTheme *q_ptr = nullptr;
    HusTheme::DarkMode m_darkMode = HusTheme::DarkMode::Light;
    HusTheme::TextRenderType m_textRenderType = HusTheme::TextRenderType::QtRendering;
    HusSystemThemeHelper *m_helper { nullptr };
    QString m_themeIndexPath = ":/HuskarUI/theme/Index.json";
    QJsonObject m_indexObject;
    QMap<QString, QVariant> m_indexTokenTable;
    QMap<QString, QMap<QString, QVariant>> m_componentTokenTable;

    QMap<QObject *, ThemeData> m_defaultTheme;
    QMap<QObject *, ThemeData> m_customTheme;

    static HusThemePrivate *get(HusTheme *theme) { return theme->d_func(); }

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
