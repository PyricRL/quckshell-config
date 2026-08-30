pragma Singleton
pragma ComponentBehavior: Bound

import Niri
import QtQuick
import Quickshell

Singleton {
  id: root

  Niri {
    id: niri
    Component.onCompleted: connect()
    onConnected: console.info("Niri Connected")
  }

  property alias workspaces: niri.workspaces

  function focusWorkspace(id) {
    niri.focusWorkspaceById(id)
  }
}
