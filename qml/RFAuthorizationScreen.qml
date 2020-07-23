import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import net.eugeneslab.routefinder 1.0
import "./components"
import "./controls"

Item {

    Image {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/res/icon/main_image.png"
    }

    ColumnLayout {
        anchors.verticalCenter: parent.verticalCenter
        width: 491
        spacing: 30

        Text {
            text: qsTr("Login")
            font.family: fontBold.name
            font.pixelSize: 40
            color: "#000000"
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10

            RFTextField {
                id: rfEmailField
                Layout.fillWidth: true
                placeholderText: "E-mail"
                inputMethodHints: Qt.ImhEmailCharactersOnly
            }

            RFTextField {
                id: rfPasswordField
                Layout.fillWidth: true
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
            }
        }

        RFButton {
            id: rfLoginButton
            text: qsTr("Login")

            onClicked: {
                userHandler.authorization(rfEmailField.text, rfPasswordField.text)
                if(userHandler.authorizated) rfBackToSearchButton.clicked()
                else rfNotifyList.append({type: RFNotification.Error, message: qsTr("Uncorrect e-mail or password")})
            }
        }
    }

    Keys.onEnterPressed: {
        rfLoginButton.clicked()
    }

    Keys.onReturnPressed: {
        rfLoginButton.clicked()
    }
}
