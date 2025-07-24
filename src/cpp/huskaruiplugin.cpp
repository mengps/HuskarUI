#include <QtQml/qqmlextensionplugin.h>

extern void qml_register_types_HuskarUI();
Q_GHS_KEEP_REFERENCE(qml_register_types_HuskarUI);

class HuskarUIPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    HuskarUIPlugin(QObject *parent = nullptr) : QQmlEngineExtensionPlugin(parent)
    {
        volatile auto registration = &qml_register_types_HuskarUI;
        Q_UNUSED(registration);
    }
};

#include "huskaruiplugin.moc"
