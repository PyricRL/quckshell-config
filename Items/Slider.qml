import QtQuick
import "../config.js" as Theme

Item {
  id: root

  property real value: 0
  property real minimum: 0
  property real maximum: 1

  property bool interactive: true
  property bool disabled: false

  signal moved(real value)
  signal interaction(real value)

  implicitWidth: 200
  implicitHeight: Theme.sizes.sliderHandle

  readonly property real progress: (maximum > minimum) 
    ? Math.max(0, Math.min(1, (value - minimum) / (maximum - minimum)))
    : 0

  readonly property bool isPressed: mouseArea.pressed
  readonly property bool isHovered: mouseArea.containsMouse

  Rectangle {
    id: track
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    height: Theme.sizes.sliderHeight
    radius: height / 2

    color: root.disabled 
      ? Theme.colors.surfaceDisabled 
      : Theme.colors.sliderBackground

    Rectangle {
      width: parent.width * root.progress
      height: parent.height
      radius: parent.radius

      color: {
        if (root.disabled) return Theme.colors.contentDisabled
        if (root.isPressed) return Theme.colors.surfaceActive
        if (root.isHovered) return Theme.colors.accentHover
        return Theme.colors.sliderForeground
      }
    }

    Rectangle {
      id: handle
      x: (track.width * root.progress) - (width / 2)
      anchors.verticalCenter: parent.verticalCenter
      
      width: Theme.sizes.sliderHandle
      height: Theme.sizes.sliderHandle
      radius: width / 2

      color: {
        if (root.disabled) return Theme.colors.sliderHandleDisabled
        if (root.isPressed) return Theme.colors.accent
        if (root.isHovered) return Theme.colors.sliderHandleHover
        return Theme.colors.sliderHandle
      }

      border.color: root.isPressed ? Theme.colors.borderActive : Theme.colors.border
      border.width: root.isHovered ? Theme.sizes.borderWidthActive : Theme.sizes.borderWidth
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    enabled: root.interactive && !root.disabled
    hoverEnabled: true
    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

    onPressed: updateValue(mouse.x)
    onPositionChanged: {
      if (pressed) updateValue(mouse.x)
    }

    function updateValue(mouseX) {
      let clampedX = Math.max(0, Math.min(track.width, mouseX))
      let percent = clampedX / track.width

      let newValue = root.minimum + (root.maximum - root.minimum) * percent
      root.value = newValue
      root.moved(newValue)
      root.interaction(newValue)
    }
  }
}
