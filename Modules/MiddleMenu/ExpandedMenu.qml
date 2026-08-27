import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services
import qs.Items
import qs.Items.Styled

ColumnLayout {
  id: root

  FrameAnimation {
    id: positionMonitor

    running: {
      const player = MediaService.viewedPlayer

      return player && player.playbackState === 1
    }

    onTriggered: {
      const player = MediaService.viewedPlayer

      if (player)
        player.positionChanged()
    }
  }

  StyledDropdown {
    id: dropdown
    Layout.alignment: Qt.AlignHCenter
    z: 1
    model: MediaService.players
    textRole: "identity"
    placeholderText: "Select Player"

    currentIndex: {
      if (!MediaService.viewedPlayer || !MediaService.players) {
        return -1
      }
      
      return MediaService.players.indexOf(MediaService.viewedPlayer)
    }

    onSelected: function(item, index) {
      MediaService.viewedPlayer = item
    }
  }
  ColumnLayout {
    Layout.alignment: Qt.AlignHCenter
    Image {
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredWidth: 150
      Layout.preferredHeight: 150
      
      source: MediaService.viewedPlayer
        ? MediaService.viewedPlayer.trackArtUrl
        : ""

      fillMode: Image.PreserveAspectCrop

      smooth: true
      mipmap: true
    }
    StyledText {
      small: true
        Layout.alignment: Qt.AlignHCenter
        text: MediaService.viewedPlayer
          ? MediaService.viewedPlayer.trackTitle
          : "Unable to find Title"
    }
    StyledText {
      small: true
        Layout.alignment: Qt.AlignHCenter
        text: MediaService.viewedPlayer
          ? MediaService.viewedPlayer.trackArtist
          : "Unable to find Artist"
    }
    StyledSlider {
      id: positionSlider

      Layout.alignment: Qt.AlignHCenter
      Layout.preferredWidth: 220

      from: 0

      to: MediaService.viewedPlayer
        ? MediaService.viewedPlayer.length
        : 1

      Binding {
        target: positionSlider
        property: "value"

        value: MediaService.viewedPlayer
          ? MediaService.viewedPlayer.position
          : 0

        when: !positionSlider.pressed
      }

      onInteraction: function(newPosition) {
        if (MediaService.viewedPlayer)
          MediaService.viewedPlayer.position = newPosition
      }
    }
  }
  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    StyledButton {
      implicitWidth: 40
      implicitHeight: 20
      text: "back"
      small: true
      onClicked: {
        if (MediaService.viewedPlayer) {
          MediaService.viewedPlayer.previous()
        }
      }
    }
    StyledButton {
      implicitWidth: 40
      implicitHeight: 20
      text: "pause"
      small: true
      onClicked: {
        if (MediaService.viewedPlayer) {
          MediaService.viewedPlayer.togglePlaying()
        }
      }
    }
    StyledButton {
      implicitWidth: 40
      implicitHeight: 20
      text: "skip"
      small: true
      onClicked: {
        if (MediaService.viewedPlayer) {
          MediaService.viewedPlayer.next()
        }
      }
    }
  }
}
