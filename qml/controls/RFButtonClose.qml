import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: -width / 2
    anchors.topMargin: -height / 2
    width: 78
    height: 78

    background: Rectangle {
        rotation: 45
        color: "#FF5F53"
    }

    icon.source: "qrc:/res/icon/ic_close.svg"
    icon.color: "#FFFFFF"
    icon.width: 12
    icon.height: 12
    leftPadding: -width / 3
    bottomPadding: -height / 3
}
