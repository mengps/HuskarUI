// Copyright (C) 2025 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
// Qt-Security score:significant reason:default

#include "qqmltreemodel_p.h"
#include "qqmltreerow_p.h"

#include <QtCore/qloggingcategory.h>

#include <QtQml/qqmlinfo.h>
#include <QtQml/qqmlengine.h>

QT_BEGIN_NAMESPACE

using namespace Qt::StringLiterals;

static const QString ROWS_PROPERTY_NAME = u"rows"_s;

/*!
    \qmltype TreeModel
//!    \nativetype QQmlTreeModel
    \inqmlmodule Qt.labs.qmlmodels
    \brief Encapsulates a simple tree model.
    \since 6.10

    The TreeModel type stores JavaScript/JSON objects as data for a tree
    model that can be used with \l TreeView. It is intended to support
    very simple models without requiring the creation of a custom
    \l QAbstractItemModel subclass in C++.

    \snippet qml/treemodel/treemodel-filesystem-basic.qml file

    The model's initial data is set with either the \l rows property or by
    calling \l appendRow(). Each column in the model is specified by declaring
    a \l TableModelColumn instance, where the order of each instance determines
    its column index. Once the model's \l Component::completed() signal has been
    emitted, the columns and roles will have been established and are then
    fixed for the lifetime of the model.

    \section1 Supported Row Data Structures

    Each row represents a node in the tree. Each node has the same type of
    columns. The TreeModel is designed to work with JavaScript/JSON data so
    each row is a list of simple key-value pairs:

    \snippet qml/treemodel/treemodel-filesystem-basic.qml rows

    A node can have child nodes and these will be stored in an array
    associated with the "rows" key. "rows" is reserved for this purpose: only
    the list of child nodes should be associated with this key.

    The model is manipulated via \l {QModelIndex} {QModelIndices}. To access
    a specific row/node, the \l getRow() function can be used. It's also
    possible to access the model's JavaScript data directly via the \l rows
    property, but it is not possible to modify the model data this way.

    To add new rows, use \l appendRow(). To modify existing rows, use
    \l setRow(), \l removeRow() and \l clear().
*/

QQmlTreeModel::QQmlTreeModel(QObject *parent)
    : QQmlAbstractColumnModel(parent)
{
}

QQmlTreeModel::~QQmlTreeModel() = default;

/*!
    \qmlproperty object TreeModel::rows

    This property holds the model data in the form of an array of rows.

    \sa getRow(), setRow(), appendRow(), clear(), columnCount
*/
QVariant QQmlTreeModel::rows() const
{
    QVariantList rowsAsVariant;
    for (const auto &row : mRows)
        rowsAsVariant.append(row->toVariant());

    return rowsAsVariant;
}

void QQmlTreeModel::setRows(const QVariant &rows)
{
    if (rows.userType() != qMetaTypeId<QJSValue>()) {
        qmlWarning(this) << "setRows(): \"rows\" must be an array; actual type is " << rows.typeName();
        return;
    }

    const auto rowsAsJSValue = rows.value<QJSValue>();
    const QVariantList rowsAsVariantList = rowsAsJSValue.toVariant().toList();

    if (!mComponentCompleted) {
        // Store the rows until we can call setRowsPrivate() after component completion.
        mInitialRows = rowsAsVariantList;
        return;
    }

    setRowsPrivate(rowsAsVariantList);
}

void QQmlTreeModel::setRowsPrivate(const QVariantList &rowsAsVariantList)
{
    Q_ASSERT(mComponentCompleted);

    // By now, all TableModelColumns should have been set.
    if (mColumns.isEmpty()) {
        qmlWarning(this) << "No TableModelColumns were set; model will be empty";
        return;
    }

    const bool firstTimeValidRowsHaveBeenSet = mColumnMetadata.isEmpty();
    if (!firstTimeValidRowsHaveBeenSet) {
        // This is not the first time rows have been set; validate each one.
        for (const auto &row : rowsAsVariantList) {
            // validateNewRow() expects a QVariant wrapping a QJSValue, so to
            // simplify the code, just create one here.
            const QVariant wrappedRow = QVariant::fromValue(row);
            if (!validateNewRow("TreeModel::setRows"_L1, wrappedRow, SetRowsOperation))
                return;
        }
    }

    beginResetModel();

    // We don't clear the column or role data, because a TreeModel should not be reused in that way.
    // Once it has valid data, its columns and roles are fixed.
    mRows.clear();

    for (const auto &rowAsVariant : rowsAsVariantList)
        mRows.push_back(std::make_unique<QQmlTreeRow>(rowAsVariant));

    // Gather metadata the first time rows is set.
    // If we call setrows on an empty model, mInitialRows will be empty, but mRows is not
    if (firstTimeValidRowsHaveBeenSet && (!mRows.empty() || !mInitialRows.isEmpty()))
        fetchColumnMetadata();

    endResetModel();
    emit rowsChanged();
}

QVariant QQmlTreeModel::dataPrivate(const QModelIndex &index, const QString &roleName) const
{
    const ColumnMetadata columnMetadata = mColumnMetadata.at(index.column());
    const QString propertyName = columnMetadata.roles.value(roleName).name;
    const auto *thisRow = static_cast<const QQmlTreeRow *>(index.internalPointer());
    return thisRow->data(propertyName);
}

void QQmlTreeModel::setDataPrivate(const QModelIndex &index, const QString &roleName, QVariant value)
{
    auto *row = static_cast<QQmlTreeRow *>(index.internalPointer());
    row->setField(roleName, value);
}

// TODO: Turn this into a snippet that compiles in CI
/*!
    \qmlmethod TreeModel::appendRow(QModelIndex parent, object treeRow)

    Appends a new treeRow to \a parent, with the values (cells) in \a treeRow.

    \code
        treeModel.appendRow(index, {
            checked: false,
            size: "-",
            type: "folder",
            name: "Orders",
            lastModified: "2025-07-02",
            rows: [
                {
                    checked: true,
                    size: "38 KB",
                    type: "file",
                    name: "monitors.xlsx",
                    lastModified: "2025-07-02"
                },
                {
                    checked: true,
                    size: "54 KB",
                    type: "file",
                    name: "notebooks.xlsx",
                    lastModified: "2025-07-02"
                }
            ]
        });
    \endcode

    If \a parent is invalid, \a treeRow gets appended to the root node.

    \sa setRow(), removeRow()
*/
void QQmlTreeModel::appendRow(QModelIndex parent, const QVariant &row)
{
    if (!validateNewRow("TreeModel::appendRow"_L1, row))
        return;

    const QVariant data = row.userType() == QMetaType::QVariantMap ? row : row.value<QJSValue>().toVariant();

    if (parent.isValid()) {
        auto *parentRow = static_cast<QQmlTreeRow *>(parent.internalPointer());
        auto *newChild = new QQmlTreeRow(data);

        beginInsertRows(parent, static_cast<int>(parentRow->rowCount()), static_cast<int>(parentRow->rowCount()));
        parentRow->addChild(newChild);

               // Gather metadata the first time a row is added.
        if (mColumnMetadata.isEmpty())
            fetchColumnMetadata();

        endInsertRows();
    } else {
        qmlWarning(this) << "append: could not find any node at the specified index"
                         << " - the new row will be appended to root";

        beginInsertRows(QModelIndex(),
                        static_cast<int>(mRows.size()),
                        static_cast<int>(mRows.size()));

        mRows.push_back(std::make_unique<QQmlTreeRow>(data));

        // Gather metadata the first time a row is added.
        if (mColumnMetadata.isEmpty())
            fetchColumnMetadata();

        endInsertRows();
    }

    emit rowsChanged();
}

/*!
    \qmlmethod TreeModel::appendRow(object treeRow)

    Appends \a treeRow to the root node.

    \sa setRow(), removeRow()
*/
void QQmlTreeModel::appendRow(const QVariant &row)
{
    appendRow({}, row);
}

/*!
    \qmlmethod TreeModel::clear()

    Removes all rows from the model.

    \sa removeRow()
*/
void QQmlTreeModel::clear()
{
    QQmlEngine *engine = qmlEngine(this);
    Q_ASSERT(engine);
    setRows(QVariant::fromValue(engine->newArray()));
}

/*!
    \qmlmethod object TreeModel::getRow(const QModelIndex &rowIndex)

    Returns the treeRow at \a rowIndex in the model.

    \note the returned object cannot be used to modify the contents of the
    model; use setTreeRow() instead.

    \sa setRow(), appendRow(), removeRow()
*/
QVariant QQmlTreeModel::getRow(const QModelIndex &rowIndex) const
{
    if (rowIndex.isValid())
        return static_cast<QQmlTreeRow*>(rowIndex.internalPointer())->toVariant();

    qmlWarning(this) << "getRow: could not find any node at the specified index";
    return {};
}

QVariant QQmlTreeModel::firstRow() const
{
    return mRows.front().get()->data();
}

void QQmlTreeModel::setInitialRows()
{
    setRowsPrivate(mInitialRows);
}

/*!
    \qmlmethod TreeModel::removeRow(QModelIndex rowIndex)

    Removes the TreeRow referenced by \a rowIndex from the model.

    \code
        treeModel.removeTreeRow(rowIndex)
    \endcode

\sa clear()
*/
void QQmlTreeModel::removeRow(QModelIndex rowIndex)
{
    if (rowIndex.isValid()) {
        QModelIndex mIndexParent = rowIndex.parent();

        beginRemoveRows(mIndexParent, rowIndex.row(), rowIndex.row());

        if (mIndexParent.isValid()) {
            auto *parent = static_cast<QQmlTreeRow *>(mIndexParent.internalPointer());
            parent->removeChildAt(rowIndex.row());
        } else {
            mRows.erase(std::next(mRows.begin(), rowIndex.row()));
        }

        endRemoveRows();
    } else {
        qmlWarning(this) << "TreeModel::removeRow could not find any node at the specified index";
        return;
    }

    emit rowsChanged();
}

// TODO: Turn this into a snippet that compiles in CI

/*!
    \qmlmethod TreeModel::setRow(QModelIndex rowIndex, object treeRow)

    Replaces the TreeRow at \a rowIndex in the model with \a treeRow.
    A row with child rows will be rejected.

    All columns/cells must be present in \c treeRow, and in the correct order.
    The child rows of the row remain unaffected.

    \code
        treeModel.setRow(rowIndex, {
            checked: true,
            size: "-",
            type: "folder",
            name: "Subtitles",
            lastModified: "2025-07-07",
            iconColor: "blue"
        });
    \endcode

    \sa appendRow()
*/
void QQmlTreeModel::setRow(QModelIndex rowIndex, const QVariant &rowData)
{
    if (!rowIndex.isValid()) {
        qmlWarning(this) << "TreeModel::setRow: invalid modelIndex";
        return;
    }

    const QVariantMap rowAsMap = rowData.toMap();
    if (rowAsMap.contains(ROWS_PROPERTY_NAME) && rowAsMap[ROWS_PROPERTY_NAME].userType() == QMetaType::Type::QVariantList) {
        qmlWarning(this) << "TreeModel::setRow: child rows are not allowed";
        return;
    }

    if (!validateNewRow("TreeModel::setRow"_L1, rowData))
        return;

    const QVariant rowAsVariant = rowData.userType() == QMetaType::QVariantMap ? rowData : rowData.value<QJSValue>().toVariant();
    auto *row = static_cast<QQmlTreeRow *>(rowIndex.internalPointer());
    row->setData(rowAsVariant);

    const QModelIndex topLeftModelIndex(createIndex(rowIndex.row(), 0, rowIndex.internalPointer()));
    const QModelIndex bottomRightModelIndex(createIndex(rowIndex.row(), mColumnCount-1, rowIndex.internalPointer()));

    emit dataChanged(topLeftModelIndex, bottomRightModelIndex);
    emit rowsChanged();
}

/*!
    \qmlmethod QModelIndex TreeModel::index(int row, int column, object parent)

    Returns a \l QModelIndex object referencing the given \a row and \a column of
    a given \a parent which can be passed to the data() function to get the data
    from that cell, or to setData() to edit the contents of that cell.

    \sa {QModelIndex and related Classes in QML}, data()
*/
QModelIndex QQmlTreeModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!parent.isValid()){
        if (static_cast<size_t>(row) >= mRows.size())
            return {};

        return createIndex(row, column, mRows.at(row).get());
    }

    const auto *treeRow = static_cast<const QQmlTreeRow *>(parent.internalPointer());
    if (treeRow->rowCount() <= static_cast<size_t>(row))
        return {};

    return createIndex(row, column, treeRow->getRow(row));
}

/*!
    \qmlmethod QModelIndex TreeModel::index(list<int> treeIndex, int column)

    Returns a \l QModelIndex object referencing the given \a treeIndex and \a column,
    which can be passed to the data() function to get the data from that cell,
    or to setData() to edit the contents of that cell.

    The first parameter \a treeIndex represents a path of row numbers tracing from
    the root to the desired row and is used for navigation inside the tree.
    This is best explained through an example.

    \table

    \row \li \inlineimage treemodel.svg
    \li \list

    \li The root of the tree is special, as it can be referenced by an invalid
    \l QModelIndex.

    \li Node A is the first child of the root and the corresponding \a treeIndex is \c [0].

    \li Node B is the first child of node A. Since the \a treeIndex of A is \c [0]
    the \a treeIndex of B will be \c [0,0].

    \li Node C is the second child of A and its \a treeIndex is \c [0,1].

    \li Node D is the third child of A and its \a treeIndex is \c [0,2].

    \li Node E is the second child of the root and its \a treeIndex is \c [1].

    \li Node F is the third child of the root and its \a treeIndex is \c [2].

    \endlist

    \endtable

    With this overload it is possible to obtain a \l QModelIndex to a node without
    having a \l QModelIndex to its parent node.

    If no node is found by the list specified, an invalid model index is returned.
    Please note that an invalid model index is referencing the root of the node.

    \sa {QModelIndex and related Classes in QML}, data()
*/
QModelIndex QQmlTreeModel::index(const std::vector<int> &treeIndex, int column)
{
    QModelIndex mIndex;
    QQmlTreeRow *row = getPointerToTreeRow(mIndex, treeIndex);

    if (row)
        return createIndex(treeIndex.back(), column, row);

    qmlWarning(this) << "TreeModel::index: could not find any node at the specified index";
    return {};
}

QModelIndex QQmlTreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return {};

    const auto *thisRow = static_cast<const QQmlTreeRow *>(index.internalPointer());
    const QQmlTreeRow *parentRow = thisRow->parent();

    if (!parentRow) // parent is root
        return {};

    const QQmlTreeRow *grandparentRow = parentRow->parent();

    if (!grandparentRow) {// grandparent is root, parent is in mRows
        for (size_t i = 0; i < mRows.size(); i++) {
            if (mRows[i].get() == parentRow)
                return createIndex(static_cast<int>(i), 0, parentRow);
        }
        Q_UNREACHABLE_RETURN(QModelIndex());
    }

    for (size_t i = 0; i < grandparentRow->rowCount(); i++) {
        if (grandparentRow->getRow(static_cast<int>(i)) == parentRow)
            return createIndex(static_cast<int>(i), 0, parentRow);
    }
    Q_UNREACHABLE_RETURN(QModelIndex());
}


int QQmlTreeModel::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return static_cast<int>(mRows.size());

    const auto *row = static_cast<const QQmlTreeRow *>(parent.internalPointer());
    return static_cast<int>(row->rowCount());
}

/*!
    \qmlproperty int TreeModel::columnCount
    \readonly

    This read-only property holds the number of columns in the model.

    The number of columns is fixed for the lifetime of the model
    after the \l rows property is set or \l appendRow() is called for the first
    time.
*/
int QQmlTreeModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return mColumnCount;
}

/*!
    \qmlmethod variant TreeModel::data(QModelIndex index, string role)

    Returns the data from the TreeModel at the given \a index belonging to the
    given \a role.

    \sa index(), setData()
*/

/*!
    \qmlmethod bool TreeModel::setData(QModelIndex index, variant value, string role)

    Inserts or updates the data field named by \a role in the TreeRow at the
    given \a index with \a value. Returns true if sucessful, false if not.

    \sa data(), index()
*/

bool QQmlTreeModel::validateNewRow(QLatin1StringView functionName, const QVariant &row,
                                   NewRowOperationFlag operation) const
{
    const bool isVariantMap = (row.userType() == QMetaType::QVariantMap);
    const QVariant rowAsVariant = operation == SetRowsOperation || isVariantMap
        ? row : row.value<QJSValue>().toVariant();
    const QVariantMap rowAsMap = rowAsVariant.toMap();
    if (rowAsMap.contains(ROWS_PROPERTY_NAME) && rowAsMap[ROWS_PROPERTY_NAME].userType() == QMetaType::Type::QVariantList)
    {
        const QList<QVariant> variantList = rowAsMap[ROWS_PROPERTY_NAME].toList();
        for (const QVariant &rowAsVariant : variantList)
            if (!validateNewRow(functionName, rowAsVariant))
                return false;
    }

    return QQmlAbstractColumnModel::validateNewRow(functionName, row, operation);
}

int QQmlTreeModel::treeSize() const
{
    int treeSize = 0;

    for (const auto &treeRow : mRows)
        treeSize += treeRow->subTreeSize();

    return treeSize;
}

QQmlTreeRow *QQmlTreeModel::getPointerToTreeRow(QModelIndex &modIndex,
                                                const std::vector<int> &rowIndex) const
{
    for (int r : rowIndex) {
        modIndex = index(r, 0, modIndex);
        if (!modIndex.isValid())
            return nullptr;
    }

    return static_cast<QQmlTreeRow*>(modIndex.internalPointer());
}

QT_END_NAMESPACE

#include "moc_qqmltreemodel_p.cpp"
