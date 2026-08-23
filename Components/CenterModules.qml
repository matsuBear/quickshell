

import QtQuick
import Quickshell
import QtQuick.Layouts

Rectangle{
	width:Logic.barWidth/3
	height:Logic.barHeight
	color:"#ff0000ff"
	FlexboxLayout{
		anchors.fill:parent
		direction:FlexboxLayout.Row
		justifyContent:FlexboxLayout.JustifyCenter
		alignItems:FlexboxLayout.AlignCenter

		Clock{}
	}
}
