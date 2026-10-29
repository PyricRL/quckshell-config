import Quickshell
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.modules.widgets
import qs.themes

Item {
    id: root

    Layout.fillWidth: true
    implicitHeight: bgRect.height

    property bool pipewireReady: Pipewire.ready
    property var nodes: Pipewire.nodes

    property var defaultSink: Pipewire.defaultAudioSink
    property var defaultSource: Pipewire.defaultAudioSource

    // Track indices separately for sinks and sources
    property int defaultSinkIndex: 0
    property int defaultSourceIndex: 0

    ListModel {
        id: sinksModel
    }
    ListModel {
        id: sourcesModel
    }

    PwObjectTracker {
        id: pwObjectTracker
        objects: nodes
    }

    function updateDevices() {
        sinksModel.clear();
        sourcesModel.clear();

        let foundSinkIndex = 0;
        let sinkCount = 0;

        let foundSourceIndex = 0;
        let sourceCount = 0;

        if (nodes && nodes.values) {
            for (let i = 0; i < nodes.values.length; i++) {
                let n = nodes.values[i];
                if (!n || !n.audio)
                    continue;

                let deviceName = n.description || n.nickname;
                if (!deviceName || deviceName.trim() === "") {
                    continue;
                }

                let itemData = {
                    text: deviceName,
                    value: n
                };

                if (n.isSink === true) {
                    sinksModel.append(itemData);
                    if (defaultSink && n === defaultSink) {
                        foundSinkIndex = sinkCount;
                    }
                    sinkCount++;
                } else if (n.isSink === false) {
                    // Filter out non-audio-input nodes if necessary (e.g., MIDI)
                    // Check if properties indicate an audio source/capture device
                    sourcesModel.append(itemData);
                    if (defaultSource && n === defaultSource) {
                        foundSourceIndex = sourceCount;
                    }
                    sourceCount++;
                }
            }
        }

        defaultSinkIndex = foundSinkIndex;
        defaultSourceIndex = foundSourceIndex;
    }
    onDefaultSinkChanged: updateDevices()
    onDefaultSourceChanged: updateDevices()
    onNodesChanged: updateDevices()
    onPipewireReadyChanged: {
        if (pipewireReady) {
            nodes = Pipewire.nodes;
            updateDevices();
        }
    }

    Component.onCompleted: {
        if (pipewireReady) {
            updateDevices();
        }
    }

    Rectangle {
        id: bgRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
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
                text: "Default Devices"
                bold: true
            }

            RowLayout {
                spacing: 10
                StyledDropdown {
                    id: sinkDropdown
                    implicitWidth: bgRect.width - 24
                    model: sinksModel
                    textBefore: " "
                    initialIndex: root.defaultSinkIndex
                    onItemSelected: value => {
                        Pipewire.preferredDefaultAudioSink = value;
                    }
                }
            }

            StyledSlider {
                id: volumeSlider

                startValue: 0
                endValue: 125   // Represents 0% to 125%

                PwObjectTracker {
                    objects: [Pipewire.defaultAudioSink]
                }

                readonly property var sink: Pipewire.defaultAudioSink?.audio

                enabled: Pipewire.ready && sink !== null

                // Scale Pipewire's 0.0 - 1.25 range up to 0 - 125 for the slider
                value: sink ? sink.volume * 100 : 0.0

                onMoved: {
                    if (sink) {
                        // Scale the slider's 0 - 125 value back down to Pipewire's 0.0 - 1.25 range
                        sink.volume = value / 100;
                    }
                }
            }

            RowLayout {
                spacing: 10
                StyledDropdown {
                    id: sourceDropdown
                    implicitWidth: bgRect.width - 24
                    model: sourcesModel
                    textBefore: ""
                    textBeforeSize: 18
                    initialIndex: root.defaultSourceIndex
                    onItemSelected: value => {
                        Pipewire.preferredDefaultAudioSource = value;
                    }
                }
            }

            StyledSlider {
                id: micSlider

                startValue: 0
                endValue: 125   // Represents 0% to 125%

                PwObjectTracker {
                    objects: [Pipewire.defaultAudioSource]
                }

                readonly property var source: Pipewire.defaultAudioSource?.audio

                enabled: Pipewire.ready && source !== null

                // Scale Pipewire's 0.0 - 1.25 range up to 0 - 125 for the slider
                value: source ? source.volume * 100 : 0.0

                onMoved: {
                    if (source) {
                        // Scale the slider's 0 - 125 value back down to Pipewire's 0.0 - 1.25 range
                        source.volume = value / 100;
                    }
                }
            }
        }
    }
}
