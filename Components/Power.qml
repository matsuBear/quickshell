import QtQuick
import Quickshell

Item{
	id:power
	implicitHeight:powerIcon.implicitHeight
	implicitWidth:powerIcon.implicitHeight

	Text{
		id:powerIcon
		text:""
		anchors.centerIn:power
		font{
			pixelSize:Logic.iconSize
			weight:300
		}
	}
	MouseArea {
		anchors.fill:power
		hoverEnabled: true
	}
}
