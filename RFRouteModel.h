#ifndef RFROUTEMODEL_H
#define RFROUTEMODEL_H

#include <QAbstractListModel>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include "RFCommonData.h"
#include "RFResponseInterface.h"

class RFRouteModel : public QAbstractListModel, public RFResponseInterface
{
    Q_OBJECT

public:
    enum RFRouteRole : quint16 {
        IdDisplayRole = Qt::UserRole,
        TitleDisplayRole,
        DescriptionDisplayRole,
        LocationDisplayRole,
        RouteDisplayRole,
        HasForestDisplayRole,
        HasCastlesDisplayRole,
        HasMonumentsDisplayRole,
        HasMuseumsDisplayRole,
        HasAccommodationDisplayRole,
        HasRestourantDisplayRole,
        AlbumDisplayRole,
        LinkDisplayRole,
        DistanceDisplayRole
    };

private:
    QVector<RFRouteData> m_routeData;
    QString m_host;
    quint16 m_port;

protected:
    void processResponseData(const QJsonObject &aDocument) override;

public:
    explicit RFRouteModel(const QString& aHost, const quint16 aPort, QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QStringList locations(const int aRouteId) const;

signals:
    void album(QStringList album);
    void createdRoute(int id);
};

#endif // RFROUTEMODEL_H
