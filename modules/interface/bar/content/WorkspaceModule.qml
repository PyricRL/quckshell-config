import QtQuick
import QtQuick.Layouts

import qs.modules.widgets
import qs.services
import qs.themes
import qs.modules.functions

Item {
  id: workspaceContainer

  Layout.alignment: Qt.AlignVCenter
  implicitWidth: group.implicitWidth
  implicitHeight: 32

  StyledGroup {
    id: group
    anchors.fill: parent

    RowLayout {
      id: layout
      spacing: 2

      Repeater {
        model: Niri.workspaces

        StyledButton {
          id: button

          visible: (index < 11) && (!model.output || model.output === "DP-3")

          variant: "background"

          implicitWidth: 26
          implicitHeight: 26

          checked: model.isActive

          text: index
          fontSize: 14

          onClicked: Niri.focusWorkspace(model.id)
        }
      }
    }
  }
}
