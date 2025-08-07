#include "hustheme_p.h"
#include "huscolorgenerator.h"
#include "husthemefunctions.h"

#include <QtCore/QFile>
#include <QtGui/QFont>

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
                    qDebug() << QString("func genColor() invalid color:(%1)").arg(args);
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
                    qDebug() << QString("func genFontSize() invalid size:(%1)").arg(args);
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
                    qDebug() << QString("func genFontLineHeight() invalid size:(%1)").arg(args);
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
                    qDebug() << QString("func genRadius() invalid size:(%1)").arg(args);
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
                    qDebug() << QString("func darker() only accepts 1/2 parameters:(%1)").arg(args);
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
                    qDebug() << QString("func lighter() only accepts 1/2 parameters:(%1)").arg(args);
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
                    arg1.setAlphaF(arg2);
                    out[tokenName] = HusThemeFunctions::alpha(arg1, arg2);
                } else {
                    qDebug() << QString("func alpha() only accepts 1/2 parameters:(%1)").arg(args);
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
                    qDebug() << QString("func onBackground() only accepts 2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Multiply:
            {
                auto argList = args.split(',');
                if (argList.length() == 2) {
                    auto arg1 = numberFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[tokenName] = HusThemeFunctions::multiply(arg1, arg2);
                } else {
                    qDebug() << QString("func multiply() only accepts 2 parameters:(%1)").arg(args);
                }
            } break;
            default:
                break;
            }
        } else {
            qDebug() << "Unknown func name:" << func;
        }
    } else {
        qDebug() << "Unknown expr:" << expr;
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
                qDebug() << QString("Token toColor faild:(%1)").arg(tokenName);
            }
        } else {
            qDebug() << QString("Index Token(%1) not found!").arg(refTokenName);
        }
    } else {
        /*! 按颜色处理 */
        color = QColor(tokenName);
        /*! 从预置颜色中获取 */
        if (tokenName.startsWith("#Preset_"))
            color = HusColorGenerator::presetToColor(tokenName.mid(1));
        if (!color.isValid()) {
            qDebug() << QString("Token toColor faild:(%1)").arg(tokenName);
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
                qDebug() << QString("Token toDouble faild:(%1)").arg(refTokenName);
            }
        } else {
            qDebug() << QString("Index Token(%1) not found!").arg(refTokenName);
        }
    } else {
        auto ok = false;
        number = tokenName.toDouble(&ok);
        if (!ok) {
            qDebug() << QString("Token toDouble faild:(%1)").arg(tokenName);
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
            qDebug() << QString("Token(%1):Ref(%2) not found!").arg(expr, refTokenName);
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
            qDebug() << "Unknown color:" << expr;
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
            qDebug() << QString("Component: Token(%1):Ref(%2) not found!").arg(tokenName, refTokenName);
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
            qDebug() << QString("Component [%1]: Unknown color:") << expr;
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

    auto colorTextBase = m_indexObject["colorTextBase"].toString();
    auto colorBgBase = m_indexObject["colorBgBase"].toString();
    auto colorTextBaseList = colorTextBase.split("|");
    auto colorBgBaseList = colorBgBase.split("|");

    Q_ASSERT_X(colorTextBaseList.size() == 2, "HusThemePrivate",
               QString("colorTextBase(%1) Must be in light:color|dark:color format").arg(colorTextBase).toStdString().c_str());
    Q_ASSERT_X(colorBgBaseList.size() == 2, "HusThemePrivate",
               QString("colorBgBase(%1) Must be in light:color|dark:color format").arg(colorBgBase).toStdString().c_str());

    m_indexTokenTable["colorTextBase"] = q->isDark() ? colorTextBaseList.at(1) : colorTextBaseList.at(0);
    m_indexTokenTable["colorBgBase"] = q->isDark() ? colorBgBaseList.at(1) : colorBgBaseList.at(0);

    auto variableTable = m_indexObject["%VariableTable%"].toObject();
    for (auto it = variableTable.constBegin(); it != variableTable.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        parseIndexExpr(it.key(), expr);
    }
    auto primaryColorStyle = m_indexObject["primaryColorStyle"].toObject();
    for (auto it = primaryColorStyle.constBegin(); it != primaryColorStyle.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        parseIndexExpr(it.key(), expr);
    }
    auto primaryFontStyle = m_indexObject["primaryFontStyle"].toObject();
    for (auto it = primaryFontStyle.constBegin(); it != primaryFontStyle.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        parseIndexExpr(it.key(), expr);
    }
    auto primaryRadius = m_indexObject["primaryRadius"].toObject();
    for (auto it = primaryRadius.constBegin(); it != primaryRadius.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        parseIndexExpr(it.key(), expr);
    }
    auto primaryAnimation = m_indexObject["primaryAnimation"].toObject();
    for (auto it = primaryAnimation.constBegin(); it != primaryAnimation.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        parseIndexExpr(it.key(), expr);
    }
    /*! Index.json => Primary */
    for (auto it = m_indexTokenTable.constBegin(); it != m_indexTokenTable.constEnd(); it++) {
        q->m_Primary[it.key()] = it.value();
    }
    emit q->PrimaryChanged();
    auto componentStyle = m_indexObject["componentStyle"].toObject();
    for (auto it = componentStyle.constBegin(); it != componentStyle.constEnd(); it++) {
        registerDefaultComponentTheme(it.key(), it.value().toString());
    }
}

void HusThemePrivate::reloadComponentTheme(const QMap<QObject *, ThemeData> &dataMap)
{
    for (const auto &themeData: dataMap) {
        for (auto it = themeData.componentMap.begin(); it != themeData.componentMap.end(); it++) {
            auto componentName = it.key();
            auto componentTheme = it.value();
            reloadComponentThemeFile(themeData.themeObject, componentName, componentTheme);
        }
    }
}

void HusThemePrivate::reloadComponentThemeFile(QObject *themeObject, const QString &componentName,
                                                   const ThemeData::Component &componentTheme)
{
    if (QFile theme(componentTheme.path); theme.open(QIODevice::ReadOnly)) {
        QJsonParseError error;
        QJsonDocument themeDoc = QJsonDocument::fromJson(theme.readAll(), &error);
        if (error.error == QJsonParseError::NoError) {
            auto tokenMapPtr = componentTheme.tokenMap;
            auto installTokenMap = componentTheme.installTokenMap;
            auto object = themeDoc.object();
            /*! 读取 <Component>.json 文件中的变量 */
            for (auto it = object.constBegin(); it != object.constEnd(); it++) {
                parseComponentExpr(tokenMapPtr, it.key(), it.value().toString());
            }
            /*! 读取通过 @link installComponentToken() 安装的变量, 存在则覆盖, 否则添加 */
            for (auto it = installTokenMap.constBegin(); it != installTokenMap.constEnd(); it++) {
                parseComponentExpr(tokenMapPtr, it.key(), it.value());
            }
            auto signalName = componentName + "Changed";
            QMetaObject::invokeMethod(themeObject, signalName.toStdString().c_str());
        } else {
            qDebug() << QString("Parse theme [%1] faild:").arg(componentTheme.path) << error.errorString();
        }
    } else {
        qDebug() << "Open theme faild:" << theme.errorString() << componentTheme.path;
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

void HusThemePrivate::registerDefaultComponentTheme(const QString &component, const QString &themePath)
{
    Q_Q(HusTheme);

#define ADD_COMPONENT_CASE(ComponentName) \
    case Component::ComponentName: \
    registerComponentTheme(q, component, &q->m_##ComponentName, themePath, m_defaultTheme); break;

    if (g_componentTable.contains(component)) {
        switch (auto key = g_componentTable[component]; key) {
            ADD_COMPONENT_CASE(HusButton)
            ADD_COMPONENT_CASE(HusIconText)
            ADD_COMPONENT_CASE(HusCopyableText)
            ADD_COMPONENT_CASE(HusCaptionButton)
            ADD_COMPONENT_CASE(HusTour)
            ADD_COMPONENT_CASE(HusMenu)
            ADD_COMPONENT_CASE(HusDivider)
            ADD_COMPONENT_CASE(HusSwitch)
            ADD_COMPONENT_CASE(HusScrollBar)
            ADD_COMPONENT_CASE(HusSlider)
            ADD_COMPONENT_CASE(HusTabView)
            ADD_COMPONENT_CASE(HusToolTip)
            ADD_COMPONENT_CASE(HusSelect)
            ADD_COMPONENT_CASE(HusInput)
            ADD_COMPONENT_CASE(HusRate)
            ADD_COMPONENT_CASE(HusRadio)
            ADD_COMPONENT_CASE(HusCheckBox)
            ADD_COMPONENT_CASE(HusTimePicker)
            ADD_COMPONENT_CASE(HusDrawer)
            ADD_COMPONENT_CASE(HusCollapse)
            ADD_COMPONENT_CASE(HusCard)
            ADD_COMPONENT_CASE(HusPagination)
            ADD_COMPONENT_CASE(HusPopup)
            ADD_COMPONENT_CASE(HusTimeline)
            ADD_COMPONENT_CASE(HusTag)
            ADD_COMPONENT_CASE(HusTableView)
            ADD_COMPONENT_CASE(HusMessage)
            ADD_COMPONENT_CASE(HusAutoComplete)
            ADD_COMPONENT_CASE(HusDatePicker)
            ADD_COMPONENT_CASE(HusProgress)
            ADD_COMPONENT_CASE(HusCarousel)
            ADD_COMPONENT_CASE(HusBreadcrumb)
            ADD_COMPONENT_CASE(HusImage)
        default:
            break;
        }
    }
}

void HusThemePrivate::registerComponentTheme(QObject *themeObject, const QString &component, QVariantMap *themeMap,
                                             const QString &themePath, QMap<QObject *, ThemeData> &dataMap)
{
    if (!themeObject || !themeMap) return;

    if (!dataMap.contains(themeObject))
        dataMap[themeObject] = {};

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
    instance()->reloadTheme();

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
        qWarning() << "Qt5 is not supported TextRenderType::CurveRendering!";
    }
#endif
    if (d->m_textRenderType != renderType) {
        d->m_textRenderType = renderType;
        emit textRenderTypeChanged();
    }
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
            qDebug() << "Index.json parse error:" << error.errorString();
        }
    } else {
        qDebug() << "Index.json open faild:" << index.errorString();
    }
}
void HusTheme::installThemeColorTextBase(const QString &lightAndDark)
{
    Q_D(HusTheme);

    d->m_indexObject["colorTextBase"] = lightAndDark.simplified();
    d->reloadIndexTheme();
    d->reloadDefaultComponentTheme();
    d->reloadCustomComponentTheme();
}

void HusTheme::installThemeColorBgBase(const QString &lightAndDark)
{
    Q_D(HusTheme);

    d->m_indexObject["colorBgBase"] = lightAndDark.simplified();
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

    auto primaryAnimation = d->m_indexObject["primaryAnimation"].toObject();
    primaryAnimation["durationFast"] = QString::number(durationFast);
    primaryAnimation["durationMid"] = QString::number(durationMid);
    primaryAnimation["durationSlow"] = QString::number(durationSlow);
    d->m_indexObject["primaryAnimation"] = primaryAnimation;
    d->reloadIndexTheme();
    d->reloadDefaultComponentTheme();
    d->reloadCustomComponentTheme();
}

void HusTheme::installIndexTheme(const QString &themePath)
{
    Q_D(HusTheme);

    d->m_themeIndexPath = themePath;

    reloadTheme();
}

void HusTheme::installIndexToken(const QString &token, const QString &value)
{
    Q_D(HusTheme);

    auto variableTable = d->m_indexObject["%VariableTable%"].toObject();
    variableTable[token] = value.simplified();
    d->m_indexObject["%VariableTable%"] = variableTable;
    d->reloadIndexTheme();
    d->reloadDefaultComponentTheme();
    d->reloadCustomComponentTheme();
}

void HusTheme::installComponentTheme(const QString &component, const QString &themePath)
{
    Q_D(HusTheme);

    auto componentStyle = d->m_indexObject["componentStyle"].toObject();
    if (componentStyle.contains(component)) {
        componentStyle[component] = themePath;
        d->m_indexObject["componentStyle"] = componentStyle;
        d->reloadDefaultComponentTheme();
    } else {
        qWarning() << QString("Component [%1] not found!").arg(component);
    }
}

void HusTheme::installComponentToken(const QString &component, const QString &token, const QString &value)
{
    Q_D(HusTheme);

    if (d->m_defaultTheme.contains(this)) {
        auto &componentMap = d->m_defaultTheme[this].componentMap;
        if (componentMap.contains(component)) {
            componentMap[component].installTokenMap.insert(token, value);
            d->reloadComponentThemeFile(d->m_defaultTheme[this].themeObject, component, componentMap[component]);
        } else {
            qWarning() << QString("Component [%1] not found!").arg(component);
        }
    }
}

HusTheme::HusTheme(QObject *parent)
    : QObject{parent}
    , d_ptr(new HusThemePrivate(this))
{
    Q_D(HusTheme);

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
}

HusTheme::~HusTheme()
{

}
