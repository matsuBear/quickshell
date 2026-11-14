import QtQuick
import qs
import qs.components

MenuPage {
    title: "Media"
    icon: Globals.icons.music

    // TODO: now playing, controls, progress (services/Media → Mpris)
    Text {
        anchors.centerIn: parent
        text: "Media — coming soon"
        color: Globals.colors.fgMuted
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
