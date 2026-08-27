import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.Services
import qs.Items
import qs.Items.Styled

import "../../config.js" as Theme

ColumnLayout {
  id: root

  spacing: Theme.sizes.spacingLarge

  FrameAnimation {
    id: positionMonitor

    running: {
      const player = MediaService.viewedPlayer
      return player && player.playbackState === 1
    }

    onTriggered: {
      const player = MediaService.viewedPlayer
      if (player) player.positionChanged()
    }
  }

  StyledDropdown {
    id: dropdown
    Layout.alignment: Qt.AlignHCenter
    z: 100
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
    spacing: Theme.sizes.spacingSmall

    ClippingRectangle {
      visible: MediaService.viewedPlayer !== null
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredWidth: 150
      Layout.preferredHeight: 150
      
      radius: Theme.sizes.radiusLarge
      clip: true
      color: Theme.colors.surfaceInteractive

      Image {
        anchors.fill: parent
        source: MediaService.viewedPlayer
          ? MediaService.viewedPlayer.trackArtUrl
          : ""

        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
      }
    }

    StyledText {
      small: true
      Layout.alignment: Qt.AlignHCenter
      Layout.maximumWidth: 220
      elide: Text.ElideRight
      
      text: MediaService.viewedPlayer
        ? MediaService.viewedPlayer.trackTitle
        : "No Media Selected"

      color: MediaService.viewedPlayer 
        ? Theme.colors.contentInteractive 
        : Theme.colors.contentDisabled
    }

    StyledText {
      small: true
      Layout.alignment: Qt.AlignHCenter
      Layout.maximumWidth: 220
      elide: Text.ElideRight
      
      text: MediaService.viewedPlayer
        ? MediaService.viewedPlayer.trackArtist
        : ""

      color: Theme.colors.textMuted
    }

    StyledSlider {
      id: positionSlider

      Layout.alignment: Qt.AlignHCenter
      Layout.preferredWidth: 220
      enabled: MediaService.viewedPlayer !== null

      from: 0
      to: MediaService.viewedPlayer ? MediaService.viewedPlayer.length : 1

      Binding {
        target: positionSlider
        property: "value"

        value: MediaService.viewedPlayer ? MediaService.viewedPlayer.position : 0
        when: !positionSlider.pressed
      }

      onInteraction: function(newPosition) {
        if (MediaService.viewedPlayer) {
          MediaService.viewedPlayer.position = newPosition
        }
      }
    }
  }

  RowLayout {
    Layout.alignment: Qt.AlignHCenter
    spacing: Theme.sizes.spacingMedium

    StyledButton {
      Layout.preferredWidth: 44
      Layout.preferredHeight: 28
      text: ""
      small: true
      disabled: !MediaService.viewedPlayer

      onClicked: {
        if (MediaService.viewedPlayer) {
          MediaService.viewedPlayer.previous()
        }
      }
    }

    StyledButton {
      Layout.preferredWidth: 44
      Layout.preferredHeight: 28
      text: MediaService.viewedPlayer && MediaService.viewedPlayer.isPlaying ? "" : ""
      small: true
      disabled: !MediaService.viewedPlayer

      onClicked: {
        if (MediaService.viewedPlayer) {
          MediaService.viewedPlayer.togglePlaying()
        }
      }
    }

    StyledButton {
      Layout.preferredWidth: 44
      Layout.preferredHeight: 28
      text: ""
      small: true
      disabled: !MediaService.viewedPlayer

      onClicked: {
        if (MediaService.viewedPlayer) {
          MediaService.viewedPlayer.next()
        }
      }
    }
  }
}
