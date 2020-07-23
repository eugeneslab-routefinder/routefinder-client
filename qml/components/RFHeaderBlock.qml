import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "../controls"
import net.eugeneslab.routefinder 1.0

Item {
    id: root

    property bool visibleSearchField: rfSearchField.visible

    signal clickedSearchButton()

    RowLayout {
        anchors.fill: parent
        spacing: 14

        RFIconFlatButton {
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignLeft
//            icon.source: "qrc:/res/icon/ic_menu.svg"
            enabled: false
            icon.width: 22
            icon.height: 6
            visible: rfMainWindow.isPhoneResolution
        }

        //  Logotype
        Label {
            Layout.fillWidth: rfMainWindow.isPhoneResolution
            Layout.alignment: rfMainWindow.isPhoneResolution ? Qt.AlignHCenter : Qt.AlignLeft
            horizontalAlignment: Qt.AlignHCenter
            text: rfMainWindow.title
            font.family: fontBold.name
            font.pixelSize: 28
            color: "#0460D9"
        }

        RFIconFlatButton {
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignRight
            enabled: rfStackView.depth == 1
            icon.source: enabled ? "qrc:/res/icon/ic_search.svg" : ""
            icon.width: 15
            icon.height: 15
            visible: rfMainWindow.isPhoneResolution

            onClicked: root.clickedSearchButton()
        }

         //  Space
        Item {
            Layout.fillHeight: true
            Layout.minimumWidth: 65
            visible: !rfMainWindow.isPhoneResolution
        }

        //  SearchField
        RFSearchBlock {
            id: rfSearchField
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 329
            searchButton.icon.width: 15
            searchButton.icon.height: 15
            visible: !rfMainWindow.isPhoneResolution && rfStackView.depth == 1

            filterButton.onClicked: rfFilter.visible = filterButton.checked
            onVisibleChanged: {
                if(!visible) {
                    rfFilter.visible = false
                }
            }

            Popup {
                id: rfFilter
                x: 0
                y: parent.searchFiled.height - 2
                width: parent.searchFiled.width

                background: RFPopupFilter {
                    id: rfFilterContent
                    width: parent.width
                    height: 550

                    onAccepted: rfSearchField.searchFiled.search()
                }

                onClosed: parent.filterButton.checked = false

            }

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
            }
        }

        //  Space
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        //  Add route button
        RFButton {
            Layout.fillHeight: true
            Layout.preferredWidth: 184
            text: qsTr("Add route")
            visible: userHandler.authorizated
            onClicked: {
                httpHandler.writeInsertRoute(RFControllers.RouteList);
            }
        }

        // LogIn
        RFFlatButton {
            id: rfLoginButton
            Layout.fillHeight: true
            Layout.minimumWidth: 184
            text: userHandler.authorizated ? qsTr("Log out") : qsTr("Log in")
            visible: !rfMainWindow.isPhoneResolution

            onClicked: {
                if(userHandler.authorizated)
                    userHandler.authorizated = false;
//                else
//                {
//                    rfStackView.push("RFAuthorizationScreen.qml");
//                    visible = false
////                            rfBackToSearchButton.visible = true
//                }
            }

            states: [
                State {
                    name: "logout"
                    PropertyChanges { target: rfLoginButton; text: qsTr("Log out") }
                },

                State {
                    name: "back"
                    PropertyChanges { target: rfLoginButton; text: qsTr("Back to search")  }
                }
            ]
        }

//        RFFlatButton {
//            id: rfBackToSearchButton
//            Layout.fillHeight: true
//            Layout.minimumWidth: 184
//            text: qsTr("Back to search")
//            visible: !userHandler.authorizated && rfLoginButton.visible == false

//            onClicked: {
//                rfStackView.pop();
//                rfLoginButton.visible = true
//            }
//        }
    }
}
