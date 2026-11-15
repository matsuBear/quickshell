import QtQuick
import Quickshell
import qs

Row {
    id: root
    spacing: Globals.style.spacing * 2

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // English names regardless of the system locale
    readonly property var locale: Qt.locale("en_US")

    function ordinal(n: int): string {
        const s = ["th", "st", "nd", "rd"], v = n % 100;
        return n + (s[(v - 20) % 10] || s[v] || s[0]);
    }

    Text {
        anchors.baseline: date.baseline
        text: Qt.formatTime(clock.date, "hh:mm")
        color: Globals.colors.fg
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSizeLarge
        font.bold: true
    }

    Text {
        id: date
        text: clock.date.toLocaleDateString(root.locale, "dddd MMM ") + root.ordinal(clock.date.getDate())
        color: Globals.colors.fgDim
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
