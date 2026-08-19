import QtQuick
import "../../config.js" as Theme

Item {
  id: root

  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight

  property alias text: label.text
  property bool muted: false
  property bool small: false

  signal clicked

  Text {
    id: label

    color: root.muted ? Theme.colors.textMuted : Theme.colors.text
    font.family: Theme.bar.fontFamily
    font.pixelSize: small ? Theme.bar.fontSizeSmall : Theme.bar.fontSize
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor

    onClicked: root.clicked()
  }
}
