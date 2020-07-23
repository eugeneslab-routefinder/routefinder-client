import QtQuick 2.12
import QtQuick.Controls 2.12

Button {

    background: Rectangle {
        color: parent.hovered ?  "#6677B2FF" : "transparent"
        radius: width / 2
    }

    icon.color: "#0460D9"
}
