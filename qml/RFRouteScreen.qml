import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "./components"
import "./controls"
import net.eugeneslab.routefinder 1.0

Item {
    id: root

    property int routeId: 0
    property string picture
    property alias distance: rfDistanceField.text
//    property string distance
    property string title
//    property alias description: rfMarkdownEditor.text
    property string description
    property bool hasForest: false
    property bool hasCastles: false
    property bool hasMuseums: false
    property bool hasMonuments: false
    property bool hasAccommodation: false
    property bool hasRestourant: false
    property var locations: []
    property var album: []
    property alias link: rfMapLink.text
    property bool editable: userHandler.authorizated

    onDescriptionChanged: {
        const regex = /\[([A-Z]{2})\]/m;
        var source = description.split(regex);

        var descript = []
        var languages  = []

        for(var i = 1; i < source.length; i += 2) {
            languages.push(source[i])
            descript.push(source[i+1])
        }

        rfLanguages.model = languages
        rfScrollDescription.descriptionList = descript
    }

    function toTop() {
        rfFlickable.contentY = 0
    }

    Flickable {
        id: rfFlickable
        anchors.fill: parent
        contentWidth: rfContent.width
        contentHeight: rfContent.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Item {
            id: rfContent
            width: rfFlickable.width
            height: childrenRect.height

            ColumnLayout {
                width: rfFlickable.width
                spacing: 24

    //            Header
                RowLayout {
                    Layout.fillWidth: true

                    RFIconFlatButton {
                        id: rfButtonBack
                        Layout.preferredHeight: width
                        Layout.preferredWidth: rfMainWindow.isPhoneResolution ? 32 : 48
                        icon.source: "qrc:/res/icon/ic_back.svg"
                        icon.width: rfMainWindow.isPhoneResolution ? 6 : 12
                        icon.height: rfMainWindow.isPhoneResolution ? 11 : 21

                        onClicked: {
                            if(!rfCities.locations.length) rfNotifyList.append({type: RFNotification.Error, message: qsTr("You should have to add at least one city")})
                            else if(!rfTitleField.text.length) rfNotifyList.append({type: RFNotification.Error, message: qsTr("You didn't fill title")})
                            else rfStackView.pop()
                        }
                    }

                    TextField {
                        id: rfTitleField
                        property string oldTitle
                        property bool acceptResult: false

                        Layout.fillWidth: true
                        text: root.title
                        color: "#0460D9"
                        font.family: fontBold.name
                        font.pixelSize: rfMainWindow.isPhoneResolution ? 22 : rfMainWindow.width / 48
                        enabled: root.editable
                        maximumLength: 58
                        placeholderTextColor: "#D2D2D2"
                        placeholderText: qsTr("Type a title of the route here...")
                        wrapMode: rfMainWindow.isPhoneResolution ? TextField.WordWrap : TextField.NoWrap

                        background: Rectangle {
                            color: "transparent"
                            border.width: parent.enabled ? 1 : 0
                            border.color: parent.focus ? "#0460D9" : "#D2D2D2"
                            radius: 5
                        }

                        RFToolTip {
                            text: qsTr("Maximum length: %1\r\nPush \"Enter\" key to accept the result").arg(parent.maximumLength)
                            visible: parent.focus
                        }

                        onAccepted: {
                            acceptResult = true
                            focus = false
                        }

                        onFocusChanged: {
                            if(focus) oldTitle = text
                            else {
                                if(!acceptResult)
                                    text = oldTitle
                                else
                                    httpHandler.writeUpdateTitle(root.routeId, text)
                            }

                            acceptResult = false
                        }
                    }
                }

                //  Main Content
                GridLayout {
                    Layout.fillWidth: true
                    flow: rfMainWindow.isPhoneResolution ? GridLayout.TopToBottom : GridLayout.LeftToRight
                    columnSpacing: 20
                    rowSpacing: 20

                    ColumnLayout {
                        id: rfAlbumLayout
                        Layout.fillWidth: true
                        spacing: 10

                        RFImageSlider {
                            id: rfAlbumItem
                            Layout.preferredWidth: rfMainWindow.isPhoneResolution ? root.width : root.width / 3
                            Layout.preferredHeight: Layout.preferredWidth
                            pictures: root.album
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.maximumWidth: parent.width
                            spacing: 20

                            TextField {
                                id: rfMapLink
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: root.editable
                                font.family: fontMedium.name
                                font.pixelSize: 14
                                color: "#000000"
                                selectByMouse: true
                                selectedTextColor: "#FFFFFF"
                                placeholderTextColor: "#999999"
                                placeholderText: qsTr("Past a link to https://mapy.cz here...")

                                background: Rectangle {
                                    color: "transparent"
                                    border.width: 1
                                    border.color: parent.focus ? "#0460D9" : "#999999"
                                    radius: 5
                                }
                            }

                            RFButton {
                                id: rfMapButton
                                Layout.fillWidth: true
                                text: root.editable ? qsTr("Apply") : qsTr("Show on a map");
                                onClicked: {
                                    if(!root.editable)
                                        Qt.openUrlExternally(root.link)
                                    else
                                        httpHandler.writeUpdateLink(root.routeId, rfMapLink.text);
                                }
                            }
                        }

                        RFCitiesBlock {
                            id: rfCities
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: contentHeight
                            Layout.alignment: Qt.AlignTop
                            locations: root.locations
                            editable: root.editable

                            onAppendCity: {
                                httpHandler.writeInsertCity(root.routeId, indexCity)
                            }

                            onRemoveCity: {
                                httpHandler.writeRemoveCity(root.routeId, indexCity)
                            }
                        }

                        RFObjectsBlock {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: contentHeight
                            hasCastle: root.hasCastles
                            hasForest: root.hasForest
                            hasMonument: root.hasMonuments
                            hasMuseum: root.hasMuseums
                            hasAccommodation: root.hasAccommodation
                            hasRestourant: root.hasRestourant
                            editable: root.editable

                            onStateChanged: {
                                if(root.hasForest != hasForest) {
                                    httpHandler.writeUpdateForest(routeId, hasForest);
                                    root.hasForest = hasForest
                                }
                                else if (root.hasCastles != hasCastle) {
                                    httpHandler.writeUpdateCastle(routeId, hasCastle);
                                    root.hasCastles = hasCastle
                                }
                                else if(root.hasMuseums != hasMuseum) {
                                    httpHandler.writeUpdateMuseum(routeId, hasMuseum);
                                    root.hasMuseums = hasMuseum
                                }
                                else if(root.hasMonuments != hasMonument) {
                                    httpHandler.writeUpdateMonument(routeId, hasMonument);
                                    root.hasMonuments = hasMonument
                                }
                                else if(root.hasAccommodation != hasAccommodation) {
                                    httpHandler.writeUpdateAccommodation(root.routeId, hasAccommodation)
                                    root.hasAccommodation = hasAccommodation
                                }
                                else if(root.hasRestourant != hasRestourant) {
                                    httpHandler.writeUpdateRestourant(root.routeId, hasRestourant)
                                    root.hasRestourant = hasRestourant
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        id: rfDescriptionLayout
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 15
                        Layout.maximumHeight: rfMainWindow.isPhoneResolution ? 999999 : rfAlbumLayout.implicitHeight

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15

                            Repeater {
                                id: rfLanguages

                                delegate: RadioButton  {
                                    id: rfLanguageButton
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.preferredWidth: 48
                                    Layout.preferredHeight: 48
                                    checkable: true

                                    checked: index == 0

                                    indicator: Rectangle {
                                        width: parent.width
                                        height: parent.height
                                        radius: parent.width / 2
                                        color: parent.checked ? "#31AB1F" : "#F6F6F6"
                                    }


                                    contentItem: Text {
                                        anchors.fill: parent
                                        verticalAlignment: Qt.AlignVCenter
                                        horizontalAlignment: Qt.AlignHCenter
                                        color: parent.checked ? "#FFFFFF" : "#999999"
                                        font.family: fontBold.name
                                        font.pixelSize: 16
                                        text: modelData
                                    }

                                    onCheckedChanged: {
                                        if(checked)
                                            rfDescriptionLabel.currentIndex = index;
                                    }
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Text {
                                font.pixelSize: 16
                                font.family: fontBold.name
                                color: "#999999"
                                text: qsTr("Distance:")
                                visible: !rfMainWindow.isPhoneResolution
//                                visible: !rfMarkdownEditor.visible
                            }

                            TextField {
                                id: rfDistanceField

                                property string oldTitle
                                property bool acceptResult: false

                                Layout.preferredWidth: enabled ? 80 : 50
                                font.pixelSize: 16
                                font.family: fontMedium.name
                                color: "#000000"
                                enabled: root.editable
                                horizontalAlignment: Qt.AlignHCenter
                                validator: DoubleValidator {
                                    bottom: 1.0;
                                    top: 100.0;
                                    decimals: 1;
                                    locale: "en_US"
                                    notation: DoubleValidator.StandardNotation
                                }
                                selectByMouse: true
                                selectedTextColor: "#FFFFFF"

                                background: Rectangle {
                                    color: "transparent"
                                    border.width: parent.enabled ? 1 : 0
                                    border.color: parent.focus ? "#0460d9" : "#D2D2D2"
                                    radius: 5
                                }

                                RFToolTip {
                                    text: qsTr("Push \"Enter\" key to accept the result")
                                    visible: parent.focus
                                }

                                onAccepted: {
                                    acceptResult = true
                                    focus = false
                                }

                                onFocusChanged: {
                                    if(focus) {
                                        oldTitle = text
                                        selectAll()
                                    }
                                    else {
                                        if(!acceptResult)
                                            text = oldTitle
                                        else
                                            httpHandler.writeUpdateDistance(root.routeId, parseFloat(text))
                                    }

                                    acceptResult = false
                                }

//                                visible: !rfMarkdownEditor.visible
                            }

                            Text {
                                font.pixelSize: 16
                                font.family: fontMedium.name
                                color: "#999999"
                                text: "km"
//                                visible: !rfMarkdownEditor.visible
                            }
                        }

                        ScrollView {
                            id: rfScrollDescription
                            property var descriptionList: []
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.policy: ScrollBar.AsNeeded
                            contentWidth: rfDescriptionLabel.width
                            clip: true

                            Label {
                                id: rfDescriptionLabel
                                property int currentIndex: 0
                                width: rfScrollDescription.width - 20
                                text: rfScrollDescription.descriptionList.length ? rfScrollDescription.descriptionList[currentIndex] : ""

                                color: "#000000"
                                font.family: fontMedium.name
                                font.pixelSize: 18
                                textFormat: Label.MarkdownText
                                wrapMode: Label.WordWrap

                                onLinkActivated: {
                                    Qt.openUrlExternally(link)
                                }
                            }
                        }
                    }



                }
            }




        }

//        ColumnLayout {
//            id: rfContent
//            width: parent.width
//            spacing: 24

//            //  Header
//            RowLayout {
//                Layout.fillWidth: true

//                Button {
//                    Layout.preferredHeight: 48
//                    Layout.preferredWidth: 48
//                    icon.source: "qrc:/res/icon/ic_back.svg"
//                    icon.color: "#0460D9"
//                    icon.width: 12
//                    icon.height: 21
//                    hoverEnabled: true

//                    background: Rectangle {
//                        color: parent.hovered ? "#6677B2FF" : "transparent"
//                        radius: parent.width / 2
//                    }

//                    onClicked: {
//                        if(!rfCities.locations.length) rfNotifyList.append({type: RFNotification.Error, message: qsTr("You should have to add at least one city")})
//                        else if(!rfTitleField.text.length) rfNotifyList.append({type: RFNotification.Error, message: qsTr("You didn't fill title")})
//                        else rfStackView.pop()
//                    }
//                }

//                TextField {
//                    id: rfTitleField
//    //                Layout.fillWidth: true
//                    property string oldTitle
//                    property bool acceptResult: false

//                    Layout.minimumWidth: contentWidth
//                    text: root.title
//                    color: "#0460D9"
//                    font.family: fontBold.name
//                    font.pixelSize: rfMainWindow.width < 1500 ? 28 : 36
//                    enabled: root.editable
//                    maximumLength: 58
//                    placeholderTextColor: "#D2D2D2"
//                    placeholderText: qsTr("Type a title of the route here...")

//                    background: Rectangle {
//                        color: "transparent"
//                        border.width: parent.enabled ? 1 : 0
//                        border.color: parent.focus ? "#0460D9" : "#D2D2D2"
//                        radius: 5
//                    }

//                    RFToolTip {
//                        text: qsTr("Maximum length: %1\r\nPush \"Enter\" key to accept the result").arg(parent.maximumLength)
//                        visible: parent.focus
//                    }

//                    onAccepted: {
//                        acceptResult = true
//                        focus = false
//                    }

//                    onFocusChanged: {
//                        if(focus) oldTitle = text
//                        else {
//                            if(!acceptResult)
//                                text = oldTitle
//                            else
//                                httpHandler.writeUpdateTitle(root.routeId, text)
//                        }

//                        acceptResult = false
//                    }
//                }
//            }


//            //  Main content
//            GridLayout {
//                Layout.fillWidth: true
//                Layout.alignment: Qt.AlignTop
//                flow: rfMainWindow.isPhoneResolution ? GridLayout.TopToBottom : GridLayout.LeftToRight
////                layoutDirection: rfMainWindow.isPhoneResolution ? Qt.RightToLeft : Qt.LeftToRight
////                Layout.maximumHeight: rfMainWindow.isPhoneResolution ? 99999 : 516
////                spacing: 20

//                ColumnLayout {
//                    Layout.fillHeight: true
//                    Layout.fillWidth: true
//                    spacing: 24

//                    RowLayout {
//                        Layout.fillWidth: true
//                        spacing: 16

//                        RFButton {
//                            Layout.alignment: Qt.AlignLeft
//                            Layout.preferredWidth: 82
//                            text: rfMarkdownEditor.opacity ? qsTr("Apply") : qsTr("Edit")
//                            visible: root.editable
//                            onClicked: {
//                                if(rfMarkdownEditor.opacity) httpHandler.writeUpdateDescription(root.routeId, root.description)
//                                rfMarkdownEditor.opacity = !rfMarkdownEditor.opacity
//                            }
//                        }

//                        Repeater {
//                            id: rfLanguages

//                            delegate: RadioButton  {
//                                id: rfLanguageButton
//                                Layout.alignment: Qt.AlignLeft
//                                Layout.preferredWidth: 48
//                                Layout.preferredHeight: 48
//                                checkable: true

//                                checked: index == 0

//                                indicator: Rectangle {
//                                    width: parent.width
//                                    height: parent.height
//                                    radius: parent.width / 2
//                                    color: parent.checked ? "#31AB1F" : "#F6F6F6"
//                                }


//                                contentItem: Text {
//                                    anchors.fill: parent
//                                    verticalAlignment: Qt.AlignVCenter
//                                    horizontalAlignment: Qt.AlignHCenter
//                                    color: parent.checked ? "#FFFFFF" : "#999999"
//                                    font.family: fontBold.name
//                                    font.pixelSize: 16
//                                    text: modelData
//                                }

//                                onCheckedChanged: {
//                                    if(checked)
//                                        rfDescriptionLabel.currentIndex = index;
//                                }
//                            }
//                        }

//                        Item {
//                            Layout.fillWidth: true
//                        }

//                        Text {
//                            font.pixelSize: 16
//                            font.family: fontBold.name
//                            color: "#999999"
//                            text: qsTr("Distance:")
//                            visible: !rfMarkdownEditor.visible
//                        }

//                        TextField {
//                            id: rfDistanceField

//                            property string oldTitle
//                            property bool acceptResult: false

//                            Layout.preferredWidth: enabled ? 80 : 50
//                            font.pixelSize: 16
//                            font.family: fontMedium.name
//                            color: "#000000"
//                            enabled: root.editable
//                            horizontalAlignment: Qt.AlignHCenter
//                            validator: DoubleValidator {
//                                bottom: 1.0;
//                                top: 100.0;
//                                decimals: 1;
//                                locale: "en_US"
//                                notation: DoubleValidator.StandardNotation
//                            }
//                            selectByMouse: true
//                            selectedTextColor: "#FFFFFF"

//                            background: Rectangle {
//                                color: "transparent"
//                                border.width: parent.enabled ? 1 : 0
//                                border.color: parent.focus ? "#0460d9" : "#D2D2D2"
//                                radius: 5
//                            }

//                            RFToolTip {
//                                text: qsTr("Push \"Enter\" key to accept the result")
//                                visible: parent.focus
//                            }

//                            onAccepted: {
//                                acceptResult = true
//                                focus = false
//                            }

//                            onFocusChanged: {
//                                if(focus) {
//                                    oldTitle = text
//                                    selectAll()
//                                }
//                                else {
//                                    if(!acceptResult)
//                                        text = oldTitle
//                                    else
//                                        httpHandler.writeUpdateDistance(root.routeId, parseFloat(text))
//                                }

//                                acceptResult = false
//                            }

//                            visible: !rfMarkdownEditor.visible
//                        }

//                        Text {
//                            font.pixelSize: 16
//                            font.family: fontMedium.name
//                            color: "#999999"
//                            text: "km"
//                            visible: !rfMarkdownEditor.visible
//                        }
//                    }

//                    ScrollView {
//                        id: rfScrollDescription
//                        property var descriptionList: []
//                        Layout.preferredHeight: rfMainWindow.isPhoneResolution ? rfDescriptionLabel.height : rfAlbumItem.height
//                        Layout.fillWidth: true
//                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
//                        ScrollBar.vertical.policy: ScrollBar.AsNeeded
//                        clip: true

//                        Label {
//                            id: rfDescriptionLabel
//                            property int currentIndex: 0

//                            anchors.top: parent.top
//                            anchors.left: parent.left
//                            width: rfScrollDescription.width - 20
//                            text: rfScrollDescription.descriptionList[currentIndex]

//                            color: "#000000"
//                            font.family: fontMedium.name
//                            font.pixelSize: 18
//                            textFormat: Label.MarkdownText
//                            wrapMode: Label.WordWrap

//                            onLinkActivated: {
//                                Qt.openUrlExternally(link)
//                            }
//                        }
//                    }
//                }

//                RFImageSlider {
//                    id: rfAlbumItem
//                    Layout.alignment: Qt.AlignTop
//                    Layout.preferredHeight: width
//                    Layout.preferredWidth: rfMainWindow.isPhoneResolution ? root.width : root.width / 3
//                    pictures: root.album

////                    RFButtonClose {
////                        visible: userHandler.authorizated && root.album.length
////                        onClicked: {
////                            rfRemovePictureDialog.open()
////    //
////                        }
////                    }

////                    RFButtonAdd {
////                        visible: userHandler.authorizated
////                        onClicked: rfFileDialog.visible = true
////                    }

//                    RFMarkdownEditor {
//                        id: rfMarkdownEditor
//                        anchors.fill: parent
//                        opacity: 0
//                        visible: opacity

//                        Behavior on opacity {
//                            NumberAnimation { duration: 150 }
//                        }
//                    }

////                    MessageDialog {
////                        id: rfRemovePictureDialog

////                        title: qsTr("Remove the picture")
////                        text: qsTr("Warning!")
////                        informativeText: qsTr("Are you sure that you would like to delete this picture?")
////                        standardButtons: MessageDialog.Yes | MessageDialog.No
////                        onYes: {
////                            httpHandler.writeRemovePicture(RFControllers.RouteList, root.routeId, root.album[rfSwipeView.currentIndex])
////                        }
////                    }

////                    FileDialog {
////                        id: rfFileDialog
////                        title: qsTr("Please choose pictures")
////                        selectExisting: true
////                        selectFolder: false
////                        selectMultiple: true
////                        nameFilters: ["Images(*.png *.jpg)"]
////                        onAccepted: {
////                            for(var i = 0; i < fileUrls.length; i++) {
////                                httpHandler.writeInsertPicture(RFControllers.RouteList, root.routeId, fileUrls[i])
////                            }
////                        }
////                    }
//                }
//            }


////            Item {
////                Layout.alignment: Qt.AlignRight
////                Layout.fillWidth: true
////                Layout.maximumWidth: rfAlbumItem.width
////                Layout.minimumWidth: rfAlbumItem.width
////                Layout.maximumHeight: 40
////                Layout.minimumHeight: 40
////                visible: !rfMarkdownEditor.visible

////                RowLayout {
////                    anchors.fill: parent
////                    spacing: 20

////                    TextField {
////                        id: rfMapLink
////                        Layout.fillHeight: true
////                        Layout.fillWidth: true
////                        visible: root.editable
////                        font.family: fontMedium.name
////                        font.pixelSize: 14
////                        color: "#000000"
////                        selectByMouse: true
////                        selectedTextColor: "#FFFFFF"
////                        placeholderTextColor: "#999999"
////                        placeholderText: qsTr("Past a link to https://mapy.cz here...")

////                        background: Rectangle {
////                            color: "transparent"
////                            border.width: 1
////                            border.color: parent.focus ? "#0460D9" : "#999999"
////                            radius: 5
////                        }
////                    }

////                    RFButton {
////                        Layout.fillHeight: true
////                        Layout.fillWidth: true
////                        text: root.editable ? qsTr("Apply") : qsTr("Show on a map");
////                        onClicked: {
////                            if(!root.editable)
////                                Qt.openUrlExternally(root.link)
////                            else
////                                httpHandler.writeUpdateLink(root.routeId, rfMapLink.text);
////                        }
////                    }
////                }
////            }


////            RowLayout {
////                Layout.fillWidth: true
////                Layout.fillHeight: true
////                Layout.minimumHeight: 181
////                spacing: 90
////                visible: !rfMarkdownEditor.visible

////                RFCitiesBlock {
////                    Layout.fillWidth: true
////                    Layout.fillHeight: true
////                    Layout.preferredWidth: 218
////                    Layout.maximumWidth: 218
////                    id: rfCities
////                    Layout.alignment: Qt.AlignTop
////                    locations: root.locations
////                    editable: root.editable

////                    onAppendCity: {
////                        httpHandler.writeInsertCity(root.routeId, indexCity)
////                    }

////                    onRemoveCity: {
////                        httpHandler.writeRemoveCity(root.routeId, indexCity)
////                    }
////                }

////                RFObjectsBlock {
////                    Layout.fillWidth: true
////                    Layout.fillHeight: true
////                    Layout.preferredWidth: 275
////                    Layout.alignment: Qt.AlignTop
////                    hasCastle: root.hasCastles
////                    hasForest: root.hasForest
////                    hasMonument: root.hasMonuments
////                    hasMuseum: root.hasMuseums
////                    hasAccommodation: root.hasAccommodation
////                    hasRestourant: root.hasRestourant
////                    editable: root.editable


////                    onStateChanged: {
////                        if(root.hasForest != hasForest) {
////                            httpHandler.writeUpdateForest(routeId, hasForest);
////                            root.hasForest = hasForest
////                        }
////                        else if (root.hasCastles != hasCastle) {
////                            httpHandler.writeUpdateCastle(routeId, hasCastle);
////                            root.hasCastles = hasCastle
////                        }
////                        else if(root.hasMuseums != hasMuseum) {
////                            httpHandler.writeUpdateMuseum(routeId, hasMuseum);
////                            root.hasMuseums = hasMuseum
////                        }
////                        else if(root.hasMonuments != hasMonument) {
////                            httpHandler.writeUpdateMonument(routeId, hasMonument);
////                            root.hasMonuments = hasMonument
////                        }
////                        else if(root.hasAccommodation != hasAccommodation) {
////                            httpHandler.writeUpdateAccommodation(root.routeId, hasAccommodation)
////                            root.hasAccommodation = hasAccommodation
////                        }
////                        else if(root.hasRestourant != hasRestourant) {
////                            httpHandler.writeUpdateRestourant(root.routeId, hasRestourant)
////                            root.hasRestourant = hasRestourant
////                        }
////                    }
////                }
////            }
//        }
    }


//    Component.onCompleted: {
//        rfLoading.running = false
//    }

    Connections {
        target: routeModel

        function onAlbum(album) {
            root.album = album
        }
    }
}
