import QtQuick
import QtQuick.Layouts

import qs.modules.widgets
import qs.services

Item {
  id: mediaContainer

  Layout.alignment: Qt.AlignVCenter

  implicitWidth: 266
  implicitHeight: 32

  MouseArea {
    anchors.fill: parent

    onWheel: function(wheel) {
      if (wheel.angleDelta.y > 0) {
        Mpris.increaseVolume(0.05)
      } else {
        Mpris.decreaseVolume(0.05)
      }
      wheel.accepted = true
    }
  }

  StyledGroup {
    anchors.fill: parent
    spacing: 8

    Column {
      id: infoColumn

      Layout.fillHeight: true
      Layout.fillWidth: true

      spacing: -3

      StyledText {
        id: songItem
        fontSize: 14
        bold: true

        text: Mpris.title
        elide: Text.ElideRight
        width: 200
      }

      StyledText {
        id: artistItem
        text: Mpris.artist
        fontSize: 12
        elide: Text.ElideRight
        width: 200
      }
    }

    Row {
      id: buttonColumn

      spacing: 4
      Layout.alignment: Qt.AlignRight

      Layout.preferredWidth: 86

      StyledButton {
        implicitWidth: 26
        implicitHeight: 26

        iconSize: 16
        iconOffsetX: -1
        iconOffsetY: 1

        icon: ""

        variant: "background"
        tint: 0.4

        onClicked: {
          Mpris.previous()
        }
      }

      StyledButton {
        implicitWidth: 26
        implicitHeight: 26

        iconSize: 18

        variant: "background"
        tint: 0.4

        icon: Mpris.isPlaying ? "" : ""
        iconOffsetX: Mpris.isPlaying ? 0 : 1

        onClicked: {
          Mpris.playPause()
        }
      }

      StyledButton {
        implicitWidth: 26
        implicitHeight: 26

        iconSize: 16

        variant: "background"
        tint: 0.4

        icon: ""
        iconOffsetX: 1
        iconOffsetY: 1

        onClicked: {
          Mpris.next()
        }
      }
    }
  }

  
}

