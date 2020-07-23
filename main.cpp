#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QSettings>

#include "RFHttpHandler.h"
#include "RFLocationsModel.h"
#include "RFRouteModel.h"
#include "RFUserHandler.h"

#ifdef Q_OS_ANDROID
#include <QtSvg>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QCoreApplication::setApplicationName("Routefinder");
    QCoreApplication::setApplicationVersion(QString("v %1.%2").arg(VERSION_MAJOR).arg(VERSION_MINOR));
    QCoreApplication::setOrganizationName("Eugene's Lab");
//    QCoreApplication::setOrganizationDomain("redwood-games.com"); // for MacOS

    QSettings settings(":/res/settings.ini", QSettings::IniFormat, &app);
    settings.beginGroup("app");

    QTranslator translator(&app);
    translator.load("routefinder_" + settings.value("lang").toString(), ":/translations/");
    QCoreApplication::installTranslator(&translator);

    settings.endGroup();

    settings.beginGroup("connection");
    QString host = settings.value("host").toString();
    quint16 port = settings.value("port").toInt();
    settings.endGroup();

    RFUserHandler* pUserHandler = new RFUserHandler(&app);

    RFRouteModel* pRouteModel = new RFRouteModel(host, port, &app);

    RFLocationsModel* pLocationModel = new RFLocationsModel(&app);

    RFHttpHandler* pHTTPClient = new RFHttpHandler(host, port, &app);
    pHTTPClient->registerController(RFControllers::LocationList, pLocationModel);
    pHTTPClient->registerController(RFControllers::RouteList, pRouteModel);


    QQmlApplicationEngine engine;
    qmlRegisterUncreatableType<RFControllers>("net.eugeneslab.routefinder", 1, 0, "RFControllers", "You can't create an instance of the RFControllers.");
    qmlRegisterUncreatableType<RFNotification>("net.eugeneslab.routefinder", 1, 0, "RFNotification", "You can't create an instance of the RFNotification.");
    qRegisterMetaType<RFControllers::Controller>("RFControllers.Controller");
    qRegisterMetaType<RFControllers::MessageType>("RFControllers.MessageType");
    qRegisterMetaType<RFNotification::Message>("RFControllers.Message");

    engine.rootContext()->setContextProperty("routeModel", pRouteModel);
    engine.rootContext()->setContextProperty("httpHandler", pHTTPClient);
    engine.rootContext()->setContextProperty("locationModel", pLocationModel);
    engine.rootContext()->setContextProperty("userHandler", pUserHandler);
    engine.load(QStringLiteral("qrc:/qml/main.qml"));

    return app.exec();
}
