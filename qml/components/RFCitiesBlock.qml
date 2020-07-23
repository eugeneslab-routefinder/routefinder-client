import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "../controls"

Item {
    id: root
    property var locations: []
    property bool editable: false
    property int contentHeight: rfCityLayout.implicitHeight + rfHeader.implicitHeight
    property int limit: 4

    signal selectedCity(var id, var city);
    signal appendCity(var indexCity, var city);
    signal removeCity(var indexCity, var city);

    height: contentHeight

    onLocationsChanged: {
        rfRepeater.model = locations
    }

    Label {
        id: rfHeader
        text: qsTr("Cities:")
        font.family: fontBold.name
        font.pixelSize: 14
        color: "#888888"
    }

    ColumnLayout {
        id: rfCityLayout
        anchors.top: parent.top
        anchors.topMargin: 30
        width: parent.width
        spacing: 5

        Repeater {
            id: rfRepeater
            delegate: Row {
                spacing: 5

                Rectangle {
                    id: rectCircle
                    width: 6
                    height: 6
                    radius: 3
                    color: "#0460D9"
                }

                Label {
                    anchors.verticalCenter: rectCircle.verticalCenter
                    text: modelData
                    font.family: fontMedium.name
                    font.pixelSize: 14
                    color: "#999999"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onExited: parent.color = "#999999"
                        onEntered: parent.color = "#666666"
                        onClicked: {
                            root.selectedCity(locationModel.locationByName(modelData), modelData)
                        }
                    }
                }

                Button {
                    id: rfButtonRemove
                    anchors.verticalCenter: rectCircle.verticalCenter
                    icon.color: "#FFFFFF"
                    icon.source: "qrc:/res/icon/ic_close.svg"
                    icon.width: 15
                    icon.height: 15
                    width: 21
                    height: 21
                    visible: root.editable

                    background: Rectangle {
                        color: "#FF5F53"
                        radius: 4
                    }

                    onClicked: {
                        var tempLocation = root.locations
                        var city = tempLocation.splice(index, 1)
                        var indexCity = locationModel.locationByName(city)
                        root.removeCity(indexCity, city)
                        root.locations = tempLocation
                    }
                }
            }
        }

        RFSearchField {
            Layout.fillWidth: true
            Layout.minimumHeight: 35
            visible: root.editable && locations.length < root.limit

            RFToolTip {
                timeout: 5000
                text: qsTr("Start typing a city.\r\nMaximum cities which you can add: %1\r\n\r\nPush \"Enter\" key to accept the choice").arg(root.limit)

                visible: parent.focus
            }


            onFoundCity: {
                if(root.locations.includes(city)) return

                var tempLocation = root.locations;
                tempLocation.push(city);
                root.locations = tempLocation

                root.appendCity(id, city)
            }
        }
    }
}
