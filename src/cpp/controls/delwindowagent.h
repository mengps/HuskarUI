#ifndef DELWINDOWAGENT_H
#define DELWINDOWAGENT_H

#include <QObject>
#include <QWKQuick/quickwindowagent.h>

#include "delglobal.h"

class DELEGATEUI_EXPORT DelWindowAgent : public QWK::QuickWindowAgent, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_NAMED_ELEMENT(DelWindowAgent)

public:
    explicit DelWindowAgent(QObject *parent = nullptr);
    ~DelWindowAgent();

    void classBegin() override;
    void componentComplete() override;
};

#endif // DELWINDOWAGENT_H
