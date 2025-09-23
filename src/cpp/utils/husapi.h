#ifndef HUSAPI_H
#define HUSAPI_H

#include <QtCore/QDate>
#include <QtQml/qqml.h>
#include <QtGui/QWindow>

#include "husglobal.h"

class HUSKARUI_EXPORT HusApi : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(HusApi)

public:
    ~HusApi();

    static HusApi *instance();
    static HusApi *create(QQmlEngine *, QJSEngine *);

    Q_INVOKABLE void setWindowStaysOnTopHint(QWindow *window, bool hint);
    Q_INVOKABLE void setWindowState(QWindow *window, int state);

    Q_INVOKABLE void setPopupAllowAutoFlip(QObject *popup, bool allowVerticalFlip = true, bool allowHorizontalFlip = true);

    Q_INVOKABLE QString getClipbordText() const;
    Q_INVOKABLE bool setClipbordText(const QString &text);

    Q_INVOKABLE QString readFileToString(const QString &fileName);

    Q_INVOKABLE int getWeekNumber(const QDateTime &dateTime) const;
    Q_INVOKABLE QDateTime dateFromString(const QString &dateTime, const QString &format) const;

    Q_INVOKABLE void openLocalUrl(const QString &local);

private:
    explicit HusApi(QObject *parent = nullptr);
};

#endif // HUSAPI_H
