#ifndef RFRESPONSEINTERFACE_H
#define RFRESPONSEINTERFACE_H

#include <QByteArray>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QUuid>
#include "RFCommonData.h"

class RFResponseInterface
{

private:
    RFControllers::Controller m_id;

protected:
    virtual void processResponseData(const QJsonObject& aDocument) = 0;

public:
    explicit RFResponseInterface(const RFControllers::Controller aController);

    void response(const QJsonDocument& aResponse);
};

#endif // RFRESPONSEINTERFACE_H
