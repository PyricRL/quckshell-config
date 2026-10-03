import Quickshell
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Layouts

import qs.modules.widgets
import qs.themes

Item {
    id: root

    anchors.fill: parent
    anchors.right: parent.right
    anchors.top: parent.top

    property bool pipewireReady: Pipewire.ready
    property var nodes: Pipewire.nodes
    property var defaultSink: Pipewire.defaultAudioSink
    property var defaultSource: Pipewire.defaultAudioSource

    PwObjectTracker {
        id: pwObjectTracker
        objects: nodes
    }

    Component.onCompleted: {
        if (pipewireReady) {
            nodes = Pipewire.nodes;
        }
    }

    ColumnLayout {
        id: layout
        Repeater {
            model: nodes || []

            StyledText {
                text: modelData ? modelData.nickname ? modelData.nickname : modelData.name : "Unnamed node"
            }
        }
    }
}
