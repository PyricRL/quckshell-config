import QtQuick
import QtQuick.Layouts

import "content/"
import qs.modules.widgets

Item {
  RowLayout {
    id: centerRow

    anchors.centerIn: parent
    spacing: 0

    StyledGroup {
      id: centerGroup

      spacing: 0

      ClockModule {}

      WeatherModule {}
    }
  }

  RowLayout {
    id: leftRow

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    spacing: 4

    AppModule {}

    WorkspaceModule {}

    MediaModule {}
  }

  RowLayout {
    id: rightRow

    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter

    NotificationModule {}
  }
}
