#ifndef DELAPI_H
#define DELAPI_H

#include <QtQml/qqml.h>
#include <QtGui/QWindow>

#include "delglobal.h"

class DELEGATEUI_EXPORT DelApi : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(DelApi)

public:
    ~DelApi();

    static DelApi *instance();
    static DelApi *create(QQmlEngine *, QJSEngine *);

    Q_INVOKABLE void setWindowStaysOnTopHint(QWindow *window, bool hint);

    Q_INVOKABLE QString getClipbordText();
    Q_INVOKABLE void setClipbordText(const QString &text);

    Q_INVOKABLE QString readFileToString(const QString &fileName);

private:
    explicit DelApi(QObject *parent = nullptr);
};

#endif // DELAPI_H
