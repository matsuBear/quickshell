import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle{
	opacity: (Logic.openMenu === "calendar" && Logic.contentReady) ? 1 : 0
	Behavior on opacity { NumberAnimation { duration: 150 } }
	visible: opacity > 0

	Layout.preferredWidth: Logic.menuSizes.calendar.width
	Layout.preferredHeight: Logic.menuSizes.calendar.height
}
