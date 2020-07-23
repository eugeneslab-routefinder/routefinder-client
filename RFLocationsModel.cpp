#include "RFLocationsModel.h"

RFLocationsModel::RFLocationsModel(QObject *parent) : QAbstractListModel(parent), RFResponseInterface(RFControllers::LocationList)
{

}

void RFLocationsModel::processResponseData(const QJsonObject &aDocument)
{
    beginResetModel();
    m_locations.clear();

    QJsonArray array = aDocument["result"].toArray();
    for(int i = 0; i < array.count(); i++)
    {
        QJsonObject object = array[i].toObject();

        RFLocationData data;
        data.id = object["id"].toInt();
        data.location = object["location"].toString();
        data.description = object["description"].toString();

        m_locations.append(data);
    }

    endResetModel();
}

int RFLocationsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_locations.count();
}

QVariant RFLocationsModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid()) return QVariant();

    switch (role) {
        case IdDisplayRole: return m_locations[index.row()].id;
        case LocationDisplayRole: return  m_locations[index.row()].location;
        case DescriptionDisplayRole: return m_locations[index.row()].description;
    }

    return QVariant();
}

QHash<int, QByteArray> RFLocationsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdDisplayRole] = "idDisplayRole";
    roles[LocationDisplayRole] = "locationDisplayRole";
    roles[DescriptionDisplayRole] = "descriptionDisplayRole";
    return roles;
}

int RFLocationsModel::locationByName(const QString &aLocation) const
{
    for(int i = 0; i < m_locations.count(); i++)
        if(m_locations[i].location == aLocation) return m_locations[i].id;

    return 0;
}

QString RFLocationsModel::locationById(const int aId) const
{
    for(int i = 0; i < m_locations.count(); i++)
        if(m_locations[i].id == aId) return m_locations[i].location;

    return QString();
}

QString RFLocationsModel::descriptionById(const int aId) const
{
    for(int i = 0; i < m_locations.count(); i++)
        if(m_locations[i].id == aId) return m_locations[i].description;

    return QString();
}

