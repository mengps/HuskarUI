#include "husqrcode.h"

#include "../../3rdparty/QR-Code-generator/cpp/qrcodegen.hpp"

#include <QtCore/QLoggingCategory>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkAccessManager>
#include <QtGui/QPainter>
#include <QtQml/QQmlEngine>
#include <QtQuick/QSGImageNode>

#include <private/qqmlglobal_p.h>

Q_LOGGING_CATEGORY(lcHusQrCode, "huskarui.basic.qrcode");

using namespace qrcodegen;

QUrl HusIconSettings::url() const
{
    return m_url;
}

void HusIconSettings::setUrl(const QUrl &url)
{
    if (m_url != url) {
        m_url = url;
        emit urlChanged();
    }
}

qreal HusIconSettings::width() const
{
    return m_width;
}

void HusIconSettings::setWidth(qreal width)
{
    if (m_width != width) {
        m_width = width;
        emit widthChanged();
    }
}

qreal HusIconSettings::height() const
{
    return m_height;
}

void HusIconSettings::setHeight(qreal height)
{
    if (m_height != height) {
        m_height = height;
        emit heightChanged();
    }
}

bool HusIconSettings::isVaild() const
{
    return m_url.isValid() && m_width > 0 && m_height > 0;
}


class HusQrCodePrivate
{
public:
    HusQrCodePrivate(HusQrCode *q) : q_ptr(q) { }

    void reqIcon();
    void genQrCode();

    Q_DECLARE_PUBLIC(HusQrCode);

    HusQrCode *q_ptr = nullptr;

    QImage m_qrCodeImage;
    QString m_text;
    bool m_qrCodeChange = false;
    int m_margin = 4;
    int m_sourceSize = 0;
    QColor m_colorMargin = Qt::transparent;
    QColor m_color = Qt::black;
    QColor m_colorBg = Qt::transparent;
    HusQrCode::ErrorLevel m_errorLevel = HusQrCode::ErrorLevel::Medium;
    HusIconSettings *m_icon = nullptr;
    QNetworkReply *m_iconReply = nullptr;
    QImage m_cachedIcon;
};

void HusQrCodePrivate::reqIcon()
{
    Q_Q(HusQrCode);

    if (m_icon && m_icon->isVaild()) {
        const auto url = m_icon->url();
        if (url.isLocalFile()) {
            m_cachedIcon = QImage(m_icon->url().toLocalFile());
            genQrCode();
        } else {
            if (!m_cachedIcon.isNull())
                m_cachedIcon = QImage();

            if (m_iconReply) {
                m_iconReply->abort();
                m_iconReply = nullptr;
            }

            if (qmlEngine(q)) {
                const auto manager = qmlEngine(q)->networkAccessManager();
                if (manager) {
                    m_iconReply = manager->get(QNetworkRequest(url));
                    QObject::connect(m_iconReply, &QNetworkReply::finished, q, [this]{
                        Q_Q(HusQrCode);
                        if (m_iconReply->error() == QNetworkReply::NoError) {
                            m_cachedIcon = QImage::fromData(m_iconReply->readAll());
                            genQrCode();
                        } else {
                            qCWarning(lcHusQrCode) << "Request icon error:" << m_iconReply->errorString();
                        }
                        m_iconReply->deleteLater();
                        m_iconReply = nullptr;
                    });
                } else {
                    qCWarning(lcHusQrCode) << "HusQrCode without QmlEngine, we cannot get QNetworkAccessManager!";
                }
            }
        }
    }
}

void HusQrCodePrivate::genQrCode()
{
    Q_Q(HusQrCode);

    const auto qr = QrCode::encodeText(m_text.toStdString().c_str(), QrCode::Ecc(m_errorLevel));

    const auto qrSize = qr.getSize();
    const auto qrMargin = qrSize + m_margin;
    m_sourceSize = qrSize + m_margin * 2;
    m_qrCodeImage = QImage(m_sourceSize, m_sourceSize, QImage::Format_ARGB32);
    m_qrCodeImage.fill(Qt::transparent);
    for (int y = -m_margin; y < qrMargin; y++) {
        for (int x = -m_margin; x < qrMargin; x++) {
            if (x < 0 || y < 0 || x >= qrSize || y >= qrSize) {
                m_qrCodeImage.setPixelColor(x + m_margin, y + m_margin, m_colorMargin);
            } else {
                if (qr.getModule(x, y)) {
                    m_qrCodeImage.setPixelColor(x + m_margin, y + m_margin, m_color);
                } else {
                    m_qrCodeImage.setPixelColor(x + m_margin, y + m_margin, m_colorBg);
                }
            }
        }
    }

    m_qrCodeImage = m_qrCodeImage.scaled(q->width(), q->height());

    if (m_icon && m_icon->isVaild() && !m_cachedIcon.isNull()) {
        const auto iconWidth = std::min(m_qrCodeImage.width(), int(m_icon->width()));
        const auto iconHeight = std::min(m_qrCodeImage.height(), int(m_icon->height()));
        const auto icon = m_cachedIcon.scaled(iconWidth, iconHeight);
        const auto startX = (m_qrCodeImage.width() - iconWidth) * 0.5;
        const auto startY = (m_qrCodeImage.height() - iconHeight) * 0.5;
        const auto rangeX = m_qrCodeImage.width() - startX;
        const auto rangeY = m_qrCodeImage.height() - startY;
        for (int y = startX; y < rangeX; y++) {
            for (int x = startY; x < rangeY; x++) {
                m_qrCodeImage.setPixelColor(x, y, icon.pixelColor(x - startX, y - startY));
            }
        }
    }

    m_qrCodeChange = true;
    q->update();
}

HusQrCode::HusQrCode(QQuickItem *parent)
    : QQuickItem(parent)
    , d_ptr(new HusQrCodePrivate(this))
{
    Q_D(HusQrCode);

    setFlags(QQuickItem::ItemHasContents);
    setSize({ 160, 160 });

    /*! may move to other scenes */
    connect(this, &QQuickItem::windowChanged, this, [this]{
        Q_D(HusQrCode);
        d->m_qrCodeChange = true;
        update();
    });
}

HusQrCode::~HusQrCode()
{

}

QString HusQrCode::text() const
{
    Q_D(const HusQrCode);

    return d->m_text;
}

void HusQrCode::setText(const QString &text)
{
    Q_D(HusQrCode);

    if (d->m_text != text) {
        d->m_text = text;
        emit textChanged();
        d->genQrCode();
    }
}

int HusQrCode::margin() const
{
    Q_D(const HusQrCode);

    return d->m_margin;
}

void HusQrCode::setMargin(int margin)
{
    Q_D(HusQrCode);

    if (d->m_margin != margin) {
        d->m_margin = margin;
        emit marginChanged();
        d->genQrCode();
    }
}

QColor HusQrCode::color() const
{
    Q_D(const HusQrCode);

    return d->m_color;
}

void HusQrCode::setColor(const QColor &color)
{
    Q_D(HusQrCode);

    if (d->m_color != color) {
        d->m_color = color;
        emit colorChanged();
        d->genQrCode();
    }
}

QColor HusQrCode::colorMargin() const
{
    Q_D(const HusQrCode);

    return d->m_colorMargin;
}

void HusQrCode::setColorMargin(const QColor &colorMargin)
{
    Q_D(HusQrCode);

    if (d->m_colorMargin != colorMargin) {
        d->m_colorMargin = colorMargin;
        emit colorMarginChanged();
        d->genQrCode();
    }
}

QColor HusQrCode::colorBg() const
{
    Q_D(const HusQrCode);

    return d->m_colorBg;
}

void HusQrCode::setColorBg(const QColor &colorBg)
{
    Q_D(HusQrCode);

    if (d->m_colorBg != colorBg) {
        d->m_colorBg = colorBg;
        emit colorBgChanged();
        d->genQrCode();
    }
}

HusQrCode::ErrorLevel HusQrCode::errorLevel() const
{
    Q_D(const HusQrCode);

    return d->m_errorLevel;
}

void HusQrCode::setErrorLevel(HusQrCode::ErrorLevel level)
{
    Q_D(HusQrCode);

    if (d->m_errorLevel != level) {
        d->m_errorLevel = level;
        emit errorLevelChanged();
        d->genQrCode();
    }
}

HusIconSettings *HusQrCode::icon()
{
    Q_D(HusQrCode);

    if (!d->m_icon) {
        d->m_icon = new HusIconSettings;
        QQml_setParent_noEvent(d->m_icon, this);
        connect(d->m_icon, &HusIconSettings::urlChanged, this, [d]{ d->reqIcon(); });
        connect(d->m_icon, &HusIconSettings::widthChanged, this, [d]{ d->genQrCode(); });
        connect(d->m_icon, &HusIconSettings::heightChanged, this, [d]{ d->genQrCode(); });
        d->reqIcon();
    }

    return d->m_icon;
}

QSGNode *HusQrCode::updatePaintNode(QSGNode *node, UpdatePaintNodeData *)
{
    Q_D(HusQrCode);

    /*QSGSimpleTextureNode *n = static_cast<QSGSimpleTextureNode *>(node);
    if (!n) {
        n = new QSGSimpleTextureNode();
    }

    if (d->m_qrCodeChange) {
        if (window()) {
            d->m_qrCodeChange = false;
            n->setTexture(window()->createTextureFromImage(d->m_qrCodeImage, QQuickWindow::TextureHasAlphaChannel));
            n->setFiltering(QSGTexture::Linear);
            n->setOwnsTexture(true);
        }
    }

    n->setRect(boundingRect());*/

    QSGImageNode *n = static_cast<QSGImageNode *>(node);
    if (!n) {
        if (window()) {
            n = window()->createImageNode();
            n->setTexture(window()->createTextureFromImage(d->m_qrCodeImage,
                                                           QQuickWindow::TextureHasAlphaChannel));
            n->setFiltering(QSGTexture::Linear);
            n->setOwnsTexture(true);
        }
    }

    if (n) {
        if (d->m_qrCodeChange) {
            if (window()) {
                n->setTexture(window()->createTextureFromImage(d->m_qrCodeImage, QQuickWindow::TextureHasAlphaChannel));
                d->m_qrCodeChange = false;
            }
        }
        n->setRect(boundingRect());
    }

    return n;
}
