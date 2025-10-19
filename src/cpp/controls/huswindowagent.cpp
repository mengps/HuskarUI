#include "huswindowagent.h"

HusWindowAgent::HusWindowAgent(QObject *parent)
#ifdef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM
    : QWK::QuickWindowAgent{parent}
#else
    : QObject{parent}
#endif
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
#ifdef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM
# if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        if (p->objectName() == QLatin1StringView("__HusWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
# else
        if (p->objectName() == QLatin1String("__HusWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
# endif
#endif
    }
}

void HusWindowAgent::componentComplete()
{

}
