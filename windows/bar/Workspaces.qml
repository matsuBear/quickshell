import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

Row {
    id: root
    spacing: Globals.style.spacing / 2

    readonly property int pillHeight: Globals.style.barHeight - Globals.style.padding * 3.5

    Repeater {
        model: Hyprland.workspaces

        delegate: Rectangle {
            id: ws

            required property HyprlandWorkspace modelData
            readonly property bool focused: Hyprland.focusedWorkspace?.id === modelData.id

            // negative ids = special workspaces (scratchpads); Row skips invisible items
            visible: modelData.id > 0

            height: root.pillHeight
            width: focused ? height * 1.8 : height
            radius: 30

            color: focused ? Globals.colors.accentCold
                 : hover.containsMouse ? Globals.colors.surface
                 : "transparent"

            Behavior on width {
                NumberAnimation {
                    duration: Globals.anim.normal + 3
                    easing.type: Globals.anim.ease
                }
            }
            Behavior on color {
                ColorAnimation { duration: Globals.anim.fast }
            }

            Text {
                anchors.centerIn: parent
                text: ws.modelData.id
                color: ws.focused ? Globals.colors.bg : Globals.colors.fgDim
                font.family: Globals.style.fontFamily
                font.pixelSize: Globals.style.fontSizeSmall
                font.bold: ws.focused

                Behavior on color {
                    ColorAnimation { duration: Globals.anim.fast }
                }
            }

            MouseArea {
                id: hover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`workspace ${ws.modelData.id}`)
            }
        }
    }
}
