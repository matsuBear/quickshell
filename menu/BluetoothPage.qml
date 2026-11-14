import QtQuick
import qs
import qs.components

MenuPage {
    title: "Bluetooth"
    icon: Globals.icons.bluetooth

    // TODO: power toggle, paired + discovered devices (services/Bluetooth)
    Text {
        anchors.centerIn: parent
        text: "Bluetooth — coming soon"
        color: Globals.colors.fgMuted
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
