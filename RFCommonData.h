#ifndef RFCOMMONDATA_H
#define RFCOMMONDATA_H

#include <QString>
#include <QStringList>
#include <QObject>

struct RFRouteData {
    int id;
    QString title;
    QString description;
    QString picture;
    QString link;
    double distance;
    bool hasForest;
    bool hasCastles;
    bool hasMuseums;
    bool hasMonuments;
    bool hasAccommodation;
    bool hasRestourant;
    QStringList album;
    QStringList location;
};

struct RFLocationData {
    int id;
    QString location;
    QString description;
};

inline QString appendHostToUrl(const QString& aHost, const quint16 aPort, const QString& aImage)
{
    if(aImage.isEmpty()) return QString();
    return "http://" + aHost + ":" + QString::number(aPort) + "/" + aImage;
}

inline QStringList appendHostToUrls(const QString& aHost, const quint16 aPort, const QString& aAlbum)
{
    if(aAlbum.isEmpty()) return QStringList();
    QStringList album, pictures = aAlbum.split(";");

    for(int i = 0; i < pictures.count(); i++)
        album.append("http://" + aHost + ":" + QString::number(aPort) + "/" + pictures[i]);

    return album;
}

inline QString removeHostFromUrl(const QString& aUrl)
{
    if(aUrl.isEmpty()) return QString();
    QString uri = aUrl;
    return uri.replace(QRegExp("(^http:\\/\\/\\d+\\.\\d+\\.\\d+\\.\\d+:\\d+\\/)"), "");
}

class RFControllers {

    Q_GADGET

public:
    enum Controller {
        None,
        LocationList,
        RouteList
    };
    Q_ENUM(Controller)

    enum MessageType {
        Unknow,
        InsertRote,
        InsertPicture,
        RemovePicture,
        Cover,
        RouteData
    };
    Q_ENUM(MessageType)
};

class RFNotification {

    Q_GADGET

public:
    enum Message {
        Unknow,
        Debug,
        Info,
        Warning,
        Error
    };
    Q_ENUM(Message)
};

#endif // RFCOMMONDATA_H
