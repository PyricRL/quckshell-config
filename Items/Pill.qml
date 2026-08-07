import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root

  radius: 4

  implicitHeight: 24
  implicitWidth: contentRow.implicitWidth

  border {
    color: "#ff0000"
    width: 1
  }

  color: "#ffffff"

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
