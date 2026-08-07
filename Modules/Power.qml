import Quickshell
import QtQuick

import qs.Items

Text {
  // text: "⏻"
  text: "⏻ :" + Visibilities.currentActiveModule

  MouseArea {
    anchors.fill: parent
    onClicked: function () {
      if (Visibilities.currentActiveModule === "powermenu") {
        Visibilities.setActiveModule("");
      } else {
        Visibilities.setActiveModule("powermenu")
      }
    }
  }
}
