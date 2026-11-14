import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.components
import qs.windows.bar

// Top-right corner fan. The window covers the fan's bounding box; only the
// module row takes clicks, the blades are decoration.
PanelWindow {
    id: root

    anchors {
        top: true
        right: true
    }

    readonly property real sw: root.screen?.width ?? 1920
    readonly property real sh: root.screen?.height ?? 1080

    implicitWidth: Math.round(sw * Globals.style.barReach) + Globals.style.fanMargin
    implicitHeight: Math.round(sh * Globals.style.barEnds[1]) + Globals.style.fanMargin
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region { item: hitbox}
    Item {
        id: hitbox
        x: viewport.x
        y: viewport.y
        width: Globals.ui.menuOpen ? viewport.width : 0
        height: viewport.height
    }

    Fan {
        anchors.fill: parent
        shown: Globals.ui.barOpen

        cornerTop: true
        cornerLeft: false
        uVertical: true

        zU: root.sh * Globals.style.barDrop
        aU: 0
        aV: root.sw * Globals.style.barReach
        bow: root.sw * Globals.style.barBow
        ends: Globals.style.barEnds.map(e => e * root.sh)
        branches: Globals.style.barBranches
        peel: Globals.style.fanPeel

        Column {
            id: content
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: Globals.style.padding * 2
            spacing: Globals.style.spacing

            Clock      { anchors.right: parent.right }
            Workspaces { anchors.right: parent.right }
            NetStatus { anchors.right: parent.right }
            Battery   { anchors.right: parent.right }
        }
    }
}
