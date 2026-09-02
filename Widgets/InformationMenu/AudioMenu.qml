import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell.Services.Pipewire

import qs.Items
import qs.Items.Styled
import qs.Services
import qs.Modules.Notifications

import "../../config.js" as Theme

Item {
  id: root
  
  PwObjectTracker {
    objects: [Pipewire.defaultAudioSource, Pipewire.defaultAudioSink]
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: Theme.sizes.spacingSmall

    RowLayout {
      Layout.fillWidth: true
      Layout.preferredHeight: Theme.bar.height

      Text {
        text: "Audio"
        color: Theme.colors.text
        font.family: Theme.bar.fontFamily
        font.pixelSize: Theme.bar.fontSize
        font.bold: true
        Layout.fillWidth: true
      }
    }

    Rectangle {
      Layout.fillWidth: true
      implicitHeight: 2
      color: Theme.colors.border
    }

    Item {
      id: audioSelection
      property string selectedSection: "output"

      Layout.fillWidth: true
      Layout.fillHeight: true

      RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        StyledCheckbox {
          Layout.fillWidth: true
          Layout.preferredWidth: 1
          text: "Output"

          selected: audioSelection.selectedSection === "output"

          onClicked: {
            audioSelection.selectedSection = "output"
          }
        }
        StyledCheckbox {
          Layout.fillWidth: true
          Layout.preferredWidth: 1
          text: "Input"

          selected: audioSelection.selectedSection === "input"

          onClicked: {
            audioSelection.selectedSection = "input"
          }
        }
      }
    }
  }
}
