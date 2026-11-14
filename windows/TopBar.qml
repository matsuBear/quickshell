import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.windows.bar

// The window is a fixed transparent strip across the top of the screen.
// Only the pill (`bar`) moves; `mask` makes everything else click-through.
PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Globals.style.barHeight + Globals.style.barMargin * 2
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region { item: bar }

    readonly property bool shown: Globals.ui.barOpen

    Rectangle {
        id: bar

        anchors.horizontalCenter: parent.horizontalCenter
        y: root.shown ? Globals.style.barMargin : -height - Globals.style.borderWidth
        // stop rendering once fully tucked away
        visible: y > -height

        width: content.implicitWidth + Globals.style.padding * 4
        height: Globals.style.barHeight
        radius: Globals.style.radius

        color: Globals.alpha(Globals.colors.bg, Globals.style.opacity)
        border.width: Globals.style.borderWidth
        border.color: Globals.colors.border

        Behavior on y {
            NumberAnimation {
                duration: Globals.anim.normal
                easing.type: Globals.anim.ease
            }
        }
        // workspaces appearing/disappearing resize the pill
        Behavior on width {
            NumberAnimation {
                duration: Globals.anim.normal
                easing.type: Globals.anim.ease
            }
        }

        Row {
            id: content
            anchors.centerIn: parent
            spacing: Globals.style.spacing * 2

            Clock {
                anchors.verticalCenter: parent.verticalCenter
            }

            Workspaces {
                anchors.verticalCenter: parent.verticalCenter
            }

            Battery {
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

}
