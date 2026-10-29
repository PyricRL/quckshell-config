import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Pipewire

import qs.themes
import qs.modules.widgets

Item {
    id: root

    Layout.fillWidth: true
    implicitHeight: bgRect.height

    property bool pipewireReady: Pipewire.ready
    property var nodes: Pipewire.nodes

    ListModel {
        id: appModel
    }

    PwObjectTracker {
        id: pwObjectTracker
        objects: nodes
    }

    function updateApplications() {
        appModel.clear();

        if (nodes && nodes.values) {
            for (let i = 0; i < nodes.values.length; i++) {
                let n = nodes.values[i];
                if (!n || !n.audio || !n.isStream) {
                    continue;
                }

                let appName = (n.property && n.property.application && n.property.application.name) ? n.property.application.name : (n.description || "Audio Stream");

                let itemData = {
                    text: appName,
                    value: n
                };

                appModel.append(itemData);
            }
        }
    }

    onNodesChanged: updateApplications()
    onPipewireReadyChanged: {
        if (pipewireReady) {
            nodes = Pipewire.nodes;
            updateApplications();
        }
    }
    Component.onCompleted: {
        if (pipewireReady) {
            updateApplications();
        }
    }

    Rectangle {
        id: bgRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        // Automatically scales height based on title + the list of active apps
        height: colLayout.height + 24

        color: Colors.surfaceContainerLow
        radius: 6

        ColumnLayout {
            id: colLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            spacing: 12

            StyledText {
                text: "Applications"
                bold: true
            }

            // Renders each application stream dynamically
            ListView {
                id: appListView
                Layout.fillWidth: true
                implicitHeight: contentHeight
                interactive: false
                model: appModel
                spacing: 10

                delegate: RowLayout {
                    width: appListView.width
                    spacing: 10

                    StyledText {
                        text: model.text
                        Layout.fillWidth: true
                    }

                    StyledSlider {
                        id: appSlider
                        startValue: 0
                        endValue: 125
                        Layout.preferredWidth: 140

                        readonly property var audioStream: model.value?.audio
                        enabled: audioStream !== null
                        value: audioStream ? audioStream.volume * 100 : 0.0

                        onMoved: {
                            if (audioStream) {
                                audioStream.volume = value / 100;
                            }
                        }
                    }
                }
            }
        }
    }
}
