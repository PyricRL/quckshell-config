import QtQuick
import QtQuick.Layouts

import qs.themes

Item {
  id: root

  property alias spacing: layout.spacing

  default property alias content: layout.data

  implicitHeight: bgRect.implicitHeight
  implicitWidth: bgRect.implicitWidth

  StyledRect {
    id: bgRect

    color: Colors.background
    implicitWidth: layout.implicitWidth + 8
    implicitHeight: 32
    radius: 6

    RowLayout {
      id: layout
      anchors.centerIn: parent
    }
  }
}
