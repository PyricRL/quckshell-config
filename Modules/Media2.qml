import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services
import qs.Items

MiddleIsland {
  id: island

  collapsedContent: Item {
    width: parent.width
    height: parent.height

    Text {
      anchors.centerIn: parent
      horizontalAlignment: Text.AlignHCenter
      text: MediaService.viewedPlayer ? MediaService.viewedPlayer.trackTitle + " · " + MediaService.viewedPlayer.trackArtist : "No Media Playing"
      elide: Text.ElideRight
    }
  }

  expandedContent: ColumnLayout {
    anchors.fill: parent
    width: parent.width
    Rectangle {
      id: dropdown

      Layout.alignment: Qt.AlignHCenter

      width: 150
      height: 30

      color: "#ff0000"

      property bool open: false

      z: 1

      Text {
        anchors.centerIn: parent

        text: MediaService.viewedPlayer
          ? MediaService.viewedPlayer.identity
          : "Select player"
      }


      MouseArea {
        anchors.fill: parent

        onClicked: {
          dropdown.open = !dropdown.open
        }
      }


      Rectangle {
        visible: dropdown.open

        anchors.top: parent.bottom
        anchors.left: parent.left

        width: parent.width
        height: playerList.implicitHeight

        color: "#222222"

        z: 100


        ColumnLayout {
          id: playerList

          width: parent.width


          Repeater {
            model: MediaService.players


            Rectangle {
              width: parent.width
              height: 30

              color: MediaService.viewedPlayer === modelData
                ? "#555555"
                : "transparent"


              Text {
                anchors.centerIn: parent

                text: modelData.identity
                color: "white"
              }


              MouseArea {
                anchors.fill: parent


                onClicked: {
                  MediaService.viewedPlayer = modelData
                  dropdown.open = false
                }
              }
            }
          }
        }
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

  Timer {
    interval: 500
    repeat: true
    running: island.expanded &&
      MediaService.viewedPlayer !== null &&
      MediaService.viewedPlayer?.isPlaying

    onTriggered: {
      if (MediaService.viewedPlayer) {
        MediaService.viewedPlayer.positionChanged()
      }
    }
  }
}
