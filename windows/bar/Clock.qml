import QtQuick
import Quickshell
import qs

Text {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "hh:mm")
    color: Globals.colors.fg
    font.family: Globals.style.fontFamily
    font.pixelSize: Globals.style.fontSize
    font.bold: true
}
