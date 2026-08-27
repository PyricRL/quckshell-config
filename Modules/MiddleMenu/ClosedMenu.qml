import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Items.Styled

Item {
  id: root

  implicitWidth: textItem.implicitWidth
  implicitHeight: textItem.implicitHeight

  StyledText {
    id: textItem

    anchors.fill: parent
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHLeft

    small: true
    elide: Text.ElideRight

    text: MediaService.activePlayer ? MediaService.activePlayer.trackTitle + " · " + MediaService.activePlayer.trackArtist : "No Media Playing"
  }
}
