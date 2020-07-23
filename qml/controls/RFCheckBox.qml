import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

CheckBox {
    id: root

    property color color: "#999999"
    property color backgroundColor: "transparent"

    font.family: fontMedium.name
    font.pixelSize: 14

    indicator: Rectangle {
        width: 30
        height: 30
        color: backgroundColor
        border.width: root.checkable ? 1 : 0
        border.color: "#D2D2D2"
        radius: 4

        Image {
            anchors.centerIn: parent
            width: sourceSize.width
            height: sourceSize.height
            source: root.checkable && root.checked ? "qrc:/res/icon/ic_check.svg" : ""
        }
    }

    contentItem:  Text {
        anchors.verticalCenter: root.indicator.verticalCenter
        text: parent.text
        leftPadding: root.editable ? 45 : 30
        font: root.font
        color: root.color
    }
}
