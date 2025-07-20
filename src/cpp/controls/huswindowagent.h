#ifndef HUSWINDOWAGENT_H
#define HUSWINDOWAGENT_H

#include <QtCore/QObject>
#include <QWKQuick/quickwindowagent.h>

#include "husglobal.h"

class HUSKARUI_EXPORT HusWindowAgent : public QWK::QuickWindowAgent, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_NAMED_ELEMENT(HusWindowAgent)

public:
    explicit HusWindowAgent(QObject *parent = nullptr);
    ~HusWindowAgent();

    void classBegin() override;
    void componentComplete() override;
};

#endif // HUSWINDOWAGENT_H
