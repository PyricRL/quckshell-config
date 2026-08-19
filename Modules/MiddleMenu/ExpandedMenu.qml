import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services
import qs.Items
import qs.Items.Styled

ColumnLayout {
    id: root

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
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: MediaService.viewedPlayer
                ? MediaService.viewedPlayer.trackTitle
                : "Unable to find Title"
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: MediaService.viewedPlayer
                ? MediaService.viewedPlayer.trackArtist
                : "Unable to find Artist"
        }
        Slider {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 220

            minimum: 0

            maximum: MediaService.viewedPlayer
                ? MediaService.viewedPlayer.length
                : 1

            value: MediaService.viewedPlayer
                ? MediaService.viewedPlayer.position
                : 0
            
            onMoved: function(value) {
                if (MediaService.viewedPlayer)
                    MediaService.viewedPlayer.position = value
            }
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Rectangle {
            implicitWidth: 40
            implicitHeight: 20
            color: "#ff0000"
            Text {
                text: "back"
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
            implicitWidth: 40
            implicitHeight: 20
            color: "#ff0000"
            Text {
                text: "pause"
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
            implicitWidth: 40
            implicitHeight: 20
            color: "#ff0000"
            Text {
                text: "skip"
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

