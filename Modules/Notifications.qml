import Quickshell
import QtQuick

import qs.Items

Text {
  text: " "

  MouseArea {
    anchors.fill: parent
    
    onClicked: function () {
      if (Visibilities.currentActiveModule === "notificationmenu") {
        Visibilities.setActiveModule("");
      } else {
        Visibilities.setActiveModule("notificationmenu")
      }
    }
  }
}
