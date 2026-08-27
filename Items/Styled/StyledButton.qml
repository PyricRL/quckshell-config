import QtQuick
import "../../config.js" as Theme

Rectangle {
  id: root

  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight

  property alias text: label.text
  property bool muted: false
  property bool small: false
  property bool accentText: false
  property bool accentBg: true
  property bool disabled: false

  signal clicked

  radius: Theme.sizes.radiusSmall

  border.width: Theme.sizes.borderWidth
  border.color: Theme.colors.accent

  color: {
    if (!root.accentBg) {
      return "transparent"
    }

    if (root.disabled) {
      return Theme.colors.surfaceDisabled
    }

    if (mouseArea.pressed) {
      return Theme.colors.surfaceActive
    }

    if (mouseArea.containsMouse) {
      return Theme.colors.surfaceHover
    }

    return Theme.colors.surfaceInteractive
  }

  Text {
    id: label

    anchors.centerIn: parent

    color: {
      if (root.disabled) {
        return Theme.colors.contentDisabled
      }

      if (root.accentText) {
        if (mouseArea.pressed) {
          return Theme.colors.contentActive
        }

        if (mouseArea.containsMouse) {
          return Theme.colors.contentHover
        }
      } 


      return Theme.colors.contentInteractive
    }

    font.family: Theme.bar.fontFamily
    font.pixelSize: small ? Theme.bar.fontSizeSmall : Theme.bar.fontSize
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: root.clicked()
  }
}
