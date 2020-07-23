import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "../controls"
import net.eugeneslab.routefinder 1.0

Item {
    id: root

    property alias searchFiled: rfSearchField
    property alias searchButton: rfSearchButton
    property alias filterButton: rfFilterButton

    signal accepted(var cityId, var city);
    signal filterOpen()
    signal filterClose()

    RowLayout {
        anchors.fill: parent
        spacing: rfMainWindow.isPhoneResolution ? 8 : 20

        RFSearchField {
            id: rfSearchField
            Layout.fillWidth: true
            Layout.fillHeight: true
            placeholderText: qsTr("Start typing a city here...")

            onFoundCity: {
                root.accepted(id, city)
            }

            Button {
                id: rfFilterButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                width: height
                height: parent.height - 10
                icon.source: "qrc:/res/icon/ic_filter.svg"
                icon.color: "#0460d9"
                hoverEnabled: true
                checkable: true
//                checked: rfFilter.visible

                background: Rectangle {
                    color: parent.hovered || parent.checked ? "#6677B2FF" : "transparent"
                    radius: width / 2
                }

//                onClicked: {
//                    if(!checked) rfFilterPopup.close()
//                    else rfFilterPopup.open()
//                }
            }
        }

        Button {
            id: rfSearchButton
            Layout.fillHeight: true
            Layout.preferredHeight: rfSearchField.height
            Layout.preferredWidth: height
            icon.source: "qrc:/res/icon/ic_search.svg"
            icon.color: "#FFFFFF"
            hoverEnabled: true
            onClicked: {
                rfSearchField.search()
            }

            background: Rectangle {
                color: parent.hovered ? "#77B2FF" : "#0460D9"
                radius: rfSearchField.radius
            }
        }
    }

//    Popup {
//        id: rfFilterPopup
//        x: rfSearchField.x
//        y: rfSearchField.height - 2
//        width: rfSearchField.width
//        height: 550

//        background: RFPopupFilter {
//            id: rfFilter
//            anchors.fill: parent
//            color: "#E0FFFFFF"
//            radius: 10

//            Keys.onEnterPressed: {
//                rfFilterPopup.close()
//                rfSearchField.search()
//            }

//            Keys.onReturnPressed: {
//                rfFilterPopup.close()
//                rfSearchField.search()
//            }
//        }
//    }
}
