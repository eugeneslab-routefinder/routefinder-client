import QtQuick 2.14
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "./components"
import "./controls"
import net.eugeneslab.routefinder 1.0

Rectangle {
    id: root
    property int routeId: 0
    property string link
    property bool cover: false

    anchors.fill: parent
    color: "#80000000"
    focus: visible

    MouseArea {
        anchors.fill: root
        hoverEnabled: true
        onWheel: {}
        onClicked: parent.visible = false
    }


    Flickable {
        id: rfPicture
        anchors.fill: root
        anchors.margins: 117
        contentWidth: rfImage.width > width ? rfImage.width : width
        contentHeight: rfImage.height > height ? rfImage.height : height
        clip: true

        Image {
            id: rfImage
            property int scaleWidth: 0
            property int scaleHeight: 0

            anchors.centerIn: parent
            source: root.link

            onStatusChanged: {
                if(status == Image.Ready) {
                    height = sourceSize.height
                    width = sourceSize.width

                    scaleWidth = width / 2
                    scaleHeight = height / 2
                }
            }

            MouseArea {
                anchors.fill: parent
                onWheel: {
                    if (wheel.modifiers & Qt.ControlModifier) {
                        if (wheel.angleDelta.y > 0) {
                            rfImage.width += rfImage.scaleWidth;
                            rfImage.height += rfImage.scaleHeight;
                        }
                        else if (rfImage.width - rfImage.scaleWidth >= rfImage.sourceSize.width) {
                            rfImage.width -= rfImage.scaleWidth;
                            rfImage.height -= rfImage.scaleHeight;
                        }

                    }
                }
            }

        }
    }

    AnimatedImage {
        anchors.centerIn: rfPicture
        source: "qrc:/res/icon/loading.gif"
        visible: rfImage.status == Image.Loading
    }

    RFCheckBox {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rfPicture.bottom
        anchors.topMargin: 25
        text: qsTr("Make this picture as a cover")
        checked: cover
        color: "#FFFFFF"
        backgroundColor: "#999999"
        visible: userHandler.authorizated

        onClicked: {
            if(checked)
                httpHandler.writeUpdateCover(RFControllers.RouteList, routeId, link)
            else
                httpHandler.writeUpdateCover(RFControllers.RouteList, routeId, "")
        }
    }

    RFButtonClose {
        onClicked: parent.visible = false
    }
}
