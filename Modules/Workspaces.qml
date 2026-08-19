import QtQuick
import QtQuick.Layouts

import qs.Services

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

      Rectangle {
        visible: (index < 11) && (!model.output || model.output === "DP-3")

        implicitWidth: 16
        implicitHeight: 16

        radius: width / 2
        color: "#000000"
      }
    }
  }
}
