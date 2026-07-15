#ifndef HUSRADIUS_H
#define HUSRADIUS_H

#include "husglobal.h"

#include <QtGui/QColor>
#include <QtQml/qqml.h>

class HUSKARUI_EXPORT HusRadius: public QObject
{
    Q_OBJECT

    Q_PROPERTY(qreal all READ all WRITE setAll NOTIFY allChanged FINAL)
    Q_PROPERTY(qreal topLeft READ topLeft WRITE setTopLeft NOTIFY topLeftChanged FINAL)
    Q_PROPERTY(qreal topRight READ topRight WRITE setTopRight NOTIFY topRightChanged FINAL)
    Q_PROPERTY(qreal bottomLeft READ bottomLeft WRITE setBottomLeft NOTIFY bottomLeftChanged FINAL)
    Q_PROPERTY(qreal bottomRight READ bottomRight WRITE setBottomRight NOTIFY bottomRightChanged FINAL)

    QML_NAMED_ELEMENT(HusRadius)

public:
    HusRadius(QObject *parent = nullptr) : QObject{parent} { }
    ~HusRadius() { }

    qreal all() const;
    void setAll(qreal all);

    qreal topLeft() const;
    void setTopLeft(qreal topLeft);

    qreal topRight() const;
    void setTopRight(qreal topRight);

    qreal bottomLeft() const;
    void setBottomLeft(qreal bottomLeft);

    qreal bottomRight() const;
    void setBottomRight(qreal bottomRight);

signals:
    void allChanged();
    void topLeftChanged();
    void topRightChanged();
    void bottomLeftChanged();
    void bottomRightChanged();

private:
    qreal m_all = 0.;
    qreal m_topLeft = -1.;
    qreal m_topRight = -1.;
    qreal m_bottomLeft = -1.;
    qreal m_bottomRight = -1.;
};

#endif // HUSRADIUS_H
