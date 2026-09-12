import Quickshell
import Quickshell.Io

import qs.extras

Scope {
    id: root

    property var launcher

    function toggleModule(name) {
        if (States.currentActiveModule === name) {
            States.setActiveModule("")
        } else {
            States.setActiveModule(name)
        }
    }

    function showModule(name) {
        States.setActiveModule(name)
    }

    function hideModule(name) {
        if (States.currentActiveModule === name) {
            States.setActiveModule("")
        }
    }

    IpcHandler {
        target: "shell"

        // Close whatever window is currently active
        function closeAll() {
            States.setActiveModule("")
        }

        // Toggle launcher in standard "apps" mode
        function toggleLauncher() {
            if (States.currentActiveModule === "launcher" && States.launcherMode === "apps") {
                States.setActiveModule("")
            } else {
                States.launcherMode = "apps"
                States.setActiveModule("launcher")
            }
        }

        // Toggle launcher directly in "clipboard" mode
        function toggleClipboard() {
            if (States.currentActiveModule === "launcher" && States.launcherMode === "clipboard") {
                States.setActiveModule("")
            } else {
                States.launcherMode = "clipboard"
                States.setActiveModule("launcher")
            }
        }

        // Generic function to open the launcher in any custom mode
        function openLauncherMode(modeName: string) {
            States.launcherMode = modeName
            States.setActiveModule("launcher")
        }
    }
}
