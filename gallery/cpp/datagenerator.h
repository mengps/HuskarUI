#ifndef DATAGENERATOR_H
#define DATAGENERATOR_H

#include <qqml.h>

class DataGenerator : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(DataGenerator)

public:
    static DataGenerator *instance();
    static DataGenerator *create(QQmlEngine *, QJSEngine *);

    Q_INVOKABLE QVariantList genTableData(int rows);

private:
    DataGenerator(QObject *parent = nullptr) : QObject{parent} { }
};

#endif // DATAGENERATOR_H
