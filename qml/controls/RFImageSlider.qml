import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Item {
    id: root
    property var pictures: []

    signal selectedImage(var pictureIndex, var picture)

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Item {
            width: root.width
            height: root.height

            Rectangle {
                anchors.centerIn: parent
                width: root.width
                height: root.height
                radius: 10
            }
        }
    }

    SwipeView {
        id: rfSwipeView
        anchors.fill: parent
        interactive: true
        clip: true

        Repeater {
            model: root.pictures

            delegate:  Image {
                source: modelData
                sourceSize.height: height
                sourceClipRect: Qt.rect(sourceSize.width / 2, 0, width, height)

                AnimatedImage {
                    anchors.centerIn: parent
                    source: "qrc:/res/icon/loading.gif"
                    visible: parent.status == Image.Loading
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton

                    onClicked:  {
                        if(!rfNoPicture.visible)
                            root.selectedImage(index, parent.source)
                    }
                }
            }
        }
    }

    PageIndicator {
       anchors.bottom: rfSwipeView.bottom
       anchors.bottomMargin: 37
       anchors.horizontalCenter: rfSwipeView.horizontalCenter
       currentIndex: rfSwipeView.currentIndex
       count: rfSwipeView.count
       interactive: true
       spacing: 10
       visible: root.pictures.length > 1

       delegate: Rectangle {
           anchors.verticalCenter: parent.verticalCenter
           width: index === rfSwipeView.currentIndex ? 19 : 15
           height: width
           color: index === rfSwipeView.currentIndex ? "#0460D9" : "#FFFFFF"
           radius: width / 2

           Behavior on color {
               ColorAnimation { duration: 140 }
           }
       }

    }

    Item {
        id: rfNoPicture
        anchors.fill: parent
        visible: !root.pictures.length

        ColumnLayout
        {
            anchors.centerIn: parent

            Image {
                Layout.alignment: Qt.AlignCenter
                source: "qrc:/res/icon/ic_no_picture.svg"
            }

            Text {
                Layout.alignment: Qt.AlignCenter
                text: qsTr("No image")
                color: "#999999"
                font.family: fontBold.name
                font.pixelSize: 18
            }
        }
    }

    Button {
        anchors.verticalCenter: parent.verticalCenter
        width: hovered ? 54 : 51
        height: width
        anchors.left: parent.left
        anchors.leftMargin: - width / 2
        visible: root.pictures.length > 1

        background: Rectangle {
            radius: width / 2
        }

        icon.source: "qrc:/res/icon/ic_left.svg"
        icon.color: "#0460D9"
        icon.width: hovered ? 10 : 8
        icon.height: hovered ? 17 : 15
        rightPadding: 0
        hoverEnabled: true

        onClicked: {
            rfSwipeView.decrementCurrentIndex()
        }

        Behavior on width {
            NumberAnimation { duration: 100 }
        }

        Behavior on icon.width {
            NumberAnimation { duration: 100 }
        }
    }


    Button {
        anchors.verticalCenter: parent.verticalCenter
        width: hovered ? 54 : 51
        height: width
        anchors.right: parent.right
        anchors.rightMargin: - width / 2
        visible: root.pictures.length > 1
        hoverEnabled: true

        background: Rectangle {
            radius: width / 2
        }

        icon.source: "qrc:/res/icon/ic_right.svg"
        icon.color: "#0460D9"
        icon.width: hovered ? 10 : 8
        icon.height: hovered ? 17 : 15
        leftPadding: 0

        onClicked: rfSwipeView.incrementCurrentIndex()

        Behavior on width {
            NumberAnimation { duration: 100 }
        }

        Behavior on icon.width {
            NumberAnimation { duration: 100 }
        }
    }
}
