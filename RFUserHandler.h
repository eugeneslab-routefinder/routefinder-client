#ifndef RFUSERHANDLER_H
#define RFUSERHANDLER_H

#include <QObject>

class RFUserHandler : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool authorizated READ authorizated WRITE setAuthorizated NOTIFY authorizatedChanged)

    bool m_authorizated;

public:
    explicit RFUserHandler(QObject *parent = nullptr);
    bool authorizated() const;

public slots:
    void setAuthorizated(const bool authorizated);
    void authorization(const QString& aEmail, const QString& aPassword);

signals:
    void authorizatedChanged(bool authorizated);
};

#endif // RFUSERHANDLER_H
