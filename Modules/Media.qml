import qs.Items

import "MiddleMenu/" as Menu

MiddleMenu {
  Menu.ClosedMenu {
    anchors.fill: parent
    visible: Visibilities.middleMenuState === "closed"
  }

  Menu.ExpandedMenu {
    anchors.fill: parent
    visible: Visibilities.middleMenuState === "hover" || Visibilities.middleMenuState === "pinhover"
  }

  Menu.PinnedMenu {
    anchors.fill: parent
    visible: Visibilities.middleMenuState === "pin"
  }
}
