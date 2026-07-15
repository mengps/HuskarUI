#ifndef HUSBORDER_H
#define HUSBORDER_H

#include "husglobal.h"

#include <QtQuick/private/qquickrectangle_p.h>

class HUSKARUI_EXPORT HusBorder: public QQuickPen
{
    Q_OBJECT

    Q_PROPERTY(int style READ style WRITE setStyle NOTIFY styleChanged FINAL)
    QML_NAMED_ELEMENT(HusBorder)

public:
    HusBorder(QObject *parent = nullptr);
    ~HusBorder();

    int style() const;
    void setStyle(int style);

signals:
    void styleChanged();

private:
    int m_style = Qt::SolidLine;
};

#endif // HUSBORDER_H
