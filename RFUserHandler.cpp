#include "RFUserHandler.h"

RFUserHandler::RFUserHandler(QObject *parent) : QObject(parent),
    m_authorizated(false)
{

}

bool RFUserHandler::authorizated() const
{
    return m_authorizated;
}

void RFUserHandler::setAuthorizated(const bool authorizated)
{
    if (m_authorizated == authorizated)
        return;

    m_authorizated = authorizated;
    emit authorizatedChanged(m_authorizated);
}

void RFUserHandler::authorization(const QString &aEmail, const QString &aPassword)
{
    setAuthorizated(aEmail == "admin@admin" && aPassword == "admin123");
}
