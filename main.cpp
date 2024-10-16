#include "QCloudMusicApi/QCloudMusicApi/apihelper.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include <QtQml>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    ApiHelper apiHelper;
    apiHelper.invoke("register_anonimous", {});
    engine.rootContext()->setContextProperty("$apiHelper", &apiHelper);
    engine.rootContext()->setContextProperty("$modules", []() {
        QVariantList list;
        QDir dir(":/module");
        foreach (auto i, dir.entryList()) {
            list.append(QVariantMap {
                { "name", QFileInfo(i).baseName() },
                { "path", "qrc:/module/" + i }
            });
        }
        return list;
    }());
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
