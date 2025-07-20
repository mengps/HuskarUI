#ifndef HUSASYNCHASHER_H
#define HUSASYNCHASHER_H

#include <QtCore/QCryptographicHash>
#include <QtCore/QFuture>
#include <QtQml/qqml.h>

#include "husglobal.h"

QT_FORWARD_DECLARE_CLASS(QNetworkAccessManager);

QT_FORWARD_DECLARE_CLASS(HusAsyncHasherPrivate);

class HUSKARUI_EXPORT HusAsyncHasher : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QCryptographicHash::Algorithm algorithm READ algorithm WRITE setAlgorithm NOTIFY algorithmChanged)
    Q_PROPERTY(bool asynchronous READ asynchronous WRITE setAsynchronous NOTIFY asynchronousChanged)
    Q_PROPERTY(QString hashValue READ hashValue NOTIFY hashValueChanged)
    Q_PROPERTY(int hashLength READ hashLength NOTIFY hashLengthChanged)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString sourceText READ sourceText WRITE setSourceText NOTIFY sourceTextChanged)
    Q_PROPERTY(QByteArray sourceData READ sourceData WRITE setSourceData NOTIFY sourceDataChanged)
    Q_PROPERTY(QObject* sourceObject READ sourceObject WRITE setSourceObject NOTIFY sourceObjectChanged)

    QML_NAMED_ELEMENT(HusAsyncHasher)

public:
    Q_ENUMS(QCryptographicHash::Algorithm);

    explicit HusAsyncHasher(QObject *parent = nullptr);
    ~HusAsyncHasher();

    QCryptographicHash::Algorithm algorithm();
    void setAlgorithm(QCryptographicHash::Algorithm algorithm);

    bool asynchronous() const;
    void setAsynchronous(bool async);

    QString hashValue() const;

    int hashLength() const;

    QUrl source() const;
    void setSource(const QUrl &source);

    QString sourceText() const;
    void setSourceText(const QString &sourceText);

    QByteArray sourceData() const;
    void setSourceData(const QByteArray &sourceData);

    QObject *sourceObject() const;
    void setSourceObject(QObject *sourceObject);

    bool operator==(const HusAsyncHasher &hasher);
    bool operator!=(const HusAsyncHasher &hasher);

    QFuture<QByteArray> static hash(const QByteArray &data, QCryptographicHash::Algorithm algorithm);

signals:
    void algorithmChanged();
    void asynchronousChanged();
    void hashValueChanged();
    void hashLengthChanged();
    void sourceChanged();
    void sourceTextChanged();
    void sourceDataChanged();
    void sourceObjectChanged();
    void hashProgress(qint64 processed, qint64 total);
    void started();
    void finished();

private slots:
    void setHashValue(const QString &value);

private:
    Q_DECLARE_PRIVATE(HusAsyncHasher);
    QScopedPointer<HusAsyncHasherPrivate> d_ptr;
};

#endif // HUSASYNCHASHER_H
