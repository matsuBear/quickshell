import QtQuick
import qs

// Frame shared by every sub-page: back button + icon + title header,
// then a body that takes whatever children you put inside the page.
// The page is sized by the menu's viewport.
//
//   MenuPage {
//       title: "Network"
//       icon: Globals.icons.wifi
//       Text { … }                 // goes into the body
//   }
Item {
    id: root

    property string title
    property string icon
    default property alias content: body.data

    Row {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        spacing: Globals.style.spacing * 2

        MenuButton {
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: 36
            implicitHeight: 36
            iconSize: Globals.style.fontSize
            icon: Globals.icons.back
            onClicked: Globals.ui.menuPage = "main"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            color: Globals.colors.accentWarm
            font.family: Globals.style.iconFamily
            font.pixelSize: Globals.style.fontSizeLarge
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.title
            color: Globals.colors.fg
            font.family: Globals.style.fontFamily
            font.pixelSize: Globals.style.fontSizeLarge
            font.bold: true
        }
    }

    Item {
        id: body
        anchors {
            top: header.bottom
            topMargin: Globals.style.spacing * 2
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
