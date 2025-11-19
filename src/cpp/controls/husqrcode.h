#ifndef HUSQRCODE_H
#define HUSQRCODE_H

#include <QtQuick/QQuickPaintedItem>

#include "husglobal.h"

QT_FORWARD_DECLARE_CLASS(HusQrCodePrivate);

class HUSKARUI_EXPORT HusIconSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged FINAL)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged FINAL)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged FINAL)

    QML_NAMED_ELEMENT(HusIconSettings)

public:
    HusIconSettings(QObject *parent = nullptr) : QObject{parent} { }

    QUrl url() const;
    void setUrl(const QUrl &url);

    qreal width() const;
    void setWidth(qreal width);

    qreal height() const;
    void setHeight(qreal height);

    bool isVaild() const;

signals:
    void urlChanged();
    void widthChanged();
    void heightChanged();

private:
    QUrl m_url;
    qreal m_width = 40;
    qreal m_height = 40;
};

class HUSKARUI_EXPORT HusQrCode : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(int margin READ margin WRITE setMargin NOTIFY marginChanged FINAL)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)
    Q_PROPERTY(QColor colorMargin READ colorMargin WRITE setColorMargin NOTIFY colorMarginChanged FINAL)
    Q_PROPERTY(QColor colorBg READ colorBg WRITE setColorBg NOTIFY colorBgChanged FINAL)
    Q_PROPERTY(HusQrCode::ErrorLevel errorLevel READ errorLevel WRITE setErrorLevel NOTIFY errorLevelChanged FINAL)
    Q_PROPERTY(HusIconSettings* icon READ icon CONSTANT)

    QML_NAMED_ELEMENT(HusQrCode)

public:
    enum class ErrorLevel : uint8_t {
        Low = 0 ,  // The QR Code can tolerate about  7% erroneous codewords
        Medium  ,  // The QR Code can tolerate about 15% erroneous codewords
        Quartile,  // The QR Code can tolerate about 25% erroneous codewords
        High       // The QR Code can tolerate about 30% erroneous codewords
    };
    Q_ENUM(ErrorLevel);

    HusQrCode(QQuickItem *parent = nullptr);
    ~HusQrCode();

    QString text() const;
    void setText(const QString &text);

    int margin() const;
    void setMargin(int margin);

    QColor color() const;
    void setColor(const QColor &color);

    QColor colorMargin() const;
    void setColorMargin(const QColor &colorMargin);

    QColor colorBg() const;
    void setColorBg(const QColor &colorBg);

    HusQrCode::ErrorLevel errorLevel() const;
    void setErrorLevel(HusQrCode::ErrorLevel level);

    HusIconSettings *icon();

protected:
    QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *) override;

signals:
    void textChanged();
    void marginChanged();
    void colorChanged();
    void colorMarginChanged();
    void colorBgChanged();
    void errorLevelChanged();

private:
    Q_DECLARE_PRIVATE(HusQrCode);
    QScopedPointer<HusQrCodePrivate> d_ptr;
};

#endif // HUSQRCODE_H
