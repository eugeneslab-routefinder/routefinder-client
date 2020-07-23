import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import net.eugeneslab.routefinder 1.0
import "./components"
import "./controls"
import "../res/js/strings.js" as Strings

ApplicationWindow  {
    property bool fullScreen: false

    id: rfMainWindow
    visible: true
    width: 1024
    height: 768
    title: "Routefinder"
    minimumHeight: 568
    minimumWidth: 320

    onClosing: {
        if(rfStackView.depth > 1 && isTabletResolution)
        {
            close.accepted = false;
            rfStackView.pop()
        }
        else {
            close.accepted = true;
        }
    }

    Component.onCompleted: {
        showMaximized()
        httpHandler.readLocations(RFControllers.LocationList)
        rfLoading.running = false
    }

    Image {
        id: rfBackground
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        source: "qrc:/res/icon/backgroudn.png"
        sourceSize.height: parent.height / 1.5
        opacity: 0.2
//        mirror: true
//        visible: !rfBackToSearchButton.visible
    }

    readonly property bool isPortrait: width < height
    readonly property bool isTabletResolution: width < 1500
    readonly property bool isPhoneResolution: width < 900
    readonly property FontLoader fontBold: FontLoader{ source: "qrc:/res/font/Montserrat-SemiBold.ttf" }
    readonly property FontLoader fontLight: FontLoader { source: "qrc:/res/font/Montserrat-Light.ttf" }
    readonly property FontLoader fontMedium: FontLoader { source: "qrc:/res/font/Montserrat-Medium.ttf" }

    RFSearchScreen {
        id: rfSearchPhoneScreen;
        visible: false
        onAccepted: rfStackView.pop()
    }

    RFRouteScreen {
        id: rfRouteScreen
        visible: false
    }

    Page {
        anchors.fill: parent
        anchors.leftMargin: {
            if(rfMainWindow.isTabletResolution && !rfMainWindow.isPhoneResolution) 42
            else if(rfMainWindow.isPhoneResolution)  20
            else 189
        }
        anchors.rightMargin: {
            if(rfMainWindow.isTabletResolution && !rfMainWindow.isPhoneResolution) 42
            else if(rfMainWindow.isPhoneResolution)  20
            else 189
        }
        anchors.topMargin: 26
        anchors.bottomMargin: 26

        background: Rectangle {
            color: "transparent"
        }

        header: RFHeaderBlock {
            id: rfHeaderMenu
            width: parent.width
            height: 39

            onClickedSearchButton: {
                if(rfStackView.currentItem == rfSearchPhoneScreen)
                    rfStackView.pop()
                else
                    rfStackView.push(rfSearchPhoneScreen)
            }
        }

        StackView {
            id: rfStackView
            anchors.fill: parent
            anchors.topMargin: rfMainWindow.height < 900 ? 20 : 50
            initialItem: RFMainSceen {}
            onDepthChanged: rfHeaderMenu.visibleSearchField = depth == 1

            onWidthChanged: {
                if(!rfMainWindow.isPhoneResolution && currentItem == rfSearchPhoneScreen)
                    pop()
            }
        }
    }

    RFImageViewer {
        id: rfImageViewer
        anchors.fill: parent
        visible: false
    }

    ListModel {
        id: rfNotifyList
    }

    ColumnLayout {
        width: 286
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 85

        Repeater {
            id: rfMessageManager
            model: rfNotifyList
            delegate: Label {
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                padding: 15
                topPadding: 45
                color: "#FFFFFF"
                font.family: fontMedium.name
                font.pixelSize: 14

                background: Rectangle {
                    radius: 10

                    color: {
                        switch(type) {
                            case RFNotification.Error: "#FF5F53"; break;
                            case RFNotification.Info:  "#31AB1F"; break;
                            case RFNotification.Warning: "#25B1CC"; break;
                            default: "#31AB1F"; break
                        }
                    }
                }

                text: message

                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    color: "#FFFFFF"
                    font.family: fontBold.name
                    font.pixelSize: 16

                    text: {
                        switch(type) {
                            case RFNotification.Error: qsTr("Error!"); break;
                            case RFNotification.Info:  qsTr("Notify"); break;
                            case RFNotification.Warning: qsTr("Warning!"); break;
                            default: ""; break
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 10000 }
                }

                Timer {
                    interval: 10000
                    running: true

                    onTriggered: {
                        rfNotifyList.remove(index)
                    }
                }

                Component.onCompleted: {
                    opacity = 0;
                }
            }
        }
    }

//    ==============================================================
    RFIntroductionScreen {
        anchors.fill: parent
    }
//    ==============================================================


    BusyIndicator {
        id: rfLoading
        anchors.centerIn: parent
        running: true

        contentItem: Item {
            implicitWidth: 64
            implicitHeight: 64

            Item {
                id: item
                x: parent.width / 2 - 32
                y: parent.height / 2 - 32
                width: 64
                height: 64
                opacity: rfLoading.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item
                    running: rfLoading.visible && rfLoading.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 6

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 10
                        implicitHeight: 10
                        radius: 5
                        color: "#DD4912"
                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5 + 5
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: 5
                                origin.y: 5
                            }
                        ]
                    }
                }
            }
        }
    }

    Connections {
        target: httpHandler
        function onLoading(status) {
            rfLoading.running = status
        }
    }

    Connections {
        target: httpHandler
        function onMessage(type, message) {
            rfNotifyList.append({type: type, message: message})
        }
    }

    Connections {
        target: routeModel
        function onCreatedRoute(id) {
            rfStackView.push("RFRouteScreen.qml", {
                                 routeId: id,
                                 description: Strings.markdown_manual})
        }
    }
}
