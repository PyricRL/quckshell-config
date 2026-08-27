import Quickshell
import QtQuick

import qs.Items
import qs.Items.Styled

StyledButton {
  text: "⏻"
  small: true

  accentBg: false
  accentText: true

  onClicked: function () {
    if (Visibilities.currentActiveModule === "powermenu") {
      Visibilities.setActiveModule("");
    } else {
      Visibilities.setActiveModule("powermenu")
    }
  }
}
