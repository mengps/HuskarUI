#include "huswindowagent.h"

HusWindowAgent::HusWindowAgent(QObject *parent)
    : QWK::QuickWindowAgent{parent}
{

}

HusWindowAgent::~HusWindowAgent()
{

}

void HusWindowAgent::classBegin()
{
    auto p = parent();
    Q_ASSERT_X(p, "HusWindowAgent", "parent() return nullptr!");
    if (p) {
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        if (p->objectName() == QLatin1StringView("__HusWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
#else
        if (p->objectName() == QLatin1String("__HusWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
#endif
    }
}

void HusWindowAgent::componentComplete()
{

}
