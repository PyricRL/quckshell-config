import QtQuick
import QtQuick.Layouts

import qs.services
import qs.modules.widgets
import qs.themes

Item {
  id: weatherContainer

  Layout.alignment: Qt.AlignVCenter

  implicitWidth: bgRect.implicitWidth
  implicitHeight: bgRect.implicitHeight

  Rectangle {
    id: bgRect

    color: Colors.background

    implicitWidth: weatherLayout.implicitWidth + 2
    implicitHeight: 32

    radius: 6
  }

  RowLayout {
    id: weatherLayout
    anchors.centerIn: parent

    StyledText {
      text: Weather.icon
      font.family: "JetBrainsMono Nerd Font"
      fontSize: 32

      Layout.alignment: Qt.AlignVCenter
    }

    StyledText {
      id: weatherItem
      text: Weather.temp
      fontSize: 14
      bold: true

      Layout.alignment: Qt.AlignVCenter
    }
  }
}
