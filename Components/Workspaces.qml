import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

FlexboxLayout{
	anchors.fill:parent
	direction:FlexboxLayout.Row
	justifyContent:FlexboxLayout.JustifyCenter
	alignItems:FlexboxLayout.AlignCenter
	gap:5
	clip:true

	Repeater{
		model: Hyprland.workspaces.values.filter(ws => ws.toplevels.values.length > 0)
		
		Item{
			id: workspaceDot
			required property var modelData
			readonly property int workspaceId: modelData.id
			readonly property bool isFocused: Hyprland.focusedWorkspace.id === workspaceId

			Layout.preferredWidth: isFocused?36:14
			Layout.preferredHeight: 14
			
			Rectangle{
				anchors.centerIn: parent
				width: isFocused ? 36 : 14
				height: 14
				radius: 90
				color: isFocused ? "#ffffff" : "#555555"
				Behavior on width { NumberAnimation { duration: 200 } }
			}
		}
	}
}
