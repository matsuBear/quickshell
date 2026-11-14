import QtQuick
import qs
import qs.components

// Hub: one tile per sub-page. Add an entry here + a Component in
// SideMenu's registry to add a page. Fills the menu's viewport.
Item {
    id: root

    readonly property var entries: [
        { page: "settings",      label: "System",    icon: Globals.icons.settings  },
        { page: "media",         label: "Media",     icon: Globals.icons.music     },
        { page: "notifications", label: "Notifs",    icon: Globals.icons.bell      },
        { page: "network",       label: "Network",   icon: Globals.icons.wifi      },
        { page: "bluetooth",     label: "Bluetooth", icon: Globals.icons.bluetooth }
    ]

    readonly property int columns: Globals.style.menuColumns
    readonly property real cell: (width - grid.spacing * (columns - 1)) / columns

    Grid {
        id: grid
        width: parent.width
        columns: root.columns
        spacing: Globals.style.spacing * 2

        Repeater {
            model: root.entries

            delegate: MenuButton {
                required property var modelData
                implicitWidth: root.cell
                implicitHeight: root.cell
                icon: modelData.icon
                label: modelData.label
                onClicked: Globals.ui.menuPage = modelData.page
            }
        }
    }
}
