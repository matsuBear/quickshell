import QtQuick
import qs
import qs.services

Row {
    id: root
    spacing: Globals.style.spacing

    readonly property int maxNameLength: 14

    readonly property string icon: {
        if (Network.type === "ethernet")
            return Globals.icons.ethernet;
        if (Network.type !== "wifi")
            return Globals.icons.wifiOff;
        const s = Network.strength;
        return s >= 75 ? Globals.icons.wifi4
             : s >= 50 ? Globals.icons.wifi3
             : s >= 25 ? Globals.icons.wifi2
             : Globals.icons.wifi1;
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.icon
        color: Network.connected ? Globals.colors.fgDim : Globals.colors.error
        font.family: Globals.style.iconFamily
        font.pixelSize: Globals.style.fontSize
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: {
            if (!Network.connected)
                return "offline";
            const n = Network.name;
            return n.length > root.maxNameLength ? n.slice(0, root.maxNameLength - 1) + "…" : n;
        }
        color: Network.connected ? Globals.colors.fg : Globals.colors.fgMuted
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
