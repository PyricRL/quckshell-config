pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
  id: root

  property string currentActiveModule: ""
  property string currentActiveTab: ""

  function setActiveModule(modulename) {
    if (modulename) {
      currentActiveModule = modulename;
    } else {
      currentActiveModule = "";
    }
  }

  function setActiveTab(tabname) {
    if (tabname) {
      currentActiveTab = tabname;
    } else {
      currentActiveTab = "";
    }
  }

  property bool middleMenuPinned: false
  property bool middleMenuHovered: false

  function setMiddleMenuHovered(value) {
    middleMenuHovered = value
  }

  function toggleMiddleMenuPinned() {
    middleMenuPinned = !middleMenuPinned
  }

  readonly property string middleMenuState: {
    if (middleMenuPinned) {
      if (middleMenuHovered) {
        return "pinhover"
      } else {
        return "pin"
      }
    } else if (middleMenuHovered) {
      return "hover"
    } else {
      return "closed"
    }
  }
}
