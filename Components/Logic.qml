pragma Singleton
import QtQuick

QtObject {
    property int barWidth:500
    property int barHeight:50
    property real iconSize:28
    property int islandWidth: openMenu === "" ? barWidth : Math.max(barWidth, menuSizes[openMenu].width + iconSize +2*baseMargin) 
    property int islandHeight: openMenu === "" ? barHeight:barHeight + menuSizes[openMenu].height+ 2*baseMargin
    property int openModHeight:0
    property int openModWidth:0
    property int baseMargin:6
    property string openMenu:""
    property bool contentReady:false

    property var menuSizes: ({
        power:    { width: 200, height: 250 },
        calendar: { width: 200, height: 320 },
        network:  { width: 250, height: 200 },
    })
}

