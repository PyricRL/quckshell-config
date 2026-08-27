import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Items.Styled

Item {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  width: implicitWidth + 20
  height: implicitHeight

  Row {
    id: row
    spacing: 4

    Repeater {
      model: NiriService.workspaces

      StyledButton {
        visible: (index < 11) && (!model.output || model.output === "DP-3")

        implicitWidth: 16
        implicitHeight: 16

        radius: width / 2
      }
    }
  }
}
