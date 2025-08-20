#include "husapi.h"

#include <QtCore/QFile>
#include <QtGui/QClipboard>
#include <QtGui/QGuiApplication>

#ifdef Q_OS_WIN
#include <Windows.h>
#endif

#include <QtGui/QWindow>

HusApi::~HusApi()
{

}

HusApi *HusApi::instance()
{
    static HusApi *ins = new HusApi;
    return ins;
}

HusApi *HusApi::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

void HusApi::setWindowStaysOnTopHint(QWindow *window, bool hint)
{
    if (window) {
#ifdef Q_OS_WIN
        HWND hwnd = reinterpret_cast<HWND>(window->winId());
        if (hint) {
            ::SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
        } else {
            ::SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
        }
#else
        window->setFlag(Qt::WindowStaysOnTopHint, hint);
#endif
    }
}

QString HusApi::getClipbordText() const
{
    if (auto clipboard = QGuiApplication::clipboard(); clipboard) {
        return clipboard->text();
    }

    return QString();
}

bool HusApi::setClipbordText(const QString &text)
{
    if (auto clipboard = QGuiApplication::clipboard(); clipboard) {
        clipboard->setText(text);
        return true;
    }

    return false;
}

QString HusApi::readFileToString(const QString &fileName)
{
    QString result;
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly)) {
        result = file.readAll();
    } else {
        qDebug() << "Open file error:" << file.errorString();
    }

    return result;
}

int HusApi::getWeekNumber(const QDateTime &dateTime) const
{
    return dateTime.date().weekNumber();
}

QDateTime HusApi::dateFromString(const QString &dateTime, const QString &format) const
{
    return QDateTime::fromString(dateTime, format);
}

HusApi::HusApi(QObject *parent)
    : QObject{parent}
{

}
