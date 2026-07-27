
import Quickshell
import QtQuick

BarModule{
	id:timeRoot
        implicitHeight: column.implicitHeight
	implicitWidth:column.implicitWidth
	Column{
		id:column
		spacing:2
		anchors.centerIn:parent
		Text{
			anchors.horizontalCenter:parent.horizontalCenter
			text:Qt.formatDateTime(clock.date, "hh")
			color: "#000000"

			font{
				family:"Keania One"
				letterSpacing:0.5
				pixelSize:20
				weight:500
			}

		}
		Text{
			anchors.horizontalCenter:parent.horizontalCenter
			text:Qt.formatDateTime(clock.date, "mm")
			color: "#000000"
			font{
				family:"Keania One"
				letterSpacing:0.5
				pixelSize:20
				weight:500
			}

		}
		SystemClock{
			id:clock
			precision:SystemClock.Minutes
		}
	}
	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		onEntered: fullDate.open = true
		onExited: fullDate.open = false
	}
	HoverPopup{
		id: fullDate
		anchor.item:timeRoot
		maxWidth:400
	}
}
