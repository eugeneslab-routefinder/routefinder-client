import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

TextField {
    id: root

    font.family: fontMedium.name
    font.pixelSize: 14
    selectedTextColor: "#FFFFFF"
    selectionColor: "#0460d9"
    selectByMouse: true

    background: Rectangle {
        color: "transparent"
        radius: 5
        border.width: 1
        border.color: root.focus ? "#0460d9" : "#D2D2D2"
    }
}
