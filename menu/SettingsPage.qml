import QtQuick
import qs
import qs.components

MenuPage {
    title: "System"
    icon: Globals.icons.settings

    // TODO: volume + brightness sliders (services/Audio, services/Brightness)
    Text {
        anchors.centerIn: parent
        text: "System — coming soon"
        color: Globals.colors.fgMuted
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
