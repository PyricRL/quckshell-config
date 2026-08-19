import Quickshell
import QtQuick

import qs.Items
import qs.Items.Styled

StyledButton {
  text: "⏻"
  small: true

  onClicked: function () {
    if (Visibilities.currentActiveModule === "powermenu") {
      Visibilities.setActiveModule("");
    } else {
      Visibilities.setActiveModule("powermenu")
    }
  }
}
