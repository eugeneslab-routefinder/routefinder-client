import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Item {
    id: root

    property int routeId: 0
    property string picture
    property double distance
    property string title
    property bool hasForest: false
    property bool hasCastles: false
    property bool hasMuseums: false
    property bool hasMonuments: false
    property bool hasAccommodation: false
    property bool hasRestourant: false
    property var locations: []

    signal selected(var id)

    width: 276
    height: 374

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Item {
            width: root.width
            height: root.height

            Rectangle {
                anchors.centerIn: parent
                width: root.width
                height: root.height
                radius: 10
            }
        }
    }

    clip: true

    Image {
        anchors.fill: parent
        source: root.picture
        sourceSize.height: height
        sourceClipRect: Qt.rect(sourceSize.width / 2, 0, width, height)

        AnimatedImage {
            anchors.centerIn: parent
            source: "qrc:/res/icon/loading.gif"
            visible: parent.status == Image.Loading
        }

        Item {
            anchors.fill: parent
            visible: parent.status == Image.Error || parent.source == ""

            ColumnLayout
            {
                anchors.centerIn: parent

                Image {
                    Layout.alignment: Qt.AlignCenter
                    source: "qrc:/res/icon/ic_no_picture.svg"
                }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("No image")
                    color: "#999999"
                    font.family: fontBold.name
                    font.pixelSize: 18
                }
            }
        }
    }

    Rectangle {
        id: rfKeyInformation
        width: parent.width
        height: 47
        anchors.left: root.left
        anchors.bottom: root.bottom
        color: "#D8F6F6F6"

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 17
            anchors.rightMargin: 17
            anchors.topMargin: rfKeyInformation.height > 47 ? 7 : 0

            RowLayout {
                Layout.fillWidth: true
                Layout.minimumHeight: 47
                Layout.maximumHeight: 47
                spacing: 5

                Text {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    elide: Label.ElideRight
                    color: "#0460D9"
                    text: root.title
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    font.family: fontBold.name
                    font.pixelSize: 15
                }

                Text {
                    Layout.fillHeight: true
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                    text: root.distance.toString() + " km"
                    font.family: fontBold.name
                    font.pixelSize: 14
                    color: "#888888"
                }
            }

            Item {
                id: itmContent
                Layout.fillWidth: true
                Layout.fillHeight: true
                opacity: rfKeyInformation.height == root.height ? 1 : 0

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 23

                    RFCitiesBlock {
//                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        locations: root.locations
                    }

                    RFObjectsBlock {
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        hasForest: root.hasForest
                        hasCastle: root.hasCastles
                        hasMonument: root.hasMonuments
                        hasMuseum: root.hasMuseums
                        hasAccommodation: root.hasAccommodation
                        hasRestourant: root.hasRestourant
                    }
                }


                Behavior on opacity {
                    NumberAnimation { duration: 120 }
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width
            height: 47
            color: "#0460D9"
            opacity: itmContent.opacity

            Text {
                anchors.fill: parent
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                text: qsTr("Open")
                font.family: fontBold.name
                font.pixelSize: 16
                color: "#FFFFFF"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {}
                onExited: {}

            }
        }

        Behavior on height {
            NumberAnimation { duration: 140 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        focus: false

        onFocusChanged: {
            if(!focus) rfKeyInformation.height = 47
            else rfKeyInformation.height = parent.height
        }

        onEntered: {
            if(!rfMainWindow.isTabletResolution)
                focus = true
        }

        onExited: {
            if(!rfMainWindow.isTabletResolution)
                focus = false
        }

        onClicked: {
            if(rfMainWindow.isTabletResolution && !focus)
            {
                focus = true
                return;
            }

            root.selected(routeId)
        }
    }
}
