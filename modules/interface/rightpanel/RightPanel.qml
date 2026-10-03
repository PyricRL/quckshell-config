import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.extras

PanelWindow {
    id: root

    visible: States.currentActiveModule === "rightmenu"

    WlrLayershell.exclusionMode: ExclusionMode.Normal

    anchors {
        top: true
        right: true
        bottom: true
    }

    width: 500

    color: "transparent"

    margins {
        left: 3
        right: 3
        bottom: 3
        top: 3
    }

    RightPanelContent {
        anchors.fill: parent
    }
}
