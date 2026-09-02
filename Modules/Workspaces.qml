import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Items.Styled

import "../config.js" as Theme

Item {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  width: implicitWidth + 20
  height: implicitHeight

  Row {
    id: row
    spacing: Theme.sizes.spacingSmall

    Repeater {
      model: NiriService.workspaces

      StyledButton {
        visible: (index < 11) && (!model.output || model.output === "DP-3")

        implicitWidth: 18
        implicitHeight: 18

        radius: Theme.sizes.radiusSmall

        text: index
        small: true

        bgColor: model.isActive ? Theme.colors.surfaceActive : Theme.colors.surfaceInteractive

        onClicked: {
          NiriService.focusWorkspace(model.id)
        }
      }
    }
  }
}
