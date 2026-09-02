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

  property bool selected: false

  property var bgColor: null

  signal clicked
  signal wheelEvent(var event)

  radius: Theme.sizes.radiusSmall

  border.width: Theme.sizes.borderWidth
  border.color: root.selected
                ? Theme.colors.contentActive
                : Theme.colors.accent

  color: {
    if (root.bgColor !== null) {
      return root.bgColor
    }

    if (!root.accentBg) {
      return "transparent"
    }

    if (root.disabled) {
      return Theme.colors.surfaceDisabled
    }

    if (root.selected) {
      return Theme.colors.surfaceActive
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
    cursorShape: root.disabled
                 ? Qt.ArrowCursor
                 : Qt.PointingHandCursor

    onClicked: {
      if (!root.disabled) {
        root.clicked()
      }
    }

    onWheel: function(event) {
      root.wheelEvent(event)
      event.accepted = true
    }
  }
}

