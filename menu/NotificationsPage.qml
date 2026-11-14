import QtQuick
import qs
import qs.components

MenuPage {
    title: "Notifications"
    icon: Globals.icons.bell

    // TODO: notification history list + clear / DND (services/Notifs)
    Text {
        anchors.centerIn: parent
        text: "Notifications — coming soon"
        color: Globals.colors.fgMuted
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
