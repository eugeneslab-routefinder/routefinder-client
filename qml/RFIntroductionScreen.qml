import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "./components"
import net.eugeneslab.routefinder 1.0

Rectangle {
    id: root
    color: "#FFFFFF"

    Image {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        sourceSize.width: parent.width
        source: "qrc:/res/icon/introduction.png"
    }

//    Label {
//        anchors.left: parent.left
//        anchors.top: parent.top
//        anchors.topMargin: 25
//        anchors.leftMargin: rfMainWindow.isTabletResolution ? 42 : 117
//        text: rfMainWindow.title
//        font.family: fontBold.name
//        font.pixelSize: 28
//        color: "#0460D9"
//    }

    ColumnLayout {

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: rfMainWindow.isTabletResolution ? 42 : 117
        anchors.rightMargin: rfMainWindow.isTabletResolution ? 42 : 117
        anchors.verticalCenter: parent.verticalCenter
//        anchors.bottomMargin: - (rfSearch.height / 2)
        spacing: 30

        Text {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            text: qsTr("Time to travel")
            font.family: fontBold.name
            font.pixelSize: rfMainWindow.isPhoneResolution ? 18 : rfMainWindow.width / 35
            font.capitalization: Font.AllUppercase
            color: "#0460D9"
        }

        Text {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.bottomMargin: rfMainWindow.isPhoneResolution ? 10 : 89
            Layout.maximumWidth: 665
            text:  qsTr("Whether at home or on the road, find your perfect route. Filter by distance, objects, and difficulty level. Great views are a few taps away and interesting historical information")
            color: "#000000"
            font.pixelSize: rfMainWindow.isPhoneResolution ? 16 : 24
            font.family: fontMedium.name
            wrapMode: Text.WordWrap
        }

        Rectangle {
            id: rfSearch
            Layout.fillWidth: true
            Layout.preferredHeight: rfMainWindow.isTabletResolution ? 52 : 130
            color: "#A0F2F2F2"
            radius: 15

            RFSearchBlock {
                id: rfSearchBlock
                anchors.fill: parent
                anchors.leftMargin: rfMainWindow.isTabletResolution ? 10 : 30
                anchors.rightMargin: rfMainWindow.isTabletResolution ? 10 : 30
                anchors.topMargin: rfMainWindow.isTabletResolution ? 5 : 20
                anchors.bottomMargin: rfMainWindow.isTabletResolution ? 5 : 20
                searchFiled.font.pixelSize:  rfMainWindow.isTabletResolution ? 16 : 24
                searchFiled.radius: rfMainWindow.isTabletResolution ? 10 : 30
                searchButton.icon.height: rfMainWindow.isTabletResolution ? 15 : 32
                searchButton.icon.width: rfMainWindow.isTabletResolution ? 15 : 32
                searchFiled.focus: true

                filterButton.onClicked: rfPopupFilter.visible  = true

                onAccepted: {
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

                    root.opacity = 0;
                    focus = false
                }
            }
        }
    }

    Popup {
        id: rfPopupFilter
        x: 30
        y: 30
        width: root.width - 60
        height: root.height - 60

        background: RFPopupFilter {
            id: rfFilterContent
            opacity: 0.8
        }

        onVisibleChanged: {
            if(!visible) rfSearchBlock.filterButton.checked = false
        }
    }


    Behavior on opacity {
        NumberAnimation { duration: 800 }
    }

    visible: opacity == .0 ? false : true
}
