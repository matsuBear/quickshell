import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow{
	id:barWindow
	anchors{
		top:true
		left:true
		right:true
		bottom:true
	}

		
	exclusionMode:ExclusionMode.Ignore
	color:"transparent"

	mask: Region{
		item:island
	}

	Rectangle{

		id:island
		anchors.top: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: Logic.baseMargin

		gradient: Gradient{
			orientation: Gradient.Horizontal
			GradientStop{ position: 0.2 ; color: "#aad7f8ff";}
			GradientStop{ position: 0.5 ; color: "#aa4dcddf";}
			GradientStop{ position: 0.8; color: "#daa7f8ff";}
		}
		radius:90

		width:Logic.islandWidth
		height:Logic.islandHeight

		MouseArea{
			id:islandMouser
			anchors.fill:island
			
			hoverEnabled: true
		}

		Behavior on width {
			NumberAnimation{
				duration:400
				onRunningChanged: if (!running && Logic.openMenu !== "") Logic.contentReady = true
			}
		}

		Behavior on height {
			NumberAnimation{
				duration:400
				onRunningChanged: if (!running && Logic.openMenu !== "") Logic.contentReady = true
			}
		}

		FlexboxLayout{

			id:islandLayout
			anchors.centerIn:parent
			direction:FlexboxLayout.Column
			justifyContent:FlexboxLayout.Center
			alignItems:FlexboxLayout.AlignCenter

			Bar{}
		}
	}
}
