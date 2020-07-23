import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "../controls"

Rectangle {
    id: rfFilterPopup

    property alias hasForest: rfObjects.hasForest
    property alias hasCastles: rfObjects.hasCastle
    property alias hasMonument: rfObjects.hasMonument
    property alias hasMuseum: rfObjects.hasMuseum
    property alias hasAccommodation: rfObjects.hasAccommodation
    property alias hasRestourant: rfObjects.hasRestourant
    property alias contains: rfFilterAll.checked
    property alias minimumDistance: rfSliderDistance.first.value
    property alias maximumDistance: rfSliderDistance.second.value

    signal accepted()

    border.width: 2
    border.color: "#D2D2D2"

    Flickable {
        anchors.fill: parent
        anchors.margins: 25
        contentHeight: rfContent.height
        contentWidth: width
        clip: true

        Rectangle {
            width: parent.width
            height: rfContent.height

            ColumnLayout {
                id: rfContent
                width: parent.width
                spacing: 10

                Text {
                    text: qsTr("Must contain")
                    font.family: fontBold.name
                    font.pixelSize: rfMainWindow.isPhoneResolution ? 14 : 16
                    color: "#999999"
                }

                GridLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    flow: GridLayout.TopToBottom

                    RFRadioButton {
                        id: rfFilterAll
                        text: qsTr("All of them")
                        checked: true
                    }


                    RFRadioButton {
                        id: rfFilterSome
                        text: qsTr("At least some")
                    }

                }

                Text {
                    text: qsTr("Objects")
                    font.family: fontBold.name
                    font.pixelSize: 16
                    color: "#999999"
                }

                RFObjectsBlock {
                    id: rfObjects
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: 260
                    spacing: 10
                    editable: true
                    color: "#000000"
                    header.visible: false
                    fontPixelSize: rfMainWindow.isPhoneResolution ? 14 : 16
                    flow: Flow.TopToBottom
                }

                Text {
                    text: qsTr("Distance")
                    font.family: fontBold.name
                    font.pixelSize: rfMainWindow.isPhoneResolution ? 14 : 16
                    color: "#999999"

                }

                RowLayout {
                    Layout.fillWidth: true

                    TextField {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 30
                        text:Math.ceil(rfSliderDistance.first.value).toString()
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignHCenter
                        onAccepted: rfSliderDistance.first.value = text
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: IntValidator {bottom: 0; top: 100}

                        background: Rectangle {
                            border.width: 1
                            border.color: "#D2D2D2"
                            radius: 4
                        }

                        font.family: fontMedium.name
                        font.pixelSize: rfMainWindow.isPhoneResolution ? 12 : 14
                        color: "#000000"
                    }

                    RangeSlider {
                        id: rfSliderDistance
                        Layout.fillWidth: true
                        from: 0.
                        to: 100.
                        first.value: 0.
                        second.value: 100.

                        background: Rectangle {
                            anchors.verticalCenter: rfSliderDistance.verticalCenter
                            width: rfSliderDistance.width
                            height: 6
                            color: "#D2D2D2"
                            radius: height / 2

                            Rectangle {
                                x: rfSliderDistance.first.visualPosition * parent.width
                                width: rfSliderDistance.second.visualPosition * parent.width - x
                                height: parent.height
                                color: "#0460D9"
                                radius: parent.radius
                            }
                        }

                        first.handle: Rectangle {
                            x: rfSliderDistance.leftPadding + rfSliderDistance.first.visualPosition * (rfSliderDistance.availableWidth - width)
                            y: rfSliderDistance.topPadding + rfSliderDistance.availableHeight / 2 - height / 2
                            width: 14
                            height: width
                            color: "#0460D9"
                            radius: width / 2
                        }


                        second.handle: Rectangle {
                            x: rfSliderDistance.leftPadding + rfSliderDistance.second.visualPosition * (rfSliderDistance.availableWidth - width)
                            y: rfSliderDistance.topPadding + rfSliderDistance.availableHeight / 2 - height / 2
                            width: 14
                            height: width
                            color: "#0460D9"
                            radius: width / 2
                        }
                    }

                    TextField {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 30
                        text: Math.ceil(rfSliderDistance.second.value).toString()
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignHCenter
                        onAccepted: rfSliderDistance.second.value = text
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: IntValidator {bottom: 0; top: 100}

                        background: Rectangle {
                            border.width: 1
                            border.color: "#D2D2D2"
                            radius: 4
                        }

                        font.family: fontMedium.name
                        font.pixelSize: rfMainWindow.isPhoneResolution ? 12 : 14
                        color: "#000000"

                    }
                }
            }
        }
    }


    Keys.onEnterPressed: rfFilterPopup.accepted()
    Keys.onReturnPressed:  rfFilterPopup.accepted()
}
