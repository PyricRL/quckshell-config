import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services

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
    Text {
      Layout.alignment: Qt.AlignLeft
      Layout.fillWidth: true
      text: MediaService.activePlayer ? MediaService.activePlayer.trackTitle + " · " + MediaService.activePlayer.trackArtist : "No Media Playing"
      elide: Text.ElideRight
    }

    // button layout
    RowLayout {
      Layout.alignment: Qt.AlignHCenter
      Rectangle {
        Layout.preferredWidth: 18
        Layout.preferredHeight: 18
        radius: height / 2
        color: "#000000"

        Text {
          anchors.centerIn: parent
          text: "󰼨"
          color: "white"
          font.pixelSize: 12
        }
        
        MouseArea {
          anchors.fill: parent

          onClicked: {
            if (MediaService.viewedPlayer) {
              MediaService.viewedPlayer.previous()
            }
          }
        }
      }
      Rectangle {
        Layout.preferredWidth: 18
        Layout.preferredHeight: 18
        radius: height / 2
        color: "#000000"

        Text {
          anchors.centerIn: parent
          text: MediaService.viewedPlayer && MediaService.viewedPlayer.isPlaying
            ? ""
            : ""
          color: "white"
          font.pixelSize: 12
        }

        MouseArea {
          anchors.fill: parent

          onClicked: {
            if (MediaService.viewedPlayer) {
              MediaService.viewedPlayer.togglePlaying()
            }
          }
        }
      }
      Rectangle {
        Layout.preferredWidth: 18
        Layout.preferredHeight: 18
        radius: height / 2
        color: "#000000"

        Text {
          anchors.centerIn: parent
          text: "󰼧"
          color: "white"
          font.pixelSize: 12
        }

        MouseArea {
          anchors.fill: parent

          onClicked: {
            if (MediaService.viewedPlayer) {
              MediaService.viewedPlayer.next()
            }
          }
        }
      }
    }
  }
}
