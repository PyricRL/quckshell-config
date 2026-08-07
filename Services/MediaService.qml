pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property var players: Mpris.players.values
    property MprisPlayer activePlayer: null
    property MprisPlayer viewedPlayer: activePlayer

    function updateActive() {
        let list = Array.from(Mpris.players.values)

        for (let p of list) {
            if (p.playbackState === 1) {
                activePlayer = p
                return
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateActive()
    }

    Component.onCompleted: updateActive()
}
