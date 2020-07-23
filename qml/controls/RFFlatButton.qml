import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Button {

    hoverEnabled: true

    background: Rectangle {
        color: "transparent"
        border.width: 0
    }

    font.family: fontMedium.name
    font.pixelSize: 16

    contentItem: Text {
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        font: parent.font
        text: parent.text
        color: hovered ? "#77B2FF" : "#0460D9"
    }
}
