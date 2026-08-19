import Quickshell
import QtQuick

import qs.Items
import qs.Items.Styled

StyledButton {
  text: ""
  muted: false
  small: true

  onClicked: function () {
    if (Visibilities.currentActiveModule === "informationmenu") {
      Visibilities.setActiveModule("");
    } else {
      Visibilities.setActiveModule("informationmenu")
    }
  }
}
