/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

#include "huswatermark.h"
#include "hustheme.h"

#include <QtCore/QLoggingCategory>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkAccessManager>
#include <QtGui/QPainter>
#include <QtQml/QQmlEngine>

Q_LOGGING_CATEGORY(lcHusWatermark, "huskarui.basic.watermark");

class HusWatermarkPrivate
{
public:
    HusWatermarkPrivate(HusWatermark *q) : q_ptr(q) { }

    void updateImage();
    void updateMarkSize();

    Q_DECLARE_PUBLIC(HusWatermark);

    HusWatermark *q_ptr = nullptr;
    QString m_text;
    QUrl m_image;
    QNetworkReply *m_imageReply = nullptr;
    QImage m_cachedImage;
    bool m_isSetMarkSize { false };
    QSize m_markSize;
    QPointF m_gap { 100, 100 };
    QPointF m_offset { 50, 50 };
    qreal m_rotate = -22;
    QFont m_font;
    QColor m_colorText { 0, 0, 0, 15 };
};

void HusWatermarkPrivate::updateImage()
{
    Q_Q(HusWatermark);

    if (m_image.isLocalFile()) {
        m_cachedImage = QImage(m_image.toLocalFile());
        updateMarkSize();
        q->update();
    } else {
        if (!m_cachedImage.isNull())
            m_cachedImage = QImage();

        if (m_imageReply) {
            m_imageReply->abort();
            m_imageReply = nullptr;
        }

        if (qmlEngine(q)) {
            const auto manager = qmlEngine(q)->networkAccessManager();
            if (manager) {
                m_imageReply = manager->get(QNetworkRequest(m_image));
                QObject::connect(m_imageReply, &QNetworkReply::finished, q, [this]{
                    Q_Q(HusWatermark);
                    if (m_imageReply->error() == QNetworkReply::NoError) {
                        m_cachedImage = QImage::fromData(m_imageReply->readAll());
                        updateMarkSize();
                        q->update();
                    } else {
                        qCWarning(lcHusWatermark) << "Request image error:" << m_imageReply->errorString();
                    }
                    m_imageReply->deleteLater();
                    m_imageReply = nullptr;
                });
            } else {
                qCWarning(lcHusWatermark) << "HusWatermark without QmlEngine, we cannot get QNetworkAccessManager!";
            }
        }
    }
}

void HusWatermarkPrivate::updateMarkSize()
{
    if (!m_isSetMarkSize) {
        QFontMetricsF fontMetrics(m_font);
        QSizeF textSize = { fontMetrics.horizontalAdvance(m_text), fontMetrics.height() };
        int markWidth = m_cachedImage.isNull() ? textSize.width() : m_cachedImage.width();
        int markHeight = m_cachedImage.isNull() ? textSize.height() : m_cachedImage.height();
        m_markSize = { markWidth, markHeight };
    }
}

HusWatermark::HusWatermark(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , d_ptr(new HusWatermarkPrivate(this))
{
    Q_D(HusWatermark);

    d->m_font.setFamily(HusTheme::instance()->Primary()["fontPrimaryFamily"].toString());
    d->m_font.setPixelSize(HusTheme::instance()->Primary()["fontPrimarySize"].toInt());

    setAntialiasing(true);
}

HusWatermark::~HusWatermark()
{

}

QString HusWatermark::text() const
{
    Q_D(const HusWatermark);

    return d->m_text;
}

void HusWatermark::setText(const QString &text)
{
    Q_D(HusWatermark);

    if (d->m_text != text) {
        d->m_text = text;
        emit textChanged();

        d->updateMarkSize();
        update();
    }
}

QUrl HusWatermark::image() const
{
    Q_D(const HusWatermark);

    return d->m_image;
}

void HusWatermark::setImage(const QUrl &image)
{
    Q_D(HusWatermark);

    if (d->m_image != image) {
        d->m_image = image;
        emit imageChanged();

        d->updateImage();
        update();
    }
}

QSize HusWatermark::markSize() const
{
    Q_D(const HusWatermark);

    return d->m_markSize;
}

void HusWatermark::setMarkSize(const QSize &markSize)
{
    Q_D(HusWatermark);

    d->m_isSetMarkSize = true;

    if (d->m_markSize != markSize) {
        d->m_markSize = markSize;
        emit markSizeChanged();

        update();
    }
}

QPointF HusWatermark::gap() const
{
    Q_D(const HusWatermark);

    return d->m_gap;
}

void HusWatermark::setGap(const QPointF &gap)
{
    Q_D(HusWatermark);

    if (d->m_gap != gap) {
        d->m_gap = gap;
        emit gapChanged();

        update();
    }
}

QPointF HusWatermark::offset() const
{
    Q_D(const HusWatermark);

    return d->m_offset;
}

void HusWatermark::setOffset(const QPointF &offset)
{
    Q_D(HusWatermark);

    if (d->m_offset != offset) {
        d->m_offset = offset;
        emit offsetChanged();

        update();
    }
}

qreal HusWatermark::rotate() const
{
    Q_D(const HusWatermark);

    return d->m_rotate;
}

void HusWatermark::setRotate(qreal rotate)
{
    Q_D(HusWatermark);

    if (d->m_rotate != rotate) {
        d->m_rotate = rotate;
        emit rotateChanged();

        update();
    }
}

QFont HusWatermark::font() const
{
    Q_D(const HusWatermark);

    return d->m_font;
}

void HusWatermark::setFont(const QFont &font)
{
    Q_D(HusWatermark);

    if (d->m_font != font) {
        d->m_font = font;
        emit fontChanged();

        d->updateMarkSize();
        update();
    }
}

QColor HusWatermark::colorText() const
{
    Q_D(const HusWatermark);

    return d->m_colorText;
}

void HusWatermark::setColorText(const QColor &colorText)
{
    Q_D(HusWatermark);

    if (d->m_colorText != colorText) {
        d->m_colorText = colorText;
        emit colorTextChanged();
        update();
    }
}

void HusWatermark::paint(QPainter *painter)
{
    Q_D(HusWatermark);

    painter->save();

    if (antialiasing())
        painter->setRenderHint(QPainter::Antialiasing);

    painter->setFont(d->m_font);
    painter->setPen(d->m_colorText);

    int markWidth = d->m_markSize.width();
    int markHeight = d->m_markSize.height();
    int stepX = std::round(markWidth + d->m_gap.x());
    int stepY = std::round(markHeight + d->m_gap.y());
    int rowCount = std::round(width() / stepX + 1);
    int columnCount = std::round(height() / stepY + 1);
    for (int row = 0; row < rowCount; row++) {
        for (int column = 0; column < columnCount; column++) {
            qreal x = stepX * row + d->m_offset.x() + markWidth * 0.5;
            qreal y = stepY * column + d->m_offset.y() + markHeight * 0.5;
            painter->save();
            painter->translate(x, y);
            painter->rotate(d->m_rotate);
            if (d->m_cachedImage.isNull()) {
                painter->drawText(QRectF(-markWidth * 0.5, -markHeight * 0.5, markWidth, markHeight), d->m_text);
            } else {
                painter->drawImage(QRectF(-markWidth * 0.5, -markHeight * 0.5, markWidth, markHeight), d->m_cachedImage);
            }
            painter->restore();
        }
    }
    painter->restore();
}
