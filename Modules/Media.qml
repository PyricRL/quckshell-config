import qs.Items

import "MiddleMenu/" as Menu

import "../config.js" as Theme

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
    anchors.margins: Theme.sizes.spacingLarge
    anchors.fill: parent
    visible: Visibilities.middleMenuState === "pin"
  }
}
