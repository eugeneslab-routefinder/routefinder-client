import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Item {
    id: root
    property int fontPixelSize: 14
    property string fontFamily: fontMedium.name
    property alias hasForest: rfForestCheckbox.checked
    property alias hasCastle: rfCastleCheckbox.checked
    property alias hasMuseum: rfMuseumsCheckbox.checked
    property alias hasMonument: rfMonumentsCheckbox.checked
    property alias hasAccommodation: rfHotelCheckbox.checked
    property alias hasRestourant: rfRestourantCheckbox.checked
    property int spacing: 0
    property color color: "#999999"
    property alias header: rfHeader
    property bool editable: false
    property alias flow: rfFlow.flow
    property int contentHeight: rfFlow.implicitHeight + rfHeader.implicitHeight

    signal stateChanged();

    Label {
        id: rfHeader
        text: qsTr("Objects")
        font.family: fontBold.name
        font.pixelSize: 14
        color: "#999999"
    }

    Flow {
        id: rfFlow
        anchors.fill: parent
        anchors.topMargin: rfHeader.visible ? rfHeader.height + 10 : 0
        width: parent.width
        spacing: root.editable ? 10 : 0
        clip: true

        CheckBox {
            id: rfForestCheckbox
            checkable: root.editable
            indicator: Rectangle {
                width: 30
                height: 30
                color: "transparent"
                border.width: root.editable ? 1 : 0
                border.color: "#D2D2D2"
                radius: 4

                Image {
                    anchors.centerIn: parent
                    width: sourceSize.width
                    height: sourceSize.height
                    source: {
                        if(root.editable) {
                            if(rfForestCheckbox.checked){
                                "qrc:/res/icon/ic_check.svg"
                            }
                            else {
                                ""
                            }
                        }
                        else {
                            "qrc:/res/icon/ic_forest.svg"
                        }
                    }
                }
            }

            contentItem:  Text {
                anchors.verticalCenter: rfForestCheckbox.indicator.verticalCenter
                text: qsTr("Forest")
                leftPadding: root.editable ? 45 : 30
                font.pixelSize: root.fontPixelSize
                font.family: root.fontFamily
                color: root.color
            }

            visible: !checkable ? checked : true

            onToggled: {
                if(root.editable)
                    root.stateChanged()
            }
        }

        CheckBox {
            id: rfCastleCheckbox
            checkable: root.editable
            indicator: Rectangle {
                width: 30
                height: 30
                color: "transparent"
                border.width: root.editable ? 1 : 0
                border.color: "#D2D2D2"
                enabled: root.editable
                radius: 4

                Image {
                    anchors.centerIn: parent
                    width: sourceSize.width
                    height: sourceSize.height
                    source: {
                        if(root.editable) {
                            if(rfCastleCheckbox.checked){
                                "qrc:/res/icon/ic_check.svg"
                            }
                            else {
                                ""
                            }
                        }
                        else {
                            "qrc:/res/icon/ic_castle.svg"
                        }
                    }
                }
            }

            contentItem:  Text {
                anchors.verticalCenter: rfCastleCheckbox.indicator.verticalCenter
                text: qsTr("Castles")
                leftPadding: root.editable ? 45 : 30
                font.pixelSize: root.fontPixelSize
                font.family: root.fontFamily
                color: root.color
            }

            visible: !checkable ? checked : true

            onToggled: {
                if(root.editable)
                    root.stateChanged()
            }
        }

        CheckBox {
            id: rfMonumentsCheckbox
            checkable: root.editable
            indicator: Rectangle {
                width: 30
                height: 30
                color: "transparent"
                border.width: root.editable ? 1 : 0
                border.color: "#D2D2D2"
                radius: 4

                Image {
                    anchors.centerIn: parent
                    width: sourceSize.width
                    height: sourceSize.height
                    source: {
                        if(root.editable) {
                            if(rfMonumentsCheckbox.checked){
                                "qrc:/res/icon/ic_check.svg"
                            }
                            else {
                                ""
                            }
                        }
                        else {
                            "qrc:/res/icon/ic_monument.svg"
                        }
                    }
                }
            }

            contentItem:  Text {
                anchors.verticalCenter: rfMonumentsCheckbox.indicator.verticalCenter
                text: qsTr("Monuments")
                leftPadding: root.editable ? 45 : 30
                font.pixelSize: root.fontPixelSize
                font.family: root.fontFamily
                color: root.color
            }

            visible: !checkable ? checked : true

            onToggled: {
                if(root.editable)
                    root.stateChanged()
            }
        }

        CheckBox {
            id: rfMuseumsCheckbox
            checkable: root.editable
            indicator: Rectangle {
                width: 30
                height: 30
                color: "transparent"
                border.width: root.editable ? 1 : 0
                border.color: "#D2D2D2"
                radius: 4

                Image {
                    anchors.centerIn: parent
                    width: sourceSize.width
                    height: sourceSize.height
                    source: {
                        if(root.editable) {
                            if(rfMuseumsCheckbox.checked){
                                "qrc:/res/icon/ic_check.svg"
                            }
                            else {
                                ""
                            }
                        }
                        else {
                            "qrc:/res/icon/ic_museum.svg"
                        }
                    }
                }
            }

            contentItem:  Text {
                anchors.verticalCenter: rfMuseumsCheckbox.indicator.verticalCenter
                text: qsTr("Museums")
                leftPadding: root.editable ? 45 : 30
                font.pixelSize: root.fontPixelSize
                font.family: root.fontFamily
                color: root.color
            }

            visible: !checkable ? checked : true

            onToggled: {
                if(root.editable)
                    root.stateChanged()
            }
        }

        CheckBox {
            id: rfHotelCheckbox
            checkable: root.editable
            indicator: Rectangle {
                width: 30
                height: 30
                color: "transparent"
                border.width: root.editable ? 1 : 0
                border.color: "#D2D2D2"
                radius: 4

                Image {
                    anchors.centerIn: parent
                    width: sourceSize.width
                    height: sourceSize.height
                    source: {
                        if(root.editable) {
                            if(rfHotelCheckbox.checked){
                                "qrc:/res/icon/ic_check.svg"
                            }
                            else {
                                ""
                            }
                        }
                        else {
                            "qrc:/res/icon/ic_accommodation.svg"
                        }
                    }
                }
            }

            contentItem:  Text {
                anchors.verticalCenter: rfHotelCheckbox.indicator.verticalCenter
                text: qsTr("Accommodation")
                leftPadding: root.editable ? 45 : 30
                font.pixelSize: root.fontPixelSize
                font.family: root.fontFamily
                color: root.color
            }

            visible: !checkable ? checked : true

            onToggled: {
                if(root.editable)
                    root.stateChanged()
            }
        }

        CheckBox {
            id: rfRestourantCheckbox
            checkable: root.editable
            indicator: Rectangle {
                width: 30
                height: 30
                color: "transparent"
                border.width: root.editable ? 1 : 0
                border.color: "#D2D2D2"
                radius: 4

                Image {
                    anchors.centerIn: parent
                    width: sourceSize.width
                    height: sourceSize.height
                    source: {
                        if(root.editable) {
                            if(rfRestourantCheckbox.checked){
                                "qrc:/res/icon/ic_check.svg"
                            }
                            else {
                                ""
                            }
                        }
                        else {
                            "qrc:/res/icon/ic_restourant.svg"
                        }
                    }
                }
            }

            contentItem:  Text {
                anchors.verticalCenter: rfRestourantCheckbox.indicator.verticalCenter
                text: qsTr("Restaurant")
                leftPadding: root.editable ? 45 : 30
                font.pixelSize: root.fontPixelSize
                font.family: root.fontFamily
                color: root.color
            }

            visible: !checkable ? checked : true

            onToggled: {
                if(root.editable)
                    root.stateChanged()
            }
        }
    }
}

