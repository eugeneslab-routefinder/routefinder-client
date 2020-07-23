import QtQuick 2.12
import QtQuick.Layouts 1.12

import "./components"
import "./controls"
import net.eugeneslab.routefinder 1.0

Item {
    id: root

    signal accepted()

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RFSearchBlock {
            id: rfSearchBlock
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 38
            Layout.maximumHeight: 38
            searchButton.icon.width: 15
            searchButton.icon.height: 15
            filterButton.visible: false

            onAccepted: {
                root.accepted()

//                console.debug("found city: " + cityId + " | " + city)
//                console.debug("minimum length: " + rfFilterContent.minimumDistance)
//                console.debug("maximum length: " + rfFilterContent.maximumDistance)
//                console.debug("hasForest: " + rfFilterContent.hasForest)
//                console.debug("---")

                httpHandler.readRouteList(RFControllers.RouteList,
                                          cityId,
                                          rfFilterContent.minimumDistance,
                                          rfFilterContent.maximumDistance,
                                          rfFilterContent.hasForest,
                                          rfFilterContent.hasCastle,
                                          rfFilterContent.hasMonument,
                                          rfFilterContent.hasMuseum,
                                          rfFilterContent.hasAccommodation,
                                          rfFilterContent.hasRestourant,
                                          rfFilterContent.contains ? 1 : 0,
                                          10)
            }
        }

        RFPopupFilter {
            id: rfFilterContent
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 550
            clip: true
        }
    }
}
