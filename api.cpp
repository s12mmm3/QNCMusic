#include "api.h"

#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

Api::Api(QObject *parent)
    : QObject{parent}
{

}

QVariantMap Api::invoke(QString funName, QVariantMap arg) {
    arg["cookie"] = arg.value("cookie", cookie);
    cookie = arg["cookie"].toString() + " SameSite=None; Secure";
    QVariantMap ret;
    QMetaObject::invokeMethod(&api, funName.toUtf8(),
                              Qt::DirectConnection,
                              Q_RETURN_ARG(QVariantMap, ret),
                              Q_ARG(QVariantMap, arg));
    return ret;
//    QFile file(":/config.json");
//    file.open(QIODevice::ReadOnly);
//    return QJsonDocument::fromJson(file.readAll()).object().toVariantMap();
}

QList<QVariantMap> Api::getModule() {
    QList<QVariantMap> list;
    QDir dir(":/module");
    foreach (auto i, dir.entryList()) {
        list.append(QVariantMap({
            { "name", QFileInfo(i).baseName() },
            { "path", "qrc:/module/" + i }
        }));
    }
    return list;
}
