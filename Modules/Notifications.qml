import Quickshell
import QtQuick

import qs.Items
import qs.Items.Styled

StyledButton {
  text: ""
  small: true

  accentBg: false
  accentText: true

  onClicked: function () {
    if (Visibilities.currentActiveModule === "informationmenu") {
      Visibilities.setActiveModule("");
    } else {
      Visibilities.setActiveModule("informationmenu")
    }
  }
}
