pragma Singleton
import QtQuick

QtObject {
    property string currentActiveModule: ""
    property string launcherMode: "apps"

    function setActiveModule(name: string) {
        currentActiveModule = name
    }

    function toggleModule(name: string) {
        if (currentActiveModule === name) {
            currentActiveModule = ""
        } else {
            currentActiveModule = name
        }
    }
}
