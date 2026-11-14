import QtQuick
import qs
import qs.components

MenuPage {
    title: "Network"
    icon: Globals.icons.wifi

    // TODO: wifi toggle, network list, connect (services/Network)
    Text {
        anchors.centerIn: parent
        text: "Network — coming soon"
        color: Globals.colors.fgMuted
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
