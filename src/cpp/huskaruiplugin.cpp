#include <QtCore/qtsymbolmacros.h>
#include <QtQml/qqmlextensionplugin.h>

#include "husapp.h"

QT_DECLARE_EXTERN_SYMBOL_VOID(qml_register_types_HuskarUI_Basic)

class HuskarUI_BasicPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

public:
    HuskarUI_BasicPlugin(QObject *parent = nullptr) : QQmlEngineExtensionPlugin(parent)
    {
        QT_KEEP_SYMBOL(qml_register_types_HuskarUI_Basic)
    }

    void initializeEngine(QQmlEngine *engine, const char *) override
    {
        HusApp::initialize(engine);
    }
};

#include "huskaruiplugin.moc"
