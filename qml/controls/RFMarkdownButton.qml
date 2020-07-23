import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: root

    property string tooltip

    hoverEnabled: true

    background: Rectangle {
        color: parent.hovered ? "#0460D9" : "#E9E9E9"
        radius: 5
    }

    icon.color: hovered ?  "#FFFFFF" : "#000000"

    RFToolTip {
        text: root.tooltip
        visible: parent.hovered
    }
}
