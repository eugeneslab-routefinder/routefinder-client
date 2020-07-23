#include "RFResponseInterface.h"

RFResponseInterface::RFResponseInterface(const RFControllers::Controller aController) :
    m_id(aController)
{

}

void RFResponseInterface::response(const QJsonDocument &aResponse)
{
    processResponseData(aResponse.object());
}
