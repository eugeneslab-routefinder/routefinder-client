import QtQuick 2.14
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"
import "../../res/js/strings.js" as Strings

Rectangle {
    id: root
    property alias text: rfTextArea.text
    color: "#F6F6F6"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 31

        RFMarkdownButton {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 40
            Layout.maximumWidth: 40
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            icon.source: "qrc:/res/icon/ic_help.svg"
            icon.width: 25
            icon.height: 25
            tooltip: Strings.markdown_help
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            TextArea {
                id: rfTextArea
                width: parent.implicitWidth
                font.pixelSize: 14
                font.family: fontMedium.name
                wrapMode: TextArea.WordWrap
                selectByMouse: true
                selectedTextColor: "#FFFFFF"
                textFormat: TextArea.AutoText
            }

            Shortcut {
                sequence: "Ctrl+B"
                onActivated: insertFormattedText("**")
            }

            Shortcut {
                sequence: "Ctrl+I"
                onActivated: insertFormattedText("_")
            }

            Shortcut {
                sequence: "Ctrl+K"
                onActivated: insertFormattedText("~")
            }

            Shortcut {
                sequence: "Ctrl+L"
                onActivated: insertLinkText()
            }

            Shortcut {
                sequence: "Ctrl+O"
                onActivated: insertEnumList()

            }

            Shortcut {
                sequence: "Ctrl+D"
                onActivated: insertNumberList()
            }
        }
    }

    function insertFormattedText(symb) {
        var beginSelection = rfTextArea.selectionStart
        var endSelection = rfTextArea.selectionEnd

        while(rfTextArea.text.charAt(endSelection - 1) == ' ')
            endSelection--;

        while(rfTextArea.text.charAt(beginSelection) == ' ')
            beginSelection++;


        rfTextArea.insert(beginSelection, symb);

        if(beginSelection === endSelection) {
            rfTextArea.insert(endSelection + symb.length, "Your text" + symb)
        } else
            rfTextArea.insert(endSelection + symb.length, symb)
    }

    function insertLinkText() {
        var beginSelection = rfTextArea.selectionStart
        var endSelection = rfTextArea.selectionEnd

        while(rfTextArea.text.charAt(endSelection - 1) == ' ')
            endSelection--;

        while(rfTextArea.text.charAt(beginSelection) == ' ')
            beginSelection++;

        if(beginSelection === endSelection) {
            rfTextArea.insert(beginSelection, "[Your text](https://example.com)")
        } else {
            rfTextArea.insert(beginSelection, "[");
            rfTextArea.insert(endSelection + 1, "](https://example.com)")
            rfTextArea.select(endSelection + 3, endSelection + 22)
        }
    }

    function insertNumberList() {
        rfTextArea.insert(rfTextArea.cursorPosition, "\r\n1. one\r\n1. two")
    }

    function insertEnumList() {
        rfTextArea.insert(rfTextArea.cursorPosition, "\r\n- one\r\n- two")
    }
}
