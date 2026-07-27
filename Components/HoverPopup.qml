import Quickshell
import QtQuick

PopupWindow {
    id: root
    property bool open: false
    default property alias content: contentHolder.data
    onOpenChanged:if(open) visible=true
    anchor.edges: Edges.Right | Edges.Top
    color: "transparent"

    property int maxWidth:200
    property int maxHeight:200

    implicitHeight:maxHeight
    implicitWidth:open?maxWidth:1

    Behavior on implicitWidth{
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutCubic
            onRunningChanged: if (!running && !root.open) root.visible = false
        }
    }

    Rectangle{
        id: contentHolder
        anchors.fill: parent
        clip:true
        color: "#ffffff"
        opacity:root.implicitWidth>2? 1:0
    }
}
