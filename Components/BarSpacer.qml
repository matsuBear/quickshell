import Quickshell
import QtQuick


PanelWindow {
    anchors { top: true; left: true; right: true }
    exclusiveZone: Logic.barHeight + Logic.baseMargin
    implicitHeight: Logic.barHeight + Logic.baseMargin
    color: "transparent"
    mask: Region {}
}
