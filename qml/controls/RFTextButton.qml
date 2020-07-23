import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    hoverEnabled: true
    font.family: fontMedium.name
    font.pixelSize: 18

    background: Rectangle {
        color: transparent
    }

    contentItem: Text {
        anchors.fill: parent
        padding: parent.padding
        text: parent.text
        font: parent.font
        color: parent.hovered ? "#77B2FF" : "#0460D9"
    }
}
