import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services
import qs.Items.Styled

import "../../config.js" as Theme

RowLayout {
  clip: true
  Image {
    visible: MediaService.viewedPlayer
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: 30
    Layout.preferredHeight: 30
    
    source: MediaService.viewedPlayer
      ? MediaService.viewedPlayer.trackArtUrl
      : ""

    fillMode: Image.PreserveAspectCrop

    smooth: true
    mipmap: true
  }

  ColumnLayout {
    Layout.fillWidth: true
    StyledText {
      Layout.alignment: Qt.AlignLeft
      Layout.fillWidth: true
      small: true
      text: MediaService.activePlayer ? MediaService.activePlayer.trackTitle + " · " + MediaService.activePlayer.trackArtist : "No Media Playing"
      elide: Text.ElideRight
    }

    // button layout
    RowLayout {
      Layout.alignment: Qt.AlignHCenter
      spacing: Theme.sizes.spacingLarge

      StyledButton {
        small: true
        text: "󰼨"
        disabled: !MediaService.viewedPlayer

        Layout.preferredWidth: 24
        Layout.preferredHeight: 24

        onClicked: {
          if (MediaService.viewedPlayer) {
            MediaService.viewedPlayer.previous()
          }
        }
      }

      StyledButton {
        small: true
        text: MediaService.viewedPlayer && MediaService.viewedPlayer.isPlaying
          ? ""
          : ""
        disabled: !MediaService.viewedPlayer

        Layout.preferredWidth: 24
        Layout.preferredHeight: 24

        onClicked: {
          if (MediaService.viewedPlayer) {
            MediaService.viewedPlayer.togglePlaying()
          }
        }
      }

      StyledButton {
        small: true
        text: "󰼧"
        disabled: !MediaService.viewedPlayer

        Layout.preferredWidth: 24
        Layout.preferredHeight: 24

        onClicked: {
          if (MediaService.viewedPlayer) {
            MediaService.viewedPlayer.next()
          }
        }
      }
    }
  }
}
