#ifndef HUSWATERMARK_H
#define HUSWATERMARK_H

#include <QtQuick/QQuickPaintedItem>

#include "husglobal.h"

QT_FORWARD_DECLARE_CLASS(HusWatermarkPrivate);

class HUSKARUI_EXPORT HusWatermark : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(QUrl image READ image WRITE setImage NOTIFY imageChanged FINAL)
    Q_PROPERTY(QSize markSize READ markSize WRITE setMarkSize NOTIFY markSizeChanged FINAL)
    Q_PROPERTY(QPointF gap READ gap WRITE setGap NOTIFY gapChanged FINAL)
    Q_PROPERTY(QPointF offset READ offset WRITE setOffset NOTIFY offsetChanged FINAL)
    Q_PROPERTY(qreal rotate READ rotate WRITE setRotate NOTIFY rotateChanged FINAL)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged FINAL)
    Q_PROPERTY(QColor colorText READ colorText WRITE setColorText NOTIFY colorTextChanged FINAL)

    QML_NAMED_ELEMENT(HusWatermark)

public:
    HusWatermark(QQuickItem *parent = nullptr);
    ~HusWatermark();

    QString text() const;
    void setText(const QString &text);

    QUrl image() const;
    void setImage(const QUrl &image);

    QSize markSize() const;
    void setMarkSize(const QSize &markSize);

    QPointF gap() const;
    void setGap(const QPointF &gap);

    QPointF offset() const;
    void setOffset(const QPointF &offset);

    qreal rotate() const;
    void setRotate(qreal rotate);

    QFont font() const;
    void setFont(const QFont &font);

    QColor colorText() const;
    void setColorText(const QColor &colorText);

protected:
    void paint(QPainter *painter) override;

signals:
    void textChanged();
    void imageChanged();
    void markSizeChanged();
    void gapChanged();
    void offsetChanged();
    void rotateChanged();
    void fontChanged();
    void colorTextChanged();

private:
    Q_DECLARE_PRIVATE(HusWatermark);
    QScopedPointer<HusWatermarkPrivate> d_ptr;
};

#endif // HUSWATERMARK_H
