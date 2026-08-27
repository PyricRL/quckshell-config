pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T

T.Slider {
  id: root

  property color foregroundColor: "#999999"
  property color backgroundColor: "#444444"
  property real barHeight: 6
  property real handleWidth: 10

  signal interaction(real value)

  implicitWidth: 200
  implicitHeight: 6

  from: 0
  to: 1
  stepSize: 0

  background: Rectangle {
    x: 0
    y: (root.height - root.barHeight) / 2
    width: root.width
    height: root.barHeight
    radius: height / 2
    color: root.backgroundColor
  }

  contentItem: Rectangle {
    x: 0
    y: (root.height - root.barHeight) / 2
    width: root.visualPosition * root.width
    height: root.barHeight
    radius: height / 2
    color: root.foregroundColor
  }

  handle: Rectangle {
    x: root.visualPosition * (root.width - width)
    y: (root.height - height) / 2

    width: root.handleWidth
    height: root.height
    radius: width / 2
    color: root.foregroundColor
  }

  onMoved: {
    if (!root.pressed) {
      root.interaction(root.value)
    }
  }

  onPressedChanged: {
    if (!pressed)
      root.interaction(root.value)
  }
}
