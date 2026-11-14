import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.components
import qs.menu

// Bottom-left corner fan. The front blade spans the full screen height;
// pages sit in its lower part, where it is widest.
PanelWindow {
    id: root

    anchors {
        left: true
        top: true
        bottom: true
    }

    readonly property real sw: root.screen?.width ?? 1920
    readonly property real sh: root.height

    implicitWidth: Math.round(sw * Globals.style.menuEnds[1]) + Globals.style.fanMargin
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-menu"
    // Exclusive while open so Esc works immediately; nothing when closed
    WlrLayershell.keyboardFocus: Globals.ui.menuOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    mask: Region { item: hitbox}
    Item {
        id: hitbox
        x: viewport.x
        y: viewport.y
        width: Globals.ui.menuOpen ? viewport.width : 0
        height: viewport.height
    }


    readonly property int pad: Globals.style.menuPadding

    // ── Page registry: id → component ────────────────────────
    readonly property var pages: ({
        main:          mainPage,
        settings:      settingsPage,
        media:         mediaPage,
        notifications: notificationsPage,
        network:       networkPage,
        bluetooth:     bluetoothPage
    })
    Component { id: mainPage;          MainPage {} }
    Component { id: settingsPage;      SettingsPage {} }
    Component { id: mediaPage;         MediaPage {} }
    Component { id: notificationsPage; NotificationsPage {} }
    Component { id: networkPage;       NetworkPage {} }
    Component { id: bluetoothPage;     BluetoothPage {} }

    // keyboard: Esc goes back, then closes
    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Globals.menuBack()
    }

    Fan {
        id: fan
        anchors.fill: parent
        shown: Globals.ui.menuOpen

        // u runs right along the bottom edge, v up the left edge
        cornerTop: false
        cornerLeft: true
        uVertical: false

        zU: root.sw * Globals.style.menuFoot
        aU: root.sw * Globals.style.menuHead
        aV: root.sh
        bow: root.sw * Globals.style.menuBow
        ends: Globals.style.menuEnds.map(e => e * root.sw)
        branches: Globals.style.menuBranches
        peel: Globals.style.fanPeel

        // lower part of the front blade, as wide as the blade allows at its top
        Item {
            id: viewport
            readonly property real vh: root.sh * Globals.style.menuContentHeight

            x: root.pad
            y: root.sh - root.pad - vh
            width: fan.frontUAt(vh + root.pad) - root.pad * 2
            height: vh
            clip: true

            Loader {
                id: loader
                width: parent.width
                height: parent.height
                sourceComponent: root.pages[Globals.ui.menuPage] ?? mainPage

                opacity: 0
                onLoaded: enter.restart()

                // page switch: fade in while sliding a little from the left
                ParallelAnimation {
                    id: enter
                    NumberAnimation {
                        target: loader; property: "opacity"
                        from: 0; to: 1
                        duration: Globals.anim.slow; easing.type: Globals.anim.ease
                    }
                    NumberAnimation {
                        target: loader; property: "x"
                        from: -Globals.style.menuPadding; to: 0
                        duration: Globals.anim.slow; easing.type: Globals.anim.ease
                    }
                }
            }
        }
    }
}
