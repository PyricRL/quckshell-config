import QtQuick
import QtQuick.Layouts

import qs.services
import qs.themes
import qs.modules.widgets

Item {
  id: clockContainer

  property string timeFormat: "h:mm AP"
  property string dateFormat: "dddd, MMMM d"

  Layout.alignment: Qt.AlignVCenter
  implicitWidth: Math.max(timeItem.implicitWidth, dateItem.implicitWidth) + 20
  implicitHeight: 32

  Rectangle {
    id: bgRect

    color: Colors.background

    implicitWidth: dateItem.implicitWidth + 20
    implicitHeight: 32

    radius: 6
  }

  Column {
    id: clockColumn

    anchors.fill: parent

    spacing: -3

    StyledText {
      id: timeItem

      text: Time.format(clockContainer.timeFormat)
      fontSize: 14
      bold: true
    }

    StyledText {
      id: dateItem

      text: Time.format(clockContainer.dateFormat)
      fontSize: 12
    }
  }
}
