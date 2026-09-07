import QtQuick
import QtQuick.Layouts

import "content/"
import qs.modules.widgets

Item {
  Row {
    id: centerRow

    anchors.centerIn: parent
    spacing: 0


    StyledGroup {
      id: centerGroup
      anchors.centerIn: parent
      spacing: 0

      ClockModule {}

      WeatherModule {}
    }
  }

  RowLayout {
    id: leftRow

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
  }
}
