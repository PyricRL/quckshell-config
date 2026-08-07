import QtQuick
import QtQuick.Layouts

import qs.Services

Item {
  Text {
    anchors.centerIn: parent
    horizontalAlignment: Text.AlignHCenter
    text: MediaService.activePlayer ? MediaService.activePlayer.trackTitle + " · " + MediaService.activePlayer.trackArtist : "No Media Playing"
    elide: Text.ElideRight
  }
}
