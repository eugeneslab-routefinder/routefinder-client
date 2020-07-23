import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12


ComboBox {
    id: root
    property string placeholderText: qsTr("Type here...")
    property alias border: backgroundRect.border
    property alias radius: backgroundRect.radius

    signal foundCity(var id, var city)
    function search () {
        accepted()
    }

    Layout.fillHeight: true
    Layout.fillWidth: true
    editable: true
    indicator: Item {}
    font.family: fontMedium.name
    font.pixelSize: 14
    model: locationModel
    textRole: "locationDisplayRole"

    background: Rectangle { color: "transparent" }

    contentItem: TextField {
        id: searchField
        text: parent.displayText
        leftPadding: 15
        rightPadding: 50
        font: parent.font
        selectedTextColor: "#FFFFFF"
        selectionColor: "#0460d9"
        selectByMouse: true
        placeholderText: root.placeholderText
        inputMethodHints: Qt.ImhNoPredictiveText

        background: Rectangle {
            id: backgroundRect
            color: "#FFFFFF"
            radius: 5
            border.width: 2
            border.color: parent.focus ? "#0460d9" : "#D2D2D2"
        }

        onAccepted: {
            deselect()
            cursorPosition = text.length
            focus = false
        }
    }

    onAccepted: {
        root.foundCity(locationModel.locationByName(displayText), displayText);
    }
}
