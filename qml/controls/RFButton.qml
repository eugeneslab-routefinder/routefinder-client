import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    id: root

    hoverEnabled: true
    font.pixelSize: 16
    font.family: fontBold.name

    background: Rectangle {
        color: parent.hovered ? "#77B2FF" : "#0460D9"
        radius: 5
    }

    contentItem: Text {
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        text: parent.text
        font: parent.font
        color: "#ffffff"
        padding: parent.padding
    }
}
