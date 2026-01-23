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

#include "husapi.h"

#include <QtCore/QFile>
#include <QtGui/QClipboard>
#include <QtGui/QDesktopServices>
#include <QtGui/QGuiApplication>
#include <QtGui/QWindow>

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
# include <QtQml/QQmlInfo>
#endif

#include <QtQuickTemplates2/private/qquickpopup_p_p.h>

#ifdef Q_OS_WIN
# include <Windows.h>
#endif

Q_LOGGING_CATEGORY(lcHusApi, "huskarui.basic.api");

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

qreal HusApi::clamp(qreal value, qreal min, qreal max)
{
    return std::clamp(value, min, max);
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

void HusApi::setWindowState(QWindow *window, int state)
{
    if (window) {
#ifdef Q_OS_WIN
        HWND hwnd = reinterpret_cast<HWND>(window->winId());
        switch (state) {
        case Qt::WindowMinimized:
            ::ShowWindow(hwnd, SW_MINIMIZE);
            break;
        case Qt::WindowMaximized:
            ::ShowWindow(hwnd, SW_MAXIMIZE);
            break;
        default:
            window->setWindowState(Qt::WindowState(state));
            break;
        }
#else
        window->setWindowState(Qt::WindowState(state));
#endif
    }
}

void HusApi::setPopupAllowAutoFlip(QObject *popup, bool allowVerticalFlip, bool allowHorizontalFlip)
{
    if (auto p = qobject_cast<QQuickPopup*>(popup)) {
        QQuickPopupPrivate::get(p)->allowVerticalFlip = allowVerticalFlip;
        QQuickPopupPrivate::get(p)->allowHorizontalFlip = allowHorizontalFlip;
    } else {
        qmlWarning(popup) << "Conversion to Popup failed!";
    }
}

QString HusApi::getClipbordText() const
{
    if (auto clipboard = QGuiApplication::clipboard()) {
        return clipboard->text();
    }

    return QString();
}

bool HusApi::setClipbordText(const QString &text)
{
    if (auto clipboard = QGuiApplication::clipboard()) {
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
        qCDebug(lcHusApi) << "Open file error:" << file.errorString();
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

void HusApi::openLocalUrl(const QString &local)
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(local));
}

HusApi::HusApi(QObject *parent)
    : QObject{parent}
{

}
