import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.components
import qs.windows.bar

// The window is a fixed transparent strip across the top of the screen.
// Only `bar` moves; `mask` makes everything else click-through.
PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Globals.style.barHeight
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region { item: bar }

    readonly property bool shown: Globals.ui.barOpen

    Item {
        id: bar

        anchors.horizontalCenter: parent.horizontalCenter
        width: panel.width
        height: Globals.style.barHeight

        // glued to the top edge; slides fully above the screen when hidden
        y: root.shown ? 0 : -height
        visible: y > -height

        Behavior on y {
            NumberAnimation {
                duration: Globals.anim.normal
                easing.type: Globals.anim.ease
            }
        }

        TrapezoidPanel {
            id: panel
            height: parent.height
            innerWidth: content.implicitWidth + Globals.style.padding * 4

            // workspaces appearing/disappearing resize the panel
            Behavior on innerWidth {
                NumberAnimation {
                    duration: Globals.anim.normal
                    easing.type: Globals.anim.ease
                }
            }
        }

        Row {
            id: content
            anchors.horizontalCenter: parent.horizontalCenter
            // center in the area above the bottom border
            y: (parent.height - panel.borderWidth - height) / 2
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
