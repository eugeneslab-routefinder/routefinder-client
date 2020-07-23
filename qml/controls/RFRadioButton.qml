import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RadioButton {
    id: root

    indicator: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: width / 2
        border.color: root.checked ? "#0460D9" : "#D2D2D2"

        Rectangle {
            width: 14
            height: 14
            anchors.centerIn: parent
            radius: 7
            color: "#0460D9"
            visible: root.checked
        }
    }

    contentItem: Text {
        anchors.verticalCenter: root.indicator.verticalCenter
        text: root.text
        font.family: fontMedium.name
        font.pixelSize: rfMainWindow.isPhoneResolution ? 14 : 16
        color: "#000000"
        verticalAlignment: Text.AlignVCenter
        leftPadding: root.indicator.width + 15
    }
}
