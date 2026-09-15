import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.themes
import qs.services
import qs.modules.widgets

Rectangle {
  id: root

  property var rawNotif: null
  property string title: "No Title"
  property string content: "No Content"
  property string image: ""
  property bool tracked: true

  Layout.fillWidth: true

  property bool hovered: mouseArea.containsMouse
  property bool clicked: mouseArea.containsPress

  property color bg: Colors.background
  property color hover_bg: Qt.lighter(bg, 1.1)
  property color pressed_bg: Qt.darker(bg, 1.2)

  property color background_color: {
      if (clicked)
          return Qt.darker(bg, 1.2)

      if (hovered)
          return Qt.lighter(bg, 1.1)

      return bg
  }

  color: background_color

  implicitHeight: Math.max(content.implicitHeight + 30, 80)

  radius: 6

  RowLayout {
    id: content

    ClippingRectangle {
      width: 50
      height: 50
      radius: 6
      clip: true

      Image {
        anchors.fill: parent
        source: root.image
        fillMode: Image.PreserveAspectCrop
        smooth: true
      }
    }

    ColumnLayout {
      id: text

      StyledText {
        text: root.title
        bold: true
        Layout.fillWidth: true
      }

      StyledText {
        text: root.content
        bold: true
        Layout.fillWidth: true
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      root.rawNotif.notification.tracked = false
      root.rawNotif.popup = false
      root.rawNotif?.notification.dismiss()
    }
  }
}
