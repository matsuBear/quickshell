import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle{
	id:trueBar
	width:Logic.barWidth
	height:Logic.barHeight
	radius:90
	color:"transparent"
	FlexboxLayout{
		id:inner
		anchors.fill:parent
		direction:FlexboxLayout.Row
		justifyContent:FlexboxLayout.JustifySpaceEvenly
		alignItems:FlexboxLayout.AlignCenter

		LeftModules{
			Layout.leftMargin:10

		}
		CenterModules{}
		RightModules{
			Layout.rightMargin:10
		}
	}
	MouseArea {
		id:barMouser
		anchors.fill:trueBar
	}

	Behavior on color{ColorAnimation{}}
}
