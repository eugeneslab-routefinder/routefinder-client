#include "RFHttpHandler.h"

RFHttpHandler::RFHttpHandler(const QString &aHost, const quint16 aPort, QObject *parent) : QObject(parent),
    m_host(aHost),
    m_port(aPort)
{
    m_manager = new QNetworkAccessManager(this);

    QObject::connect(m_manager, &QNetworkAccessManager::finished, this, &RFHttpHandler::onReadyRead, Qt::QueuedConnection);
}

void RFHttpHandler::registerController(const RFControllers::Controller aController, RFResponseInterface *aInterface)
{
    m_controllers[aController] = aInterface;
}

void RFHttpHandler::readLocations(const RFControllers::Controller aController)
{
    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=locations&controller=%3";
    url = url.arg(m_host).arg(m_port).arg(aController);
    requst.setUrl(QUrl(url));
    m_manager->get(requst);
}

void RFHttpHandler::readRouteList(const RFControllers::Controller aController, const int aLocationId, const double aMinDist, const double aMaxDist, const bool aHasForest, const bool aHasCastles, const bool aHasMonuments, const bool aHasMuseums, const bool aHasAccommodation, const bool aHasRestourants, const int aContains, const int aLimit)
{
    emit loading(true);
    QString url = "http://%1:%2/script?type=find&"
                  "id=%3&"
                  "maxdist=%4&"
                  "mindist=%5&"
                  "forest=%6&"
                  "castles=%7&"
                  "monuments=%8&"
                  "museums=%9&"
                  "hotels=%10&"
                  "restourants=%11&"
                  "limit=%12&"
                  "controller=%13&"
                  "contains=%14&"
                  "msg=%15";

    url = url.arg(m_host).arg(m_port)
            .arg(aLocationId)
            .arg(aMaxDist)
            .arg(aMinDist)
            .arg(aHasForest)
            .arg(aHasCastles)
            .arg(aHasMonuments)
            .arg(aHasMuseums)
            .arg(aHasAccommodation)
            .arg(aHasRestourants)
            .arg(aLimit)
            .arg(aController)
            .arg(aContains)
            .arg(RFControllers::MessageType::RouteData);

    m_manager->get(QNetworkRequest(QUrl(url)));
}

void RFHttpHandler::writeUpdateForest(const int aRouteId, const bool aHasForest)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=forest";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["hasForest"] = aHasForest;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateCastle(const int aRouteId, const bool aHasCastle)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=castle";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["hasCastle"] = aHasCastle;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateMuseum(const int aRouteId, const bool aHasMuseum)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=museum";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["hasMuseum"] = aHasMuseum;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateMonument(const int aRouteId, const bool aHasMonument)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=monument";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["hasMonument"] = aHasMonument;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateAccommodation(const int aRouteId, const bool aHasHotel)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=accommodation";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["hasAccommodation"] = aHasHotel;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateRestourant(const int aRouteId, const bool aHasRestourant)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=restourant";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["hasRestourant"] = aHasRestourant;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeInsertCity(const int aRouteId, const int aLocationId)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=insert_location";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["location"] = aLocationId;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeRemoveCity(const int aRouteId, const int aLocationId)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=remove_location";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["location"] = aLocationId;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateDescription(const int aRouteId, const QString &aDescription)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=description";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["description"] = aDescription;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateTitle(const int aRouteId, const QString &aTitle)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=title";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["title"] = aTitle;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateDistance(const int aRouteId, const double aDistance)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=dist";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["distance"] = aDistance;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateLink(const int aRouteId, const QString &aLink)
{
    emit loading(true);
    QJsonObject object;

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=link";
    url = url.arg(m_host).arg(m_port);

    object["id"] = aRouteId;
    object["link"] = aLink;
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeInsertPicture(const RFControllers::Controller aController, const int aRouteId, const QString &aPath)
{
    QPixmap pixmap(QUrl(aPath).toLocalFile());
    int size = pixmap.toImage().sizeInBytes() / 8000;
    if(pixmap.width() < pixmap.height()) {
        emit message(RFNotification::Error, tr("Vertical pictures are firbidden"));
        return;
    }
//    else if(pixmap.width() > 1980 || pixmap.height() > 1080) {
//        emit message(RFNotification::Error, tr("A picture must not bigger than 1980 x 1080"));
//        return;
//    }
//    else if(pixmap.width() < 1000 || pixmap.height() < 750)
//    {
//        emit message(RFNotification::Error, tr("A picture must not smaller than 1024 x 768"));
//        return;
//    }
    else if(size < 200)
    {
        emit message(RFNotification::Error, tr("Low quality pictures are forbidden. Picture must not wight less than 200 Kb"));
        return;
    }
    else if(size > 6000) {
        emit message(RFNotification::Error, tr("Picture must not weight more than 5000 Kb"));
        return;
    }

    emit loading(true);

    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=insert_picture&id=%3&controller=%4&msg=%5";
    url = url.arg(m_host).arg(m_port).arg(aRouteId).arg(aController).arg(RFControllers::MessageType::InsertPicture);

    QFile* picture = new QFile(QUrl(aPath).toLocalFile());
    if(picture->open(QIODevice::ReadOnly))
    {
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
        QHttpPart imagePart;
        imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
        imagePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"pic\"; filename=\"pic\"") );
        imagePart.setBodyDevice(picture);
        picture->setParent(multiPart);
        multiPart->append(imagePart);

        requst.setUrl(QUrl(url));
        QNetworkReply *reply = m_manager->post(requst, multiPart);

        multiPart->setParent(reply);
    }
    else {
        qDebug() << "was'n oppend file" << aPath;
    }
}

void RFHttpHandler::writeRemovePicture(const RFControllers::Controller aController, const int aRouteId, const QString &aPath)
{
    emit loading(true);
    QJsonObject object;
    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=remove_picture&id=%3&controller=%4&msg=%5";
    url = url.arg(m_host).arg(m_port).arg(aRouteId).arg(aController).arg(RFControllers::MessageType::RemovePicture);
    object["id"] = aRouteId;
    object["picture"] = removeHostFromUrl(aPath);
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeUpdateCover(const RFControllers::Controller aController, const int aRouteId, const QString &aPath)
{
    QJsonObject object;
    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=cover&id=%3&controller=%4&msg=%5";
    url = url.arg(m_host).arg(m_port).arg(aRouteId).arg(aController).arg(RFControllers::MessageType::Cover);
    object["id"] = aRouteId;
    object["picture"] = removeHostFromUrl(aPath);
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QJsonDocument(object).toJson());
}

void RFHttpHandler::writeInsertRoute(const RFControllers::Controller aController)
{
    emit loading(true);
    QNetworkRequest requst;
    QString url = "http://%1:%2/script?type=update&meta=insert_route&controller=%4&msg=%5";
    url = url.arg(m_host).arg(m_port).arg(aController).arg(RFControllers::MessageType::InsertRote);
    requst.setUrl(QUrl(url));

    requst.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_manager->post(requst, QByteArray());
}

void RFHttpHandler::updateRouteList()
{
    emit loading(true);
    readLocations(RFControllers::LocationList);
    readRouteList(RFControllers::RouteList, 0, 0, 100, false, false, false, false, false, false, 0, 10);
}

void RFHttpHandler::onReadyRead(QNetworkReply* aReplay)
{
    QJsonDocument doc = QJsonDocument::fromJson(aReplay->readAll());
    if(doc.isNull() || doc.isEmpty())
    {
        qWarning() << tr("Unsuccessful") << aReplay->errorString();
        emit message(RFNotification::Error, aReplay->errorString());
        return;
    }

    QJsonObject obj = doc.object();
    RFControllers::Controller controller = static_cast<RFControllers::Controller>(obj["controller"].toInt());

    if(obj["result"].isBool()) {
        if(obj["result"].toBool()) emit message(RFNotification::Info, tr("Successfull"));
        else emit message(RFNotification::Error, obj["error"].toString());
    }

    if (m_controllers.contains(controller))
        m_controllers[controller]->response(doc);

    emit loading(false);
    emit replay(doc.toJson());
}
