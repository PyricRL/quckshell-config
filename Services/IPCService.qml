import Quickshell
import Quickshell.Io

import "../Items/" as Items

Scope {
  id: root

  property var middleIsland

  function toggleModule(name) {
    if (Items.Visibilities.currentActiveModule === name) {
      Items.Visibilities.setActiveModule("")
    } else {
      Items.Visibilities.setActiveModule(name)
    }
  }

  function showModule(name) {
    Items.Visibilities.setActiveModule(name)
  }

  function hideModule(name) {
    if (Items.Visibilities.currentActiveModule === name) {
      Items.Visibilities.setActiveModule("")
    }
  }

  IpcHandler {
    target: "shell"

    function toggleNotifications() {
      root.toggleModule("notificationmenu")
    }

    function togglePower() {
      root.toggleModule("powermenu")
    }

    function toggleMiddle() {
      if (root.middleIsland) {
        root.middleIsland.toggleMiddleMenu()
      }
    }

    function closeAll() {
      Items.Visibilities.setActiveModule("")
    }
  }
}
