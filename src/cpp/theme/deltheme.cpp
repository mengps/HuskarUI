#include "deltheme_p.h"
#include "delcolorgenerator.h"
#include "delthemefunctions.h"

void DelThemePrivate::parse$(QMap<QString, QVariant> &out, const QString &varName, const QString &expr)
{
    Q_Q(DelTheme);

    static QHash<QString, Function> g_funcTable {
        { "genColor",          Function::GenColor },
        { "genFontSize",       Function::GenFontSize },
        { "genFontLineHeight", Function::GenFontLineHeight },
        { "darker",            Function::Darker },
        { "lighter",           Function::Lighter },
        { "alpha",             Function::Alpha },
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
                QColor color(args);
                if (color.isValid()) {
                    auto colorBgBase = m_indexVariableTable["colorBgBase"].value<QColor>();
                    auto colors = DelThemeFunctions::genColor(args, !q->isDark(), colorBgBase);
                    if (q->isDark()) {
                        /*! 暗黑模式需要翻转色表 */
                        std::reverse(colors.begin(), colors.end());
                    }
                    for (int i = 0; i < colors.length(); i++) {
                        auto genColor = colors.at(i);
                        auto key = varName + "-" + QString::number(i + 1);
                        out[key] = genColor;
                    }
                } else {
                    qDebug() << QString("func genColor() invalid color:(%1)").arg(args);
                }
            } break;
            case Function::GenFontSize:
            {
                bool ok = false;
                auto base = args.toDouble(&ok);
                if (ok) {
                    const auto fontSizes = DelThemeFunctions::genFontSize(base);
                    for (int i = 0; i < fontSizes.length(); i++) {
                        auto genFontSize = fontSizes.at(i);
                        auto key = varName + "-" + QString::number(i + 1);
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
                    const auto fontLineHeights = DelThemeFunctions::genFontLineHeight(base);
                    for (int i = 0; i < fontLineHeights.length(); i++) {
                        auto genFontLineHeight = fontLineHeights.at(i);
                        auto key = varName + "-" + QString::number(i + 1);
                        out[key] = genFontLineHeight;
                    }
                } else {
                    qDebug() << QString("func genFontLineHeight() invalid size:(%1)").arg(args);
                }
            } break;
            case Function::Darker:
            {
                auto argList = args.split(',');
                if (argList.length() == 1) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    out[varName] = DelThemeFunctions::darker(arg1);
                } else if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[varName] = DelThemeFunctions::darker(arg1, arg2);
                } else {
                    qDebug() << QString("func darker() only accepts 1/2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Lighter:
            {
                auto argList = args.split(',');
                if (argList.length() == 1) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    out[varName] = DelThemeFunctions::lighter(arg1);
                } else if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[varName] = DelThemeFunctions::lighter(arg1, arg2);
                } else {
                    qDebug() << QString("func lighter() only accepts 1/2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Alpha:
            {
                auto argList = args.split(',');
                if (argList.length() == 1) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    out[varName] = DelThemeFunctions::alpha(arg1);
                } else if (argList.length() == 2) {
                    auto arg1 = colorFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    arg1.setAlphaF(arg2);
                    out[varName] = DelThemeFunctions::alpha(arg1, arg2);
                } else {
                    qDebug() << QString("func alpha() only accepts 1/2 parameters:(%1)").arg(args);
                }
            } break;
            case Function::Multiply:
            {
                auto argList = args.split(',');
                if (argList.length() == 2) {
                    auto arg1 = numberFromIndexTable(argList.at(0));
                    auto arg2 = numberFromIndexTable(argList.at(1));
                    out[varName] = DelThemeFunctions::multiply(arg1, arg2);
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

QColor DelThemePrivate::colorFromIndexTable(const QString &varName)
{
    QColor color;
    auto refVarName = varName;
    if (refVarName.startsWith('@')) {
        refVarName = varName.mid(1);
        if (m_indexVariableTable.contains(refVarName)) {
            auto var = m_indexVariableTable[refVarName];
            color = var.value<QColor>();
            if (!color.isValid()) {
                qDebug() << QString("Var toColor faild:(%1)").arg(varName);
            }
        } else {
            qDebug() << QString("Index Var(%1) not found!").arg(refVarName);
        }
    } else {
        /*! 按颜色处理 */
        color = QColor(varName);
        /*! 从预置颜色中获取 */
        if (varName.startsWith("#Preset_"))
            color = DelColorGenerator::presetToColor(varName.mid(1));
        if (!color.isValid()) {
            qDebug() << QString("Var toColor faild:(%1)").arg(varName);
        }
    }

    return color;
}

qreal DelThemePrivate::numberFromIndexTable(const QString &varName)
{
    qreal number = 0;
    auto refVarName = varName;
    if (refVarName.startsWith('@')) {
        refVarName = varName.mid(1);
        if (m_indexVariableTable.contains(refVarName)) {
            auto var = m_indexVariableTable[refVarName];
            auto ok = false;
            number = var.toDouble(&ok);
            if (!ok) {
                qDebug() << QString("Var toDouble faild:(%1)").arg(refVarName);
            }
        } else {
            qDebug() << QString("Index Var(%1) not found!").arg(refVarName);
        }
    } else {
        auto ok = false;
        number = varName.toDouble(&ok);
        if (!ok) {
            qDebug() << QString("Var toDouble faild:(%1)").arg(varName);
        }
    }

    return number;
}

void DelThemePrivate::indexExprParse(const QString &varName, const QString &expr)
{
    if (expr.startsWith('@')) {
        auto refVarName = expr.mid(1);
        if (m_indexVariableTable.contains(refVarName))
            m_indexVariableTable[varName] = QVariant(m_indexVariableTable[refVarName]);
        else {
            qDebug() << QString("Var(%1) not found!").arg(expr);
        }
    } else if (expr.startsWith('$')) {
        parse$(m_indexVariableTable, varName, expr);
    } else if (expr.startsWith('#')) {
        /*! 按颜色处理 */
        auto color = QColor(expr);
        /*! 从预置颜色中获取 */
        if (expr.startsWith("Preset_"))
            color = DelColorGenerator::presetToColor(expr.mid(1));
        if (!color.isValid())
            qDebug() << "Unknown color:" << expr;
        m_indexVariableTable[varName] = color;
    } else {
        /*! 按字符串处理 */
        m_indexVariableTable[varName] = expr;
    }
}

void DelThemePrivate::reloadIndexTheme()
{
    Q_Q(DelTheme);

    m_indexVariableTable.clear();
    q->m_Primary.clear();

    auto colorTextBase = m_indexObject["colorTextBase"].toString();
    auto colorBgBase = m_indexObject["colorBgBase"].toString();
    auto colorTextBaseList = colorTextBase.split("|");
    auto colorBgBaseList = colorBgBase.split("|");

    Q_ASSERT_X(colorTextBaseList.size() == 2, "DelThemePrivate",
               QString("colorTextBase(%1) Must be in color|color format").arg(colorTextBase).toStdString().c_str());
    Q_ASSERT_X(colorBgBaseList.size() == 2, "DelThemePrivate",
               QString("colorBgBase(%1) Must be in color|color format").arg(colorBgBase).toStdString().c_str());

    m_indexVariableTable["colorTextBase"] = q->isDark() ? colorTextBaseList.at(1) : colorTextBaseList.at(0);
    m_indexVariableTable["colorBgBase"] = q->isDark() ? colorBgBaseList.at(1) : colorBgBaseList.at(0);

    auto variableTable = m_indexObject["%VariableTable%"].toObject();
    for (auto it = variableTable.constBegin(); it != variableTable.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        indexExprParse(it.key(), expr);
    }
    auto primaryColorStyle = m_indexObject["primaryColorStyle"].toObject();
    for (auto it = primaryColorStyle.constBegin(); it != primaryColorStyle.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        indexExprParse(it.key(), expr);
    }
    auto primaryFontStyle = m_indexObject["primaryFontStyle"].toObject();
    for (auto it = primaryFontStyle.constBegin(); it != primaryFontStyle.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        indexExprParse(it.key(), expr);
    }
    auto primaryAnimation = m_indexObject["primaryAnimation"].toObject();
    for (auto it = primaryAnimation.constBegin(); it != primaryAnimation.constEnd(); it++) {
        auto expr = it.value().toString().simplified();
        indexExprParse(it.key(), expr);
    }
    /*! Index.json => Primary */
    for (auto it = m_indexVariableTable.constBegin(); it != m_indexVariableTable.constEnd(); it++) {
        q->m_Primary[it.key()] = it.value();
    }
    emit q->PrimaryChanged();
    auto componentStyle = m_indexObject["componentStyle"].toObject();
    for (auto it = componentStyle.constBegin(); it != componentStyle.constEnd(); it++) {
        registerDefaultThemeComponent(it.key(), it.value().toString());
    }
}

void DelThemePrivate::reloadComponentTheme(QMap<QObject *, ThemeData> &dataMap)
{
    for (auto &ct: dataMap) {
        for (auto it = ct.component.begin(); it != ct.component.end(); it++) {
            auto component = it.value();
            auto componentName = it.key();
            auto map_ptr = component.varMap;
            QFile theme(component.path);
            if (theme.open(QIODevice::ReadOnly)) {
                QJsonParseError error;
                QJsonDocument themeDoc = QJsonDocument::fromJson(theme.readAll(), &error);
                if (error.error == QJsonParseError::NoError) {
                    auto object = themeDoc.object();
                    for (auto o_it = object.constBegin(); o_it != object.constEnd(); o_it++) {
                        auto key = o_it.key();
                        auto value = object[key].toString();
                        if (value.startsWith('@')) {
                            auto refVarName = value.mid(1);
                            if (m_indexVariableTable.contains(refVarName)) {
                                map_ptr->insert(key, m_indexVariableTable[refVarName]);
                            } else {
                                qDebug() << QString("Component [%1]: Var(%2) not found!").arg(key, refVarName);
                            }
                        } else if (value.startsWith('$')) {
                            parse$(*map_ptr, key, value);
                        } else if (value.startsWith('#')) {
                            /*! 按颜色处理 */
                            auto color = QColor(value);
                            /*! 从预置颜色中获取 */
                            if (value.startsWith("Preset_"))
                                color = DelColorGenerator::presetToColor(value.mid(1));
                            if (!color.isValid())
                                qDebug() << QString("Component [%1]: Unknown color:") << value;
                            map_ptr->insert(key, color);
                        } else {
                            /*! 按字符串处理 */
                            map_ptr->insert(key, value);
                        }
                    }
                    auto signalName = componentName + "Changed";
                    QMetaObject::invokeMethod(ct.theme, signalName.toStdString().c_str());
                } else {
                    qDebug() << QString("Parse theme [%1] faild:").arg(component.path) << error.errorString();
                }
            } else {
                qDebug() << "Open theme faild:" << theme.errorString() << component.path;
            }
        }
    }
}

void DelThemePrivate::reloadComponentDefaultTheme()
{
    Q_Q(DelTheme);

    reloadComponentTheme(m_defaultTheme);
}

void DelThemePrivate::reloadComponentCustomTheme()
{
    Q_Q(DelTheme);

    reloadComponentTheme(m_customTheme);
}

void DelThemePrivate::registerDefaultThemeComponent(const QString &component, const QString &themePath)
{
    Q_Q(DelTheme);

#define ADD_COMPONENT_CASE(ComponentName) case Component::ComponentName: registerThemeComponent(q, component, &q->m_##ComponentName, themePath, m_defaultTheme); break;

    if (g_componentTable.contains(component)) {
        auto key = g_componentTable[component];
        switch (key) {
            ADD_COMPONENT_CASE(DelButton)
            ADD_COMPONENT_CASE(DelIconText)
            ADD_COMPONENT_CASE(DelCopyableText)
            ADD_COMPONENT_CASE(DelCaptionButton)
            ADD_COMPONENT_CASE(DelTour)
            ADD_COMPONENT_CASE(DelMenu)
            ADD_COMPONENT_CASE(DelDivider)
            ADD_COMPONENT_CASE(DelSwitch)
            ADD_COMPONENT_CASE(DelScrollBar)
            ADD_COMPONENT_CASE(DelSlider)
            ADD_COMPONENT_CASE(DelTabView)
            ADD_COMPONENT_CASE(DelToolTip)
            ADD_COMPONENT_CASE(DelSelect)
            ADD_COMPONENT_CASE(DelInput)
            ADD_COMPONENT_CASE(DelRate)
            ADD_COMPONENT_CASE(DelRadio)
        default:
            break;
        }
    }
}

void DelThemePrivate::registerThemeComponent(QObject *theme, const QString &component, QVariantMap *themeMap,
                                             const QString &themePath, QMap<QObject *, ThemeData> &dataMap)
{
    if (!theme || !themeMap) return;

    if (!dataMap.contains(theme))
        dataMap[theme] = {};

    if (dataMap.contains(theme)) {
        dataMap[theme].theme = theme;
        dataMap[theme].component[component].path = themePath;
        dataMap[theme].component[component].varMap = themeMap;
    }
}

DelTheme *DelTheme::instance()
{
    static DelTheme *theme = new DelTheme;

    return theme;
}

DelTheme *DelTheme::create(QQmlEngine *, QJSEngine *)
{
    instance()->reloadDefaultTheme();

    return instance();
}

bool DelTheme::isDark() const
{
    Q_D(const DelTheme);

    if (m_darkMode == int(DarkMode::System)) {
        return d->m_helper->getColorScheme() == DelSystemThemeHelper::ColorScheme::Dark;
    } else {
        return m_darkMode == int(DarkMode::Dark);
    }
}

void DelTheme::registerComponentCustomTheme(QObject *theme, const QString &component, QVariantMap *themeMap, const QString &themePath)
{
    Q_D(DelTheme);

    d->registerThemeComponent(theme, component, themeMap, themePath, d->m_customTheme);
}

void DelTheme::reloadDefaultTheme()
{
    Q_D(DelTheme);

    QFile index(d->m_themeIndexPath);
    if (index.open(QIODevice::ReadOnly)) {
        QJsonParseError error;
        QJsonDocument indexDoc = QJsonDocument::fromJson(index.readAll(), &error);
        if (error.error == QJsonParseError::NoError) {
            d->m_indexObject = indexDoc.object();
            d->reloadIndexTheme();
            d->reloadComponentDefaultTheme();
            d->reloadComponentCustomTheme();
        } else {
            qDebug() << "Index.json parse error:" << error.errorString();
        }
    } else {
        qDebug() << "Index.json open faild:" << index.errorString();
    }
}

void DelTheme::installThemePrimaryColor(const QColor &color)
{
    Q_D(DelTheme);

    installIndexThemeKV("colorPrimaryBase", QString("$genColor(%1)").arg(color.name()));
}

void DelTheme::installThemePrimaryFontSize(int fontSize)
{
    Q_D(DelTheme);

    installIndexThemeKV("fontSizeBase", QString("$genFontSize(%1)").arg(fontSize));
}

void DelTheme::installThemePrimaryFontFamily(const QString &family)
{
    Q_D(DelTheme);

    installIndexThemeKV("fontPrimaryFamily", family);
}

void DelTheme::installIndexTheme(const QString &themePath)
{
    Q_D(DelTheme);

    d->m_themeIndexPath = themePath;
    d->reloadIndexTheme();
}

void DelTheme::installIndexThemeKV(const QString &key, const QString &value)
{
    Q_D(DelTheme);

    auto variableTable = d->m_indexObject["%VariableTable%"].toObject();
    variableTable[key] = value.simplified();
    d->m_indexObject["%VariableTable%"] = variableTable;
    d->reloadIndexTheme();
    d->reloadComponentDefaultTheme();
    d->reloadComponentCustomTheme();
}

void DelTheme::installIndexThemeJSON(const QString &json)
{

}

void DelTheme::installComponentTheme(const QString &componenet, const QString &themePath)
{

}

void DelTheme::installComponentThemeKV(const QString &componenet, const QString &key, const QString &value)
{

}

void DelTheme::installComponentThemeJSON(const QString &componenet, const QString &json)
{

}

DelTheme::DelTheme(QObject *parent)
    : QObject{parent}
    , d_ptr(new DelThemePrivate(this))
{
    Q_D(DelTheme);

    d->m_helper = new DelSystemThemeHelper(this);

    setDarkMode(int(DarkMode::Light));

    connect(this, &DelTheme::darkModeChanged, this, [this]{
        Q_D(DelTheme);
        d->reloadIndexTheme();
        d->reloadComponentDefaultTheme();
        d->reloadComponentCustomTheme();
        emit isDarkChanged();
    });
    connect(d->m_helper, &DelSystemThemeHelper::colorSchemeChanged, this, [this]{
        if (m_darkMode == int(DarkMode::System)) {
            emit isDarkChanged();
        }
    });
}

DelTheme::~DelTheme()
{

}
