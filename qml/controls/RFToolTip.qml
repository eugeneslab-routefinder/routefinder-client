import QtQuick 2.12
import QtQuick.Controls 2.12

ToolTip {
    id: root

    contentItem: Text {
        padding: 14
        font.pixelSize: 13
        font.family: fontMedium.name
        color: "#FFFFFF"
        text: root.text
    }

    background: Rectangle {
        anchors.fill: parent
        radius: 9
        color: "#31AB1F"

        Rectangle {
            anchors.verticalCenter: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 22
            height: 22
            color: parent.color
            rotation: 45
        }
    }

    delay: 560
}
