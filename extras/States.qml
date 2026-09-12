pragma Singleton
import QtQuick

QtObject {
    property string currentActiveModule: ""
    property string launcherMode: "apps"

    function setActiveModule(name: string) {
        currentActiveModule = name
    }

    function setLauncherMode(mode: string) {
      launcherMode = mode
    }

    function toggleModule(name: string) {
        if (currentActiveModule === name) {
            currentActiveModule = ""
        } else {
            currentActiveModule = name
        }
    }

    function toggleLauncherMode(name: string) {
      if (currentActiveModule === "launcher" && launcherMode === mode) {
        currentActiveModule = ""
      } else {
        launcherMode = mode
        currentActiveModule = "launcher"
      }
    }
}
