import QtQuick
import qs

// Icon (+ optional label) button. Used for the main-page tiles and,
// at a smaller size, for the back button on sub-pages.
Rectangle {
    id: root

    property string icon
    property string label
    property int iconSize: Globals.style.fontSizeLarge * 1.6
    readonly property bool hovered: mouse.containsMouse

    signal clicked()

    implicitWidth: 96
    implicitHeight: 96
    radius: Globals.style.radius

    border.width: Globals.style.borderWidth
    border.color: hovered ? Globals.colors.accentWarm : Globals.alpha(Globals.colors.fgMuted, 0.4)
    Behavior on border.color { ColorAnimation { duration: Globals.anim.fast } }

    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop {
            position: 0.0
            color: root.hovered ? Globals.colors.surface : Globals.alpha(Globals.colors.surface, 0.25)
            Behavior on color { ColorAnimation { duration: Globals.anim.fast } }
        }
        GradientStop {
            position: 1.0
            color: root.hovered ? Globals.colors.bgRaised : Globals.alpha(Globals.colors.bgRaised, 0.25)
            Behavior on color { ColorAnimation { duration: Globals.anim.fast } }
        }
    }

    scale: mouse.pressed ? 0.95 : 1
    Behavior on scale { NumberAnimation { duration: Globals.anim.fast; easing.type: Globals.anim.ease } }

    Column {
        anchors.centerIn: parent
        spacing: Globals.style.spacing

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.icon
            color: root.hovered ? Globals.colors.accentWarm : Globals.colors.fg
            font.family: Globals.style.iconFamily
            font.pixelSize: root.iconSize
            Behavior on color { ColorAnimation { duration: Globals.anim.fast } }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.label !== ""
            text: root.label
            color: Globals.colors.fgDim
            font.family: Globals.style.fontFamily
            font.pixelSize: Globals.style.fontSizeSmall
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
