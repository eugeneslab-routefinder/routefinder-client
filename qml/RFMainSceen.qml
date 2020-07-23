import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "./components"
import "./controls"
import "../res/js/strings.js" as Strings

Rectangle {
    id: root
    color: "transparent"
    focus: true

    RowLayout {
        anchors.fill: parent
        spacing: 0

        GridView {
            id: rfRouteResult
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellHeight: 394
            cellWidth: root.width / Math.floor(width / 276)

            clip: true

            model: routeModel

            delegate: RFRouteBlock {
                width: rfRouteResult.cellWidth - 10

                routeId: idDisplayRole
                picture: routeDisplayRole
                title: titleDisplayRole
                distance: distanceDisplayRole
                locations: locationDisplayRole
                hasForest: hasForestDisplayRole
                hasCastles: hasCastlesDisplayRole
                hasMonuments: hasMonumentsDisplayRole
                hasMuseums: hasMuseumsDisplayRole
                hasAccommodation: hasAccommodationDisplayRole
                hasRestourant: hasRestourantDisplayRole

                onSelected: {
                    rfRouteScreen.routeId = routeId
                    rfRouteScreen.title = title
                    rfRouteScreen.picture = picture
                    rfRouteScreen.description = descriptionDisplayRole
                    rfRouteScreen.hasForest = hasForest
                    rfRouteScreen.hasCastles = hasCastles
                    rfRouteScreen.hasMuseums = hasMuseums
                    rfRouteScreen.hasMonuments = hasMonuments
                    rfRouteScreen.hasAccommodation = hasAccommodation
                    rfRouteScreen.hasRestourant = hasRestourant
                    rfRouteScreen.distance = distance
                    rfRouteScreen.locations = locations
                    rfRouteScreen.link = linkDisplayRole
                    rfRouteScreen.album = albumDisplayRole
                    rfRouteScreen.toTop()

                    rfStackView.push(rfRouteScreen)
                }
            }

        }

    }

    Item {
        anchors.fill: parent
        visible: rfRouteResult.count < 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 27

            Image {
                 Layout.alignment: Qt.AlignCenter
                source: "qrc:/res/icon/ic_no_result.svg"
            }

            Text {
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: rfMainWindow.isPhoneResolution ? 22 : rfMainWindow.width / 36
                font.family: fontBold.name
                color: "#999999"
                text: qsTr("Result is empty")
            }
        }
    }
}
