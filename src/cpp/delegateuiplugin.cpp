#include <QtQml/qqmlextensionplugin.h>

extern void qml_register_types_DelegateUI();
Q_GHS_KEEP_REFERENCE(qml_register_types_DelegateUI);

class DelegateUIPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    DelegateUIPlugin(QObject *parent = nullptr) : QQmlEngineExtensionPlugin(parent)
    {
        volatile auto registration = &qml_register_types_DelegateUI;
        Q_UNUSED(registration);
    }
};

#include "delegateuiplugin.moc"
