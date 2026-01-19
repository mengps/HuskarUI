/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

#include "hustheme_p.h"
#include "huscolorgenerator.h"
#include "husthemefunctions.h"

#include <QtCore/QFile>
#include <QtCore/QLoggingCategory>
#include <QtCore/QJsonArray>
#include <QtGui/QFont>

Q_LOGGING_CATEGORY(lcHusTheme, "huskarui.basic.theme");

void HusThemePrivate::initializeComponentPropertyHash()
{
#define ADD_COMPONENT_PROPERTY(ComponentName) \
    g_componentTable->insert(#ComponentName, &q->m_##ComponentName);

    Q_Q(HusTheme);

    static bool initialized = false;
    if (!initialized) {
        initialized = true;
        ADD_COMPONENT_PROPERTY(HusButton)
        ADD_COMPONENT_PROPERTY(HusIconText)
        ADD_COMPONENT_PROPERTY(HusCopyableText)
        ADD_COMPONENT_PROPERTY(HusCaptionButton)
        ADD_COMPONENT_PROPERTY(HusTour)
        ADD_COMPONENT_PROPERTY(HusMenu)
        ADD_COMPONENT_PROPERTY(HusDivider)
        ADD_COMPONENT_PROPERTY(HusEmpty)
        ADD_COMPONENT_PROPERTY(HusSwitch)
        ADD_COMPONENT_PROPERTY(HusScrollBar)
        ADD_COMPONENT_PROPERTY(HusSlider)
        ADD_COMPONENT_PROPERTY(HusTabView)
        ADD_COMPONENT_PROPERTY(HusToolTip)
        ADD_COMPONENT_PROPERTY(HusSelect)
        ADD_COMPONENT_PROPERTY(HusInput)
        ADD_COMPONENT_PROPERTY(HusRate)
        ADD_COMPONENT_PROPERTY(HusRadio)
        ADD_COMPONENT_PROPERTY(HusRadioBlock)
        ADD_COMPONENT_PROPERTY(HusCheckBox)
        ADD_COMPONENT_PROPERTY(HusDrawer)
        ADD_COMPONENT_PROPERTY(HusCollapse)
        ADD_COMPONENT_PROPERTY(HusCard)
        ADD_COMPONENT_PROPERTY(HusPagination)
        ADD_COMPONENT_PROPERTY(HusPopup)
        ADD_COMPONENT_PROPERTY(HusTimeline)
        ADD_COMPONENT_PROPERTY(HusTag)
        ADD_COMPONENT_PROPERTY(HusTableView)
        ADD_COMPONENT_PROPERTY(HusMessage)
        ADD_COMPONENT_PROPERTY(HusAutoComplete)
        ADD_COMPONENT_PROPERTY(HusProgress)
        ADD_COMPONENT_PROPERTY(HusCarousel)
        ADD_COMPONENT_PROPERTY(HusBreadcrumb)
        ADD_COMPONENT_PROPERTY(HusImage)
        ADD_COMPONENT_PROPERTY(HusMultiSelect)
        ADD_COMPONENT_PROPERTY(HusDateTimePicker)
        ADD_COMPONENT_PROPERTY(HusNotification)
        ADD_COMPONENT_PROPERTY(HusPopconfirm)
        ADD_COMPONENT_PROPERTY(HusPopover)
        ADD_COMPONENT_PROPERTY(HusModal)
        ADD_COMPONENT_PROPERTY(HusTextArea)
        ADD_COMPONENT_PROPERTY(HusSpin)
        ADD_COMPONENT_PROPERTY(HusColorPicker)
        ADD_COMPONENT_PROPERTY(HusTreeView)
        ADD_COMPONENT_PROPERTY(HusLabel)
    }
}

void HusThemePrivate::parse$(QMap<QString, QVariant> &out, const QString &tokenName, const QString &expr)
{
    Q_Q(HusTheme);

    static QHash<QString, Function> g_funcTable {
        { "genColor",          Function::GenColor },
        { "genFontFamily",     Function::GenFontFamily },
        { "genFontSize",       Function::GenFontSize },
        { "genFontLineHeight", Function::GenFontLineHeight },
        { "genRadius",         Function::GenRadius },
        { "darker",            Function::Darker },
        { "lighter",           Function::Lighter },
        { "brightness",        Function::Brightness },
        { "alpha",             Function::Alpha },
        { "onBackground",      Function::OnBackground },
        { "multiply",          Function::Multiply }
    };

    static QRegularExpression g_funcRegex("\\$([^)]+)\\(");
    static QRegularExpression g_argsRegex("\\(([^)]+)\\)");

    QRegularExpressionMatch funcMatch = g_funcRegex.match(expr);
    QRegularExpressionMatch argsMatch = g_argsRegex.match(expr);
    if (funcMatch.hasMatch()) {
        QString func = funcMatch.captured(1);
        QString args = argsMatch.captured(1);
        if (g_funcTable.contains(func)) {
            switch (g_funcTable[func]) {
            case Function::GenColor:
            {
                QColor color = colorFromIndexTable(args);
                if (color.isValid()) {
                    auto colorBgBase = m_indexTokenTable["colorBgBase"].value<QColor>();
                    auto colors = HusThemeFunctions::genColor(color, !q->isDark(), colorBgBase);
                    if (q->isDark()) {
                        /*! 暗黑模式需要后移并翻转色表 */
                        colors.append(colors[0]);
                        std::reverse(colors.begin(), colors.end());
                    }
                    for (int i = 0; i < colors.length(); i++) {
                        auto genColor = colors.at(i);
                        auto key = tokenName + "-" + QString::number(i + 1);
                        out[key] = genColor;
                    }
                } else {
                    qCDebug(lcHusTheme) << QString("func genColor() invalid color:(%1)").arg(args);
                }
            } break;
            case Function::GenFontFamily:
            {
                out["fontFamilyBase"] = HusThemeFunctions::genFontFamily(args.trimmed());
            } break;
            case Function::GenFontSize:
            {
                bool ok = false;
                auto base = args.toDouble(&ok);
                if (ok) {
                    const auto fontSizes = HusThemeFunctions::genFontSize(base);
                    for (int i = 0; i < fontSizes.length(); i++) {
                        auto genFontSize = fontSizes.at(i);
                        auto key = tokenName + "-" + QString::number(i + 1);
                        out[key] = genFontSize;
                    }
                } else {
                    qCDebug(lcHusTheme) << QString("func genFontSize() invalid size:(%1)").arg(args);
                }
            } break;
            case Function::GenFontLineHeight:
            {
                bool ok = false;
                auto base = args.toDouble(&ok);
                if (ok) {
                    const auto fontLineHeights = HusThemeFunctions::genFontLineHeight(base);
                    for (int i = 0; i < fontLineHeights.length(); i++) {
                        auto genFontLineHeight = fontLineHeights.at(i);
                        auto key = tokenName + "-" + QString::number(i + 1);
                        out[key] = genFontLineHeight;
                    }
                } else {
                    qCDebug(lcHusTheme) << QString("func genFontLineHeight() invalid size:(%1)").arg(args);
                }
            } break;
            case Function::GenRadius:
            {
                bool ok = false;
                auto base = args.toInt(&ok);
                if (ok) {
                    const auto radius = HusThemeFunctions::genRadius(base);
                    for (int i = 0; i < radius.length(); i++) {
                        auto genRadius = radius.at(i);
                        auto key = tokenName + "-" + QString::number(i + 1);
                        out[key] = genRadius;
                    }
                } else {
                    qCDebug(lcHusTheme) << QString("func genRadius() invalid size:(%1)").arg(args);
                }
            } break;
            case Function::Darker:
            {
                auto argList = args.split(',');
                if (argList.length() == 1) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    out[tokenName] = HusThemeFunctions::darker(arg1);
                } else if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[tokenName] = HusThemeFunctions::darker(arg1, arg2);
                } else {
                    qCDebug(lcHusTheme) << QString("func darker() only accepts 1/2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Lighter:
            {
                auto argList = args.split(',');
                if (argList.length() == 1) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    out[tokenName] = HusThemeFunctions::lighter(arg1);
                } else if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[tokenName] = HusThemeFunctions::lighter(arg1, arg2);
                } else {
                    qCDebug(lcHusTheme) << QString("func lighter() only accepts 1/2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Brightness:
            {
                auto argList = args.split(',');
                if (argList.length() == 1) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    out[tokenName] = HusThemeFunctions::brightness(arg1, !q->isDark());
                } else if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[tokenName] = HusThemeFunctions::brightness(arg1, !q->isDark(), arg2);
                } else if (argList.length() == 3) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    auto arg3 = numberFromIndexTable(argList.at(2));
                    out[tokenName] = HusThemeFunctions::brightness(arg1, !q->isDark(), arg2, arg3);
                } else {
                    qCDebug(lcHusTheme) << QString("func brightness() only accepts 1/2/3 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Alpha:
            {
                auto argList = args.split(',');
                if (argList.length() == 1) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    out[tokenName] = HusThemeFunctions::alpha(arg1);
                } else if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[tokenName] = HusThemeFunctions::alpha(arg1, arg2);
                } else {
                    qCDebug(lcHusTheme) << QString("func alpha() only accepts 1/2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::OnBackground:
            {
                auto argList = args.split(',');
                if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0).trimmed());
                    auto arg2 = colorFromIndexTable(argList.at(1).trimmed());
                    out[tokenName] = HusThemeFunctions::onBackground(arg1, arg2);
                } else {
                    qCDebug(lcHusTheme) << QString("func onBackground() only accepts 2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Multiply:
            {
                auto argList = args.split(',');
                if (argList.length() == 2) {
                    auto arg1 = numberFromIndexTable(argList.at(0).trimmed());
                    auto arg2 = numberFromIndexTable(argList.at(1).trimmed());
                    out[tokenName] = HusThemeFunctions::multiply(arg1, arg2);
                } else {
                    qCDebug(lcHusTheme) << QString("func multiply() only accepts 2 parameters:(%1)").arg(args);
                }
            } break;
            default:
                break;
            }
        } else {
            qCDebug(lcHusTheme) << "Unknown func name:" << func;
        }
    } else {
        qCDebug(lcHusTheme) << "Unknown expr:" << expr;
    }
}

QColor HusThemePrivate::colorFromIndexTable(const QString &tokenName)
{
    QColor color;
    auto refTokenName = tokenName;
    if (refTokenName.startsWith('@')) {
        refTokenName = tokenName.mid(1);
        if (m_indexTokenTable.contains(refTokenName)) {
            auto v = m_indexTokenTable[refTokenName];
            color = v.value<QColor>();
            if (!color.isValid()) {
                qCDebug(lcHusTheme) << QString("Token toColor faild:(%1)").arg(tokenName);
            }
        } else {
            qCDebug(lcHusTheme) << QString("Index Token(%1) not found!").arg(refTokenName);
        }
    } else {
        /*! 按颜色处理 */
        color = QColor(tokenName);
        /*! 从预置颜色中获取 */
        if (tokenName.startsWith("#Preset_"))
            color = HusColorGenerator::presetToColor(tokenName.mid(1));
        if (!color.isValid()) {
            qCDebug(lcHusTheme) << QString("Token toColor faild:(%1)").arg(tokenName);
        }
    }

    return color;
}

qreal HusThemePrivate::numberFromIndexTable(const QString &tokenName)
{
    qreal number = 0;
    auto refTokenName = tokenName;
    if (refTokenName.startsWith('@')) {
        refTokenName = tokenName.mid(1);
        if (m_indexTokenTable.contains(refTokenName)) {
            auto value = m_indexTokenTable[refTokenName];
            auto ok = false;
            number = value.toDouble(&ok);
            if (!ok) {
                qCDebug(lcHusTheme) << QString("Token toDouble faild:(%1)").arg(refTokenName);
            }
        } else {
            qCDebug(lcHusTheme) << QString("Index Token(%1) not found!").arg(refTokenName);
        }
    } else {
        auto ok = false;
        number = tokenName.toDouble(&ok);
        if (!ok) {
            qCDebug(lcHusTheme) << QString("Token toDouble faild:(%1)").arg(tokenName);
        }
    }

    return number;
}

void HusThemePrivate::parseIndexExpr(const QString &tokenName, const QString &expr)
{
    if (expr.startsWith('@')) {
        auto refTokenName = expr.mid(1);
        if (m_indexTokenTable.contains(refTokenName))
            m_indexTokenTable[tokenName] = QVariant(m_indexTokenTable[refTokenName]);
        else {
            qCDebug(lcHusTheme) << QString("Token(%1):Ref(%2) not found!").arg(expr, refTokenName);
        }
    } else if (expr.startsWith('$')) {
        parse$(m_indexTokenTable, tokenName, expr);
    } else if (expr.startsWith('#')) {
        /*! 按颜色处理 */
        auto color = QColor(expr);
        /*! 从预置颜色中获取 */
        if (expr.startsWith("Preset_"))
            color = HusColorGenerator::presetToColor(expr.mid(1));
        if (!color.isValid())
            qCDebug(lcHusTheme) << "Unknown color:" << expr;
        m_indexTokenTable[tokenName] = color;
    } else {
        /*! 按字符串处理 */
        m_indexTokenTable[tokenName] = expr;
    }
}

void HusThemePrivate::parseComponentExpr(QVariantMap *tokenMapPtr, const QString &tokenName, const QString &expr)
{
    if (expr.startsWith('@')) {
        auto refTokenName = expr.mid(1);
        if (m_indexTokenTable.contains(refTokenName)) {
            tokenMapPtr->insert(tokenName, m_indexTokenTable[refTokenName]);
        } else {
            qCDebug(lcHusTheme) << QString("Component: Token(%1):Ref(%2) not found!").arg(tokenName, refTokenName);
        }
    } else if (expr.startsWith('$')) {
        parse$(*tokenMapPtr, tokenName, expr);
    } else if (expr.startsWith('#')) {
        /*! 按颜色处理 */
        auto color = QColor(expr);
        /*! 从预置颜色中获取 */
        if (expr.startsWith("Preset_"))
            color = HusColorGenerator::presetToColor(expr.mid(1));
        if (!color.isValid())
            qCDebug(lcHusTheme) << QString("Component [%1]: Unknown color:") << expr;
        tokenMapPtr->insert(tokenName, color);
    } else {
        /*! 按字符串处理 */
        tokenMapPtr->insert(tokenName, expr);
    }
}

void HusThemePrivate::reloadIndexTheme()
{
    Q_Q(HusTheme);

    m_indexTokenTable.clear();
    q->m_Primary.clear();

    auto __init__ = m_indexObject["__init__"].toObject();
    auto __base__ = __init__["__base__"].toObject();

    auto colorTextBase = __base__["colorTextBase"].toString();
    auto colorBgBase = __base__["colorBgBase"].toString();
    auto colorTextBaseList = colorTextBase.split("|");
    auto colorBgBaseList = colorBgBase.split("|");

    Q_ASSERT_X(colorTextBaseList.size() == 2, "HusThemePrivate::reloadIndexTheme",
               QString("colorTextBase(%1) Must be in light:color|dark:color format").arg(colorTextBase).toStdString().c_str());
    Q_ASSERT_X(colorBgBaseList.size() == 2, "HusThemePrivate::reloadIndexTheme ",
               QString("colorBgBase(%1) Must be in light:color|dark:color format").arg(colorBgBase).toStdString().c_str());

    m_indexTokenTable["colorTextBase"] = q->isDark() ? colorTextBaseList.at(1) : colorTextBaseList.at(0);
    m_indexTokenTable["colorBgBase"] = q->isDark() ? colorBgBaseList.at(1) : colorBgBaseList.at(0);

    auto __vars__ = __init__["__vars__"].toObject();
    for (auto it = __vars__.constBegin(); it != __vars__.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        parseIndexExpr(it.key(), expr);
    }

    /*! Index.json<__style__> => Primary */
    auto __style__ = m_indexObject["__style__"].toObject();
    for (auto it = __style__.constBegin(); it != __style__.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        parseIndexExpr(it.key(), expr);
    }
    for (auto it = m_indexTokenTable.constBegin(); it != m_indexTokenTable.constEnd(); it++) {
        q->m_Primary[it.key()] = it.value();
    }
    emit q->PrimaryChanged();

    auto __component__ = m_indexObject["__component__"].toObject();
    for (auto it = __component__.constBegin(); it != __component__.constEnd(); it++) {
        registerDefaultComponentTheme(it.key(), it.value().toString());
    }
}

void HusThemePrivate::reloadComponentTheme(const QMap<QObject *, ThemeData> &dataMap)
{
    for (auto &themeData: dataMap) {
        for (auto it = themeData.componentMap.constBegin(); it != themeData.componentMap.constEnd(); it++) {
            auto componentName = it.key();
            auto componentTheme = it.value();
            reloadComponentThemeFile(themeData.themeObject, componentName, componentTheme);
        }
    }
}

bool HusThemePrivate::reloadComponentImport(QJsonObject &style, const QString &componentName)
{
    Q_Q(HusTheme);

    const auto __component__ = m_indexObject["__component__"].toObject();
    if (__component__.contains(componentName)) {
        const auto themePath = __component__[componentName].toString();
        if (QFile theme(themePath); theme.open(QIODevice::ReadOnly)) {
            QJsonParseError error;
            QJsonDocument themeDoc = QJsonDocument::fromJson(theme.readAll(), &error);
            if (error.error == QJsonParseError::NoError) {
                const auto object = themeDoc.object();
                const auto componentObject = themeDoc.object();
                const auto __init__ = object["__init__"].toObject();
                if (__init__.contains("__import__")) {
                    const auto __import__ = __init__["__import__"].toArray();
                    for (const auto &v : __import__) {
                        reloadComponentImport(style, v.toString());
                    }
                }
                /*QVariantMap tokenMap;
                if (__init__.contains("__vars__")) {
                    auto __vars__ = __init__["__vars__"].toObject();
                    for (auto it = __vars__.constBegin(); it != __vars__.constEnd(); it++) {
                        parseComponentExpr(&tokenMap, it.key(), it.value().toString().simplified());
                    }
                }
                for (auto it = tokenMap.constBegin(); it != tokenMap.constEnd(); it++) {
                    style[it.key()] = it.value().toString();
                }*/
                /*!
                 * 读取 <Component>.json<__style__> 中的变量
                 */
                const auto __style__ = componentObject["__style__"].toObject();
                for (auto it = __style__.constBegin(); it != __style__.constEnd(); it++) {
                    style[it.key()] = it.value();
                }
            } else {
                qCDebug(lcHusTheme) << QString("Parse import component theme [%1] faild:").arg(themePath) << error.errorString();
            }
        } else {
            qCDebug(lcHusTheme) << "Open import component theme faild:" << theme.errorString() << themePath;
        }
        return true;
    } else {
        return false;
    }
}

void HusThemePrivate::reloadComponentThemeFile(QObject *themeObject, const QString &componentName,
                                                   const ThemeData::Component &componentTheme)
{
    Q_Q(HusTheme);

    auto tokenMapPtr = componentTheme.tokenMap;
    auto installTokenMap = componentTheme.installTokenMap;

    auto style = QJsonObject();
    if (reloadComponentImport(style, componentName)) {
        for (auto it = style.constBegin(); it != style.constEnd(); it++) {
            parseComponentExpr(tokenMapPtr, it.key(), it.value().toString().simplified());
        }

        /*! 读取通过 @link installComponentToken() 安装的变量, 存在则覆盖, 否则添加 */
        for (auto it = installTokenMap.constBegin(); it != installTokenMap.constEnd(); it++) {
            parseComponentExpr(tokenMapPtr, it.key(), it.value());
        }

        auto signalName = componentName + "Changed";
        QMetaObject::invokeMethod(themeObject, signalName.toStdString().c_str());
    }
}

void HusThemePrivate::reloadDefaultComponentTheme()
{
    Q_Q(HusTheme);

    reloadComponentTheme(m_defaultTheme);
}

void HusThemePrivate::reloadCustomComponentTheme()
{
    Q_Q(HusTheme);

    reloadComponentTheme(m_customTheme);
}

void HusThemePrivate::registerDefaultComponentTheme(const QString &componentName, const QString &themePath)
{
    Q_Q(HusTheme);

    if (g_componentTable->contains(componentName)) {
        registerComponentTheme(q, componentName, g_componentTable->value(componentName), themePath, m_defaultTheme);
    }
}

void HusThemePrivate::registerComponentTheme(QObject *themeObject, const QString &component, QVariantMap *themeMap,
                                             const QString &themePath, QMap<QObject *, ThemeData> &dataMap)
{
    if (!themeObject || !themeMap) return;

    if (!dataMap.contains(themeObject))
        dataMap[themeObject] = ThemeData{};

    if (dataMap.contains(themeObject)) {
        dataMap[themeObject].themeObject = themeObject;
        dataMap[themeObject].componentMap[component].path = themePath;
        dataMap[themeObject].componentMap[component].tokenMap = themeMap;
    }
}

HusTheme *HusTheme::instance()
{
    static HusTheme *theme = new HusTheme;

    return theme;
}

HusTheme *HusTheme::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

bool HusTheme::isDark() const
{
    Q_D(const HusTheme);

    if (d->m_darkMode == DarkMode::System) {
        return d->m_helper->getColorScheme() == HusSystemThemeHelper::ColorScheme::Dark;
    } else {
        return d->m_darkMode == DarkMode::Dark;
    }
}

HusTheme::DarkMode HusTheme::darkMode() const
{
    Q_D(const HusTheme);

    return d->m_darkMode;
}

void HusTheme::setDarkMode(DarkMode mode)
{
    Q_D(HusTheme);

    if (d->m_darkMode != mode) {
        auto oldIsDark = isDark();
        d->m_darkMode = mode;
        if (oldIsDark != isDark()) {
            d->reloadIndexTheme();
            d->reloadDefaultComponentTheme();
            d->reloadCustomComponentTheme();
            emit isDarkChanged();
        }
        emit darkModeChanged();
    }
}

HusTheme::TextRenderType HusTheme::textRenderType() const
{
    Q_D(const HusTheme);

    return d->m_textRenderType;
}

void HusTheme::setTextRenderType(TextRenderType renderType)
{
    Q_D(HusTheme);

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    if (renderType == TextRenderType::CurveRendering) {
        renderType = TextRenderType::QtRendering;
        qCWarning(lcHusTheme) << "Qt5 is not supported TextRenderType::CurveRendering!";
    }
#endif
    if (d->m_textRenderType != renderType) {
        d->m_textRenderType = renderType;
        emit textRenderTypeChanged();
    }
}

QVariantMap HusTheme::sizeHint() const
{
    Q_D(const HusTheme);

    return d->m_sizeHintMap;
}

void HusTheme::registerCustomComponentTheme(QObject *themeObject, const QString &component, QVariantMap *themeMap, const QString &themePath)
{
    Q_D(HusTheme);

    d->registerComponentTheme(themeObject, component, themeMap, themePath, d->m_customTheme);
}

void HusTheme::reloadTheme()
{
    Q_D(HusTheme);

    if (QFile index(d->m_themeIndexPath); index.open(QIODevice::ReadOnly)) {
        QJsonParseError error;
        QJsonDocument indexDoc = QJsonDocument::fromJson(index.readAll(), &error);
        if (error.error == QJsonParseError::NoError) {
            d->m_indexObject = indexDoc.object();
            d->reloadIndexTheme();
            d->reloadDefaultComponentTheme();
            d->reloadCustomComponentTheme();
        } else {
            qCDebug(lcHusTheme) << "Index.json parse error:" << error.errorString();
        }
    } else {
        qCDebug(lcHusTheme) << "Index.json open faild:" << index.errorString();
    }
}
void HusTheme::installThemeColorTextBase(const QString &lightAndDark)
{
    Q_D(HusTheme);

    auto __init__ = d->m_indexObject["__init__"].toObject();
    auto __base__ = __init__["__base__"].toObject();
    __base__["colorTextBase"] = lightAndDark.simplified();
    __init__["__base__"] = __base__;
    d->m_indexObject["__init__"] = __init__;

    d->reloadIndexTheme();
    d->reloadDefaultComponentTheme();
    d->reloadCustomComponentTheme();
}

void HusTheme::installThemeColorBgBase(const QString &lightAndDark)
{
    Q_D(HusTheme);

    auto __init__ = d->m_indexObject["__init__"].toObject();
    auto __base__ = __init__["__base__"].toObject();
    __base__["colorBgBase"] = lightAndDark.simplified();
    __init__["__base__"] = __base__;
    d->m_indexObject["__init__"] = __init__;

    d->reloadIndexTheme();
    d->reloadDefaultComponentTheme();
    d->reloadCustomComponentTheme();
}

void HusTheme::installThemePrimaryColorBase(const QColor &colorBase)
{
    Q_D(HusTheme);

    installIndexToken("colorPrimaryBase", QString("$genColor(%1)").arg(colorBase.name()));
}

void HusTheme::installThemePrimaryFontSizeBase(int fontSizeBase)
{
    Q_D(HusTheme);

    installIndexToken("fontSizeBase", QString("$genFontSize(%1)").arg(fontSizeBase));
}

void HusTheme::installThemePrimaryFontFamiliesBase(const QString &familiesBase)
{
    Q_D(HusTheme);

    installIndexToken("fontFamilyBase", QString("$genFontFamily(%1)").arg(familiesBase));
}

void HusTheme::installThemePrimaryRadiusBase(int radiusBase)
{
    Q_D(HusTheme);

    installIndexToken("radiusBase", QString("$genRadius(%1)").arg(radiusBase));
}

void HusTheme::installThemePrimaryAnimationBase(int durationFast, int durationMid, int durationSlow)
{
    Q_D(HusTheme);

    auto __style__ = d->m_indexObject["__style__"].toObject();
    __style__["durationFast"] = QString::number(durationFast);
    __style__["durationMid"] = QString::number(durationMid);
    __style__["durationSlow"] = QString::number(durationSlow);
    d->m_indexObject["__style__"] = __style__;

    d->reloadIndexTheme();
    d->reloadDefaultComponentTheme();
    d->reloadCustomComponentTheme();
}

void HusTheme::installSizeHintRatio(const QString &size, qreal ratio)
{
    Q_D(HusTheme);

    bool change = false;
    if (d->m_sizeHintMap.contains(size)) {
        auto value = d->m_sizeHintMap.value(size).toDouble();
        if (!qFuzzyCompare(value, ratio)) {
            change = true;
        }
    } else {
        change = true;
    }

    if (change) {
        d->m_sizeHintMap[size] = ratio;
        emit sizeHintChanged();
    }
}

void HusTheme::installIndexTheme(const QString &themePath)
{
    Q_D(HusTheme);

    if (themePath != d->m_themeIndexPath) {
        if (themePath.isEmpty())
            d->m_themeIndexPath = ":/HuskarUI/theme/Index.json";
        else
            d->m_themeIndexPath = themePath;

        reloadTheme();
    }
}

void HusTheme::installIndexToken(const QString &token, const QString &value)
{
    Q_D(HusTheme);

    auto __init__ = d->m_indexObject["__init__"].toObject();
    auto __vars__ = __init__["__vars__"].toObject();
    __vars__[token] = value.simplified();
    __init__["__vars__"] = __vars__;
    d->m_indexObject["__init__"] = __init__;

    d->reloadIndexTheme();
    d->reloadDefaultComponentTheme();
    d->reloadCustomComponentTheme();
}

void HusTheme::installComponentTheme(const QString &component, const QString &themePath)
{
    Q_D(HusTheme);

    auto __component__ = d->m_indexObject["__component__"].toObject();
    if (__component__.contains(component)) {
        __component__[component] = themePath;
        d->m_indexObject["__component__"] = __component__;
        d->reloadDefaultComponentTheme();
    } else {
        qCWarning(lcHusTheme) << QString("Component [%1] not found!").arg(component);
    }
}

void HusTheme::installComponentToken(const QString &component, const QString &token, const QString &value)
{
    Q_D(HusTheme);

    for (auto &theme: d->m_defaultTheme) {
        if (theme.componentMap.contains(component)) {
            theme.componentMap[component].installTokenMap.insert(token, value);
            d->reloadComponentThemeFile(theme.themeObject, component, theme.componentMap[component]);
            return;
        }
    }

    for (auto &theme: d->m_customTheme) {
        if (theme.componentMap.contains(component)) {
            theme.componentMap[component].installTokenMap.insert(token, value);
            d->reloadComponentThemeFile(theme.themeObject, component, theme.componentMap[component]);
            return;
        }
    }

    qCWarning(lcHusTheme) << QString("Component [%1] not found!").arg(component);
}

HusTheme::HusTheme(QObject *parent)
    : QObject{parent}
    , d_ptr(new HusThemePrivate(this))
{
    Q_D(HusTheme);

    d->initializeComponentPropertyHash();

    d->m_helper = new HusSystemThemeHelper(this);
    connect(d->m_helper, &HusSystemThemeHelper::colorSchemeChanged, this, [this]{
        Q_D(HusTheme);
        if (d->m_darkMode == DarkMode::System) {
            d->reloadIndexTheme();
            d->reloadDefaultComponentTheme();
            d->reloadCustomComponentTheme();
            emit isDarkChanged();
        }
    });

    d->m_sizeHintMap["small"] = 0.8;
    d->m_sizeHintMap["normal"] = 1.0;
    d->m_sizeHintMap["large"] = 1.25;

    reloadTheme();
}

HusTheme::~HusTheme()
{

}
