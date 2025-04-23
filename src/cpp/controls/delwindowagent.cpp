#include "delwindowagent.h"

DelWindowAgent::DelWindowAgent(QObject *parent)
    : QWK::QuickWindowAgent{parent}
{

}

DelWindowAgent::~DelWindowAgent()
{

}

void DelWindowAgent::classBegin()
{
    auto p = parent();
    Q_ASSERT_X(p, "DelWindowAgent", "parent() return nullptr!");
    if (p) {
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        if (p->objectName() == QLatin1StringView("__DelWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
#else
        if (p->objectName() == QLatin1String("__DelWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
#endif
    }
}

void DelWindowAgent::componentComplete()
{

}
