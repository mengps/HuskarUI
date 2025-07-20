#include "datagenerator.h"

#include <QJsonArray>
#include <QJsonObject>
#include <QRandomGenerator>

DataGenerator *DataGenerator::instance()
{
    static DataGenerator *ins = new DataGenerator;
    return ins;
}

DataGenerator *DataGenerator::create(QQmlEngine *, QJSEngine *)
{
    return instance();
}

QVariantList DataGenerator::genTableData(int rows)
{
    static const QString tagList[5] = { "nice", "cool", "loser", "teacher", "developer" };
    static const auto genString = [](int len) -> QString {
        QString str;
        for (int i = 0; i < len; i++) {
            str += QChar::fromLatin1(97 + QRandomGenerator::global()->generate() % 26);
        }
        return str;
    };

    /*! 数据源通常从后台获取 */
    QJsonArray data;
    for (int i = 0; i < rows; i++) {
        /*! 随机成[0-5]个tags */
        QJsonArray tags;
        auto tagCount = QRandomGenerator::global()->generate() % 5;
        for (int j = 1; j < tagCount; j++) {
            tags.append(tagList[j]);
        }

        QJsonObject object;
        object["key"] = i;
        object["name"] = genString(12);
        object["age"] = qint64(QRandomGenerator::global()->generate() % 20 + 30);
        object["address"] = genString(22);
        object["tags"] = tags;
        data.append(object);
    }

    /*! qml 可直接访问 QVariantList */
    /*! QVariant -> var  QList -> List */

    return data.toVariantList();
}
