#ifndef HUSWINDOWAGENT_H
#define HUSWINDOWAGENT_H

#include <QtCore/QObject>
#include <QtQml/qqml.h>

#include "husglobal.h"

#ifdef BUILD_HUSKARUI_ON_DESKTOP_PLATFORM

#include <QWKQuick/quickwindowagent.h>

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

#else

class HUSKARUI_EXPORT HusWindowAgent : public QObject, public QQmlParserStatus
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

#endif

#endif // HUSWINDOWAGENT_H
