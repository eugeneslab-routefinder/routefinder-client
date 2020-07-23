import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: -width / 2
    anchors.bottomMargin: -height / 2
    width: 78
    height: 78

    background: Rectangle {
        rotation: 45
        color: "#31AB1F"
    }

    icon.source: "qrc:/res/icon/ic_add.svg"
    icon.color: "#FFFFFF"
    icon.width: 12
    icon.height: 12
    leftPadding: -width / 3
    topPadding: -height / 3
}
