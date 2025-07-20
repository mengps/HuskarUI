#ifndef CREATOR_H
#define CREATOR_H

#include <qqml.h>

class Creator : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(Creator)

public:
    enum ContainMethod
    {
        NoContain = 0,
        SourceContain,
        LibraryContain
    };
    Q_ENUM(ContainMethod);

    static Creator *instance();
    static Creator *create(QQmlEngine *, QJSEngine *);

    Q_INVOKABLE QUrl localFileToUrl(const QString &file);
    Q_INVOKABLE QString urlToLocalFile(const QUrl &url);

    Q_INVOKABLE void createProject(const QVariant &projectParams);

private:
    Creator(QObject *parent = nullptr) : QObject{parent} { }
};

#endif // CREATOR_H
