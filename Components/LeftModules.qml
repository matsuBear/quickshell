import QtQuick
import Quickshell
import QtQuick.Layouts

Rectangle{
	width:Logic.barWidth/4
	height:Logic.barHeight
	color:"#00ffffff"
	FlexboxLayout{
		anchors.fill:parent
		direction:FlexboxLayout.Row
		justifyContent:FlexboxLayout.End
		alignItems:FlexboxLayout.AlignCenter

		Power{}
	}
}

