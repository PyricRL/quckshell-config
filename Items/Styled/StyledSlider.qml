pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T

import "../../config.js" as Theme

T.Slider {
  id: root

  signal interaction(real value)

  implicitWidth: 200
  implicitHeight: 6

  from: 0
  to: 1
  stepSize: 0

  background: Rectangle {
    x: 0
    y: (root.height - height) / 2
    width: root.width
    height: Theme.sizes.sliderHeight
    radius: Theme.sizes.radiusSmall

    color: !root.enabled
      ? Theme.colors.surfaceDisabled
      : Theme.colors.surfaceInteractive
  }

  contentItem: Rectangle {
    x: 0
    y: (root.height - height) / 2
    width: root.visualPosition * root.width
    height: Theme.sizes.sliderHeight
    radius: Theme.sizes.radiusSmall

    color: {
      if (!root.enabled) return Theme.colors.contentDisabled
      if (root.pressed) return Theme.colors.accentHover
      if (root.hovered) return Theme.colors.accentHover
      return Theme.colors.accent
    }
  }

  handle: Rectangle {
    x: root.visualPosition * (root.width - width)
    y: (root.height - height) / 2

    width: Theme.sizes.sliderHandle / 2
    height: Theme.sizes.sliderHandle
    radius: Theme.sizes.radiusSmall

    color: {
      if (!root.enabled) return Theme.colors.contentDisabled
      if (root.pressed) return Theme.colors.contentActive
      if (root.hovered) return Theme.colors.contentHover
      return Theme.colors.contentInteractive
    }

    border.color: root.pressed ? Theme.colors.borderActive : Theme.colors.border
    border.width: root.hovered ? Theme.sizes.borderWidthActive : Theme.sizes.borderWidth
  }

  onMoved: {
    if (!root.pressed) {
      root.interaction(root.value)
    }
  }

  onPressedChanged: {
    if (!pressed) {
      root.interaction(root.value)
    }
  }
}
