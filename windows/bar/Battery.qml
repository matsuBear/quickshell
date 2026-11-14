import QtQuick
import Quickshell.Services.UPower
import qs

Row {
    id: root
    spacing: Globals.style.spacing

    readonly property UPowerDevice dev: UPower.displayDevice
    readonly property real level: dev?.percentage ?? 0      // 0.0 – 1.0
    readonly property bool plugged: !UPower.onBattery

    readonly property color levelColor: level < 0.10 ? Globals.colors.error
                                      : level < 0.20 ? Globals.colors.warning
                                      : Globals.colors.success

    visible: dev?.isLaptopBattery ?? false

    // ── Drawn battery icon ───────────────────────────────────
    Item {
        anchors.verticalCenter: parent.verticalCenter
        width: 22
        height: 11

        Rectangle {
            id: body
            width: parent.width - 2
            height: parent.height
            radius: 3
            color: "transparent"
            border.width: 1.5
            border.color: root.plugged ? Globals.colors.accentWarm : Globals.colors.fgDim

            Behavior on border.color {
                ColorAnimation { duration: Globals.anim.fast }
            }

            Rectangle {
                x: 2
                y: 2
                height: parent.height - 4
                width: Math.max(0, (parent.width - 4) * root.level)
                radius: 1.5
                color: root.levelColor

                Behavior on width {
                    NumberAnimation { duration: Globals.anim.slow; easing.type: Globals.anim.ease }
                }
            }
        }

        // terminal nub
        Rectangle {
            x: body.width
            anchors.verticalCenter: parent.verticalCenter
            width: 2
            height: 5
            radius: 1
            color: body.border.color
        }
    }

    // ── Plugged indicator ────────────────────────────────────
    Text {
        anchors.verticalCenter: parent.verticalCenter
        visible: root.plugged
        text: Globals.icons.bolt
        color: Globals.colors.accentWarm
        font.family: Globals.style.iconFamily
        font.pixelSize: Globals.style.fontSize
    }

    // ── Percentage ───────────────────────────────────────────
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Math.round(root.level * 100) + "%"
        color: root.levelColor
        font.family: Globals.style.fontFamily
        font.pixelSize: Globals.style.fontSize
    }
}
