#include "RFRouteModel.h"

RFRouteModel::RFRouteModel(const QString& aHost, const quint16 aPort, QObject *parent) : QAbstractListModel(parent),
    RFResponseInterface(RFControllers::RouteList),
    m_host(aHost),
    m_port(aPort)
{

}

void RFRouteModel::processResponseData(const QJsonObject &aDocument)
{
    int msg = aDocument["message"].toInt();

    beginResetModel();
    if(msg == RFControllers::MessageType::RouteData)
    {
        QJsonArray array = aDocument["result"].toArray();

        m_routeData.clear();

        for(int i = 0; i < array.count(); i++)
        {
            QJsonObject object = array.at(i).toObject();
            RFRouteData route;
            route.id = object["id"].toInt();
            route.title = object["title"].toString();
            route.description = object["description"].toString();
            route.picture = appendHostToUrl(m_host, m_port, object["picture"].toString());
            route.hasForest = object["hasForest"].toBool();
            route.hasCastles = object["hasCastles"].toBool();
            route.hasMonuments = object["hasMonuments"].toBool();
            route.hasMuseums = object["hasMuseums"].toBool();
            route.hasAccommodation = object["hasAccommodations"].toBool();
            route.hasRestourant = object["hasRestourants"].toBool();
            route.link = object["link"].toString();
            route.distance = object["distance"].toDouble();
            route.album = appendHostToUrls(m_host, m_port, object["album"].toString());

            QJsonArray location = object["locations"].toArray();

            for(int m = 0; m < location.count(); m++)
            {
                QJsonObject locationObj = location.at(m).toObject();
                route.location.append(locationObj["location"].toString());
            }

            m_routeData.append(route);
        }
    }
    else if(msg == RFControllers::MessageType::RemovePicture)
    {
        for(int i = 0; i < m_routeData.count(); i++)
        {
            if(m_routeData[i].id == aDocument["id"].toInt())
            {
                QString path = appendHostToUrl(m_host, m_port, aDocument["picture"].toString());
                int index = m_routeData[i].album.indexOf(path);
                if(index != -1) {
                    m_routeData[i].album.removeAt(index);
                    emit album(m_routeData[i].album);
                }

                break;
            }
        }
    }
    else if(msg == RFControllers::MessageType::InsertPicture)
    {
        for(int i = 0; i < m_routeData.count(); i++)
        {
            if(m_routeData[i].id == aDocument["id"].toInt())
            {
                QString path = "http://" + m_host + ":" + QString::number(m_port) + "/" + aDocument["picture"].toString();
                m_routeData[i].album.append(path);
                emit album(m_routeData[i].album);
                break;
            }
        }
    }
    else if(msg == RFControllers::MessageType::InsertRote)
    {
        RFRouteData route;
        route.id = aDocument["id"].toInt();
        m_routeData.append(route);
        emit createdRoute(route.id);
    }

    endResetModel();
}


int RFRouteModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_routeData.count();
}

QVariant RFRouteModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) return QVariant();

    switch (role) {
        case IdDisplayRole: return m_routeData[index.row()].id;
        case TitleDisplayRole: return m_routeData[index.row()].title;
        case DescriptionDisplayRole: return m_routeData[index.row()].description;
        case LocationDisplayRole: return m_routeData[index.row()].location;
        case RouteDisplayRole: return m_routeData[index.row()].picture;
        case HasForestDisplayRole: return m_routeData[index.row()].hasForest;
        case HasCastlesDisplayRole: return m_routeData[index.row()].hasCastles;
        case HasMonumentsDisplayRole: return m_routeData[index.row()].hasMonuments;
        case HasMuseumsDisplayRole: return m_routeData[index.row()].hasMuseums;
        case HasAccommodationDisplayRole: return m_routeData[index.row()].hasAccommodation;
        case HasRestourantDisplayRole: return m_routeData[index.row()].hasRestourant;
        case LinkDisplayRole: return m_routeData[index.row()].link;
        case DistanceDisplayRole: return m_routeData[index.row()].distance;
        case AlbumDisplayRole: return m_routeData[index.row()].album;
        default: break;
    }

    return QVariant();
}

QHash<int, QByteArray> RFRouteModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdDisplayRole] = "idDisplayRole";
    roles[TitleDisplayRole] = "titleDisplayRole";
    roles[DescriptionDisplayRole] = "descriptionDisplayRole";
    roles[LocationDisplayRole] = "locationDisplayRole";
    roles[RouteDisplayRole] = "routeDisplayRole";
    roles[HasForestDisplayRole] = "hasForestDisplayRole";
    roles[HasCastlesDisplayRole] = "hasCastlesDisplayRole";
    roles[HasMonumentsDisplayRole] = "hasMonumentsDisplayRole";
    roles[HasMuseumsDisplayRole] = "hasMuseumsDisplayRole";
    roles[HasRestourantDisplayRole] = "hasRestourantDisplayRole";
    roles[HasAccommodationDisplayRole] = "hasAccommodationDisplayRole";
    roles[LinkDisplayRole] = "linkDisplayRole";
    roles[DistanceDisplayRole] = "distanceDisplayRole";
    roles[AlbumDisplayRole] = "albumDisplayRole";
    return roles;
}

QStringList RFRouteModel::locations(const int aRouteId) const
{
    if(!aRouteId) return QStringList();

    for(int i = 0; i < m_routeData.count(); i++)
    {
        if(m_routeData[i].id == aRouteId)
            return m_routeData[i].location;
    }

    return QStringList();
}
