#ifndef RFLOCATIONSMODEL_H
#define RFLOCATIONSMODEL_H

#include <QAbstractListModel>
#include "RFCommonData.h"
#include "RFResponseInterface.h"

class RFLocationsModel : public QAbstractListModel, public RFResponseInterface
{
    Q_OBJECT

public:
    enum RFLocationRole : quint16 {
        IdDisplayRole = Qt::UserRole,
        LocationDisplayRole,
        DescriptionDisplayRole,
    };

private:
    QList<RFLocationData> m_locations;

protected:
    void processResponseData(const QJsonObject &aDocument) override;

public:
    explicit RFLocationsModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent) const override ;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE int locationByName(const QString& aLocation) const;
    Q_INVOKABLE QString locationById(const int aId) const;
    Q_INVOKABLE QString descriptionById(const int aId) const;

public slots:
};

#endif // RFLOCATIONSMODEL_H
