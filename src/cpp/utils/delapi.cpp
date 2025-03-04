#include "delapi.h"

#include <QClipboard>
#include <QFile>
#include <QGuiApplication>

#ifdef Q_OS_WIN
#include <Windows.h>
#endif

#include <QtGui/QWindow>

DelApi::~DelApi()
{

}

DelApi *DelApi::instance()
{
    static DelApi *ins = new DelApi;
    return ins;
}

DelApi *DelApi::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

void DelApi::setWindowStaysOnTopHint(QWindow *window, bool hint)
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

QString DelApi::getClipbordText()
{
    return QGuiApplication::clipboard()->text();
}

void DelApi::setClipbordText(const QString &text)
{
    QGuiApplication::clipboard()->setText(text);
}

QString DelApi::readFileToString(const QString &fileName)
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

DelApi::DelApi(QObject *parent)
    : QObject{parent}
{

}
