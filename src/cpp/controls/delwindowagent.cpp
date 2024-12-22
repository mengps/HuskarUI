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
        if (p->objectName() == QLatin1StringView("__DelWindow__")) {
            setup(qobject_cast<QQuickWindow *>(p));
        }
    }
}

void DelWindowAgent::componentComplete()
{

}
