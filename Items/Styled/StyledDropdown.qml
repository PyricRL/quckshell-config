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
    if (!item) {
      return ""
    }

    if (textRole !== "") {
      return item[textRole]
    }

    return String(item)
  }

  implicitWidth: dropdown.width
  implicitHeight: dropdown.height

  Rectangle {
    id: dropdown

    width: root.dropdownWidth
    height: 30
    color: Theme.colors.backgroundDark
    radius: Theme.sizes.radiusSmall
    border.color: Theme.colors.accent
    border.width: Theme.sizes.borderWidth

    StyledText {
      anchors.centerIn: parent

      text: root.currentText
      small: true
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor

      onClicked: root.open = !root.open
    }
  }

  Rectangle {
    id: menu

    visible: root.open
    z: 100

    anchors.top: dropdown.bottom
    anchors.left: dropdown.left

    width: dropdown.width
    height: root.model.length * root.itemHeight

    color: Theme.colors.backgroundDark
    border.color: Theme.colors.accent
    border.width: Theme.sizes.borderWidth

    Column {
      anchors.fill: parent
      spacing: Theme.sizes.spacingSmall

      Repeater {
        model: root.model

        delegate: Rectangle {
          required property var modelData
          required property int index

          width: menu.width
          height: root.itemHeight

          color: index === root.currentIndex
            ? Theme.colors.muted
            : "transparent"

          StyledText {
            anchors.centerIn: parent
            text: root.textForItem(modelData)
            small: true
          }

          MouseArea {
            anchors.fill: parent
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
