// Copyright (C) 2025 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
// Qt-Security score:significant reason:default

#include "qqmltreerow_p.h"

#include <QtCore/qjsonobject.h>

QT_BEGIN_NAMESPACE

using namespace Qt::Literals::StringLiterals;
static const QString TREE_ROWS_PROPERTY_NAME = u"rows"_s;

QQmlTreeRow::QQmlTreeRow(QQmlTreeRow *parentItem)
    : m_parent(parentItem)
{

}

QQmlTreeRow::QQmlTreeRow(const QVariant &data, QQmlTreeRow *parentItem)
    : m_parent(parentItem)
{
    QVariantMap variantMap = data.toJsonObject().toVariantMap();
    unpackVariantMap(variantMap);
}

QQmlTreeRow::QQmlTreeRow(const QVariantMap &data, QQmlTreeRow *parentItem)
    : m_parent(parentItem),
      dataMap(data)
{
    unpackVariantMap(data);
}

void QQmlTreeRow::addChild(QQmlTreeRow *child)
{
    m_children.push_back(std::unique_ptr<QQmlTreeRow>(child));
    child->setParent(this);
}

void QQmlTreeRow::unpackVariantMap(const QVariantMap &variantMap)
{
    for (auto it = variantMap.begin(); it != variantMap.end(); ++it) {
        const QString& key = it.key();
        const QVariant& value = it.value();

        if ((value.typeId() == QMetaType::Type::QVariantList) && (key == TREE_ROWS_PROPERTY_NAME)) {
            const QList<QVariant> variantList = value.toList();
            for (const QVariant &rowAsVariant : variantList)
                m_children.push_back(std::make_unique<QQmlTreeRow>(rowAsVariant, this));
        } else {
            dataMap.insert(key, value);
        }
    }
}

void QQmlTreeRow::removeChild(std::vector<std::unique_ptr<QQmlTreeRow>>::const_iterator &child)
{
    m_children.erase(child);
}

void QQmlTreeRow::removeChildAt(int i)
{
    m_children.erase(std::next(m_children.begin(), i));
}

void QQmlTreeRow::setData(const QVariant &data)
{
    dataMap.clear();
    const QVariantMap variantMap = data.toJsonObject().toVariantMap();
    unpackVariantMap(variantMap);
}

void QQmlTreeRow::setData(const QVariantMap &data)
{
    dataMap.clear();
    unpackVariantMap(data);
}

void QQmlTreeRow::setField(const QString &key, const QVariant &value)
{
    if (dataMap.contains(key))
        dataMap[key] = value;
}

QVariant QQmlTreeRow::toVariant() const
{
    QVariantMap variantMap(dataMap);

    if (!m_children.empty()) {
        QVariantList children;
        for (const auto &child : m_children)
            children.append(child->toVariant());

        variantMap[TREE_ROWS_PROPERTY_NAME] = children;
    }

    return variantMap;
}

int QQmlTreeRow::subTreeSize() const
{
    int size = 1;

    for (const auto &child : m_children)
        size += child->subTreeSize();

    return size;
}

QT_END_NAMESPACE
