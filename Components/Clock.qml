
import Quickshell
import QtQuick

Rectangle{
	id:timeRoot
        implicitHeight:Logic.barHeight/10*8
	implicitWidth:Logic.barWidth/4
	gradient:Gradient{
		orientation: Gradient.Horizontal
		GradientStop{ position:0.1 ; color:"#a4f1ff";}
		GradientStop{ position:0.5 ; color:"#ffffff";}
		GradientStop{ position:0.9 ; color:"#a4f1ff";}
	}
	radius:20
	
	Text{
		id:clockText
		anchors.horizontalCenter:parent.horizontalCenter
		anchors.verticalCenter:parent.verticalCenter
		text:Qt.formatDateTime(clock.date, "hh:mm")
		color: "#000000"

		font{
			family:"Keania One"
			letterSpacing:2
			pixelSize:30
			weight:500
		}

	}
	SystemClock{
		id:clock
		precision:SystemClock.Minutes
	}
}

