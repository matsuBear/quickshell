import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow{
	id:bar
	anchors{
		top:true
		left:true
		bottom:true
	}


	implicitWidth:50

	ColumnLayout{
		id:barLayout
		anchors.fill:parent
		spacing:3
		
		Rectangle{
			id:modulesTop
			implicitHeight:bar.height/4
			color:"#0000ff"
			Layout.fillWidth:true

			FlexboxLayout{
				id:modulesTopBox
				anchors.fill:parent
				direction:FlexboxLayout.Column
				justifyContent:FlexboxLayout.JustifySpaceEvenly

				Clock {
					implicitWidth:bar.implicitWidth
				}
			}
		}
	}
}
