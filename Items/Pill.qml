import QtQuick
import QtQuick.Layouts

import "../config.js" as Theme

Rectangle {
  id: root

  radius: Theme.sizes.radiusSmall

  implicitHeight: Theme.bar.height
  implicitWidth: contentRow.implicitWidth + 8

  border {
    color: Theme.colors.accent
    width: Theme.sizes.borderWidth
  }

  color: Theme.colors.background

  default property alias content: contentRow.data

  RowLayout {
    id: contentRow

    anchors {
      fill: parent
      leftMargin: 4
      rightMargin: 4
    }

    spacing: 4
  }
}
