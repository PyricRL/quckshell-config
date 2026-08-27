import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services
import qs.Items
import qs.Items.Styled

import "../../config.js" as Theme

Item {
  id: root

  property var model: []
  property int currentIndex: -1
  property string textRole: ""
  property string placeholderText: "Select..."

  property int dropdownWidth: 150
  property int itemHeight: 30
  property bool open: false

  readonly property var currentItem:
    currentIndex >= 0 && currentIndex < root.model.length
      ? root.model[currentIndex]
      : null
  readonly property string currentText:
    currentItem 
      ? root.textForItem(currentItem)
      : placeholderText

  signal selected(var item, int index)

  function textForItem(item) {
    if (!item) return ""
    if (textRole !== "") return item[textRole]
    return String(item)
  }

  implicitWidth: dropdown.width
  implicitHeight: dropdown.height

  // --- Main Dropdown Header ---
  Rectangle {
    id: dropdown

    width: root.dropdownWidth
    height: root.itemHeight
    radius: Theme.sizes.radiusSmall

    // Background State Logic
    color: {
      if (dropdownArea.pressed || root.open) return Theme.colors.surfaceActive
      if (dropdownArea.containsMouse) return Theme.colors.surfaceHover
      return Theme.colors.surfaceInteractive
    }

    // Border State Logic
    border.color: {
      if (root.open || dropdownArea.pressed) return Theme.colors.borderActive
      if (dropdownArea.containsMouse) return Theme.colors.borderHover
      return Theme.colors.border
    }
    border.width: Theme.sizes.borderWidth

    StyledText {
      anchors.centerIn: parent
      text: root.currentText
      small: true

      // Foreground State Logic
      color: {
        if (dropdownArea.pressed || root.open) return Theme.colors.contentActive
        if (dropdownArea.containsMouse) return Theme.colors.contentHover
        return Theme.colors.contentInteractive
      }
    }

    MouseArea {
      id: dropdownArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor

      onClicked: root.open = !root.open
    }
  }

  // --- Dropdown Menu List ---
  Rectangle {
    id: menu

    visible: root.open
    z: 100

    anchors.top: dropdown.bottom
    anchors.topMargin: Theme.sizes.spacingSmall
    anchors.left: dropdown.left

    width: dropdown.width
    height: (root.model.length * root.itemHeight) + (Theme.sizes.paddingSmall * 2)

    color: Theme.colors.backgroundDark
    radius: Theme.sizes.radiusMedium
    border.color: Theme.colors.borderActive
    border.width: Theme.sizes.borderWidth

    Column {
      anchors.fill: parent
      anchors.margins: Theme.sizes.paddingSmall
      spacing: Theme.sizes.spacingSmall

      Repeater {
        model: root.model

        delegate: Rectangle {
          id: itemDelegate

          required property var modelData
          required property int index

          readonly property bool isSelected: index === root.currentIndex

          width: menu.width - (Theme.sizes.paddingSmall * 2)
          height: root.itemHeight
          radius: Theme.sizes.radiusSmall

          // Delegate Surface State
          color: {
            if (itemArea.pressed) return Theme.colors.surfaceActive
            if (isSelected) return Theme.colors.surfaceActive
            if (itemArea.containsMouse) return Theme.colors.surfaceHover
            return "transparent"
          }

          StyledText {
            anchors.centerIn: parent
            text: root.textForItem(modelData)
            small: true

            // Delegate Content State
            color: {
              if (itemArea.pressed || isSelected) return Theme.colors.contentActive
              if (itemArea.containsMouse) return Theme.colors.contentHover
              return Theme.colors.contentInteractive
            }
          }

          MouseArea {
            id: itemArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
              root.currentIndex = index
              root.open = false
              root.selected(modelData, index)
            }
          }
        }
      }
    }
  }
}
