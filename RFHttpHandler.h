#ifndef RFHTTPHANDLER_H
#define RFHTTPHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QHttpPart>
#include <QFile>
#include <QPixmap>
#include "RFCommonData.h"
#include "RFResponseInterface.h"

class RFHttpHandler : public QObject
{
    Q_OBJECT

private:
    QString m_host;
    quint16 m_port;
    QNetworkAccessManager* m_manager;
    QMap<RFControllers::Controller, RFResponseInterface*> m_controllers;

public:
    explicit RFHttpHandler(const QString& aHost, const quint16 aPort, QObject *parent = nullptr);
    void registerController(const RFControllers::Controller aController, RFResponseInterface *aInterface);

public slots:
    void readLocations(const RFControllers::Controller aController);
    void readRouteList(const RFControllers::Controller aController, const int aLocationId, const double aMinDist, const double aMaxDist, const bool aHasForest, const bool aHasCastles, const bool aHasMonuments, const bool aHasMuseums, const bool aHasAccommodation, const bool aHasRestourants, const int aContains, const int aLimit);

    void writeUpdateForest(const int aRouteId, const bool aHasForest);
    void writeUpdateCastle(const int aRouteId, const bool aHasCastle);
    void writeUpdateMuseum(const int aRouteId, const bool aHasMuseum);
    void writeUpdateMonument(const int aRouteId, const bool aHasMonument);
    void writeUpdateAccommodation(const int aRouteId, const bool aHasHotel);
    void writeUpdateRestourant(const int aRouteId, const bool aHasRestourant);
    void writeInsertCity(const int aRouteId, const int aLocationId);
    void writeRemoveCity(const int aRouteId, const int aLocationId);
    void writeUpdateDescription(const int aRouteId, const QString& aDescription);
    void writeUpdateTitle(const int aRouteId, const QString& aTitle);
    void writeUpdateDistance(const int aRouteId, const double aDistance);
    void writeUpdateLink(const int aRouteId, const QString& aLink);
    void writeInsertPicture(const RFControllers::Controller aController, const int aRouteId, const QString& aPath);
    void writeRemovePicture(const RFControllers::Controller aController, const int aRouteId, const QString& aPath);
    void writeUpdateCover(const RFControllers::Controller aController, const int aRouteId, const QString& aPath);
    void writeInsertRoute(const RFControllers::Controller aController);

    void updateRouteList();

private slots:
    void onReadyRead(QNetworkReply *aReplay);

signals:
    void replay(QString);
    void message(RFNotification::Message type, QString message);
    void loading(bool);
};

#endif // RFHTTPHANDLER_H
