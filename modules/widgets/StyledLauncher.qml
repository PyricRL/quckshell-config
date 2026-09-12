import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

import qs.themes
import qs.modules.functions
import qs.modules.widgets
import qs.extras

PanelWindow {
    id: root

    // Configuration API
    property ListModel sourceModel
    property string placeholderText: "Search..."
    property int selectedIndex: 0
    property bool active: false

    // Control window visibility directly
    visible: active
    WlrLayershell.keyboardFocus: active ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    // Custom Signals
    signal itemSelected(var item)
    signal closeRequested()

    ListModel { id: filteredModel }

    // Timer to debounce filter updates and prevent UI freeze
    Timer {
        id: filterDebounceTimer
        interval: 50
        repeat: false
        onTriggered: root.updateFilter(searchInput.text)
    }

    function updateFilter(query) {
        filteredModel.clear()
        if (!sourceModel) return

        const q = (query || "").toLowerCase().trim()
        for (let i = 0; i < sourceModel.count; i++) {
            const item = sourceModel.get(i)
            const nameLower = (item.name || "").toLowerCase()
            const commentLower = (item.comment || "").toLowerCase()

            if (q === "" || nameLower.includes(q) || commentLower.includes(q)) {
                filteredModel.append(item)
            }
        }

        selectedIndex = filteredModel.count > 0 ? 0 : -1
        listView.currentIndex = selectedIndex
    }

    // Safely observe model changes with debouncing
    Connections {
        target: sourceModel
        ignoreUnknownSignals: true
        function onRowsInserted() { filterDebounceTimer.restart() }
        function onModelReset() { filterDebounceTimer.restart() }
    }

    onSourceModelChanged: updateFilter(searchInput.text)

    onVisibleChanged: {
        if (visible) {
            searchInput.text = ""
            updateFilter("")
            searchInput.forceActiveFocus()
        }
    }

    // Dismiss window when clicking the background overlay
    MouseArea {
        anchors.fill: parent
        onClicked: root.closeRequested()
    }

    // Container box holding search input and list view
    StyledRect {
        id: container
        anchors.centerIn: parent
        width: 600
        height: 480
        radius: 6
        color: Colors.background

        // Prevent background clicks inside the card from closing the window
        MouseArea {
            anchors.fill: parent
            onClicked: (mouse) => mouse.accepted = true
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            // Search Bar Input
            StyledRect {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                radius: 8
                color: Colors.surfaceContainerLow

                TextField {
                    id: searchInput
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    placeholderText: root.placeholderText
                    placeholderTextColor: Colors.surfaceVariantOn
                    color: Colors.backgroundOn
                    font.pixelSize: 14
                    background: null
                    focus: true

                    onTextChanged: root.updateFilter(text)

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Tab && (event.modifiers & Qt.ControlModifier)) {
                            const modes = ["apps", "clipboard", "system"]
                            let idx = modes.indexOf(States.launcherMode)
                            if (event.modifiers & Qt.ShiftModifier) {
                                idx = (idx - 1 + modes.length) % modes.length
                            } else {
                                idx = (idx + 1) % modes.length
                            }
                            States.setLauncherMode(modes[idx])
                            event.accepted = true
                            return
                        }

                        if (event.key === Qt.Key_Down || (event.key === Qt.Key_Tab && !(event.modifiers & Qt.ShiftModifier))) {
                            if (filteredModel.count > 0) {
                                root.selectedIndex = (root.selectedIndex + 1) % filteredModel.count
                                listView.currentIndex = root.selectedIndex
                                listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                            }
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier))) {
                            if (filteredModel.count > 0) {
                                root.selectedIndex = (root.selectedIndex - 1 + filteredModel.count) % filteredModel.count
                                listView.currentIndex = root.selectedIndex
                                listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                            }
                            event.accepted = true
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (filteredModel.count > 0 && root.selectedIndex >= 0 && root.selectedIndex < filteredModel.count) {
                                root.itemSelected(filteredModel.get(root.selectedIndex))
                            }
                            event.accepted = true
                        } else if (event.key === Qt.Key_Escape) {
                            root.closeRequested()
                            event.accepted = true
                        }
                    }
                }
            }

            // Tab Bar Switcher
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: [
                        { id: "apps", label: "Applications" },
                        { id: "clipboard", label: "Clipboard" },
                        { id: "system", label: "System Actions" },
                        { id: "wallpaper", label: "Wallpapers"},
                    ]

                    delegate: StyledRect {
                        property bool isCurrent: States.launcherMode === modelData.id
                        Layout.fillWidth: true
                        implicitHeight: 32
                        radius: 6
                        color: isCurrent ? Colors.primaryContainer : Colors.surfaceContainerLow

                        StyledText {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: isCurrent ? Colors.primaryContainerOn : Colors.surfaceVariantOn
                            font.bold: isCurrent
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                States.setLauncherMode(modelData.id)
                                searchInput.forceActiveFocus()
                            }
                        }
                    }
                }
            }

            // Results List
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: filteredModel
                currentIndex: root.selectedIndex
                clip: true
                spacing: 4

                delegate: StyledRect {
                    property bool isSelected: listView.currentIndex === index

                    width: listView.width
                    implicitHeight: 48
                    radius: 6
                    color: isSelected ? Colors.primaryContainer : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        Item {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32

                            // Renders file-path image previews (e.g., file:///tmp/cliphist-previews/1.png)
                            Image {
                                id: imgPreview
                                anchors.fill: parent
                                visible: model.icon !== undefined && model.icon !== "" && model.icon.startsWith("file://")
                                source: visible ? model.icon : ""
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                                mipmap: true
                            }

                            // Renders standard desktop application icons (e.g., "firefox")
                            IconImage {
                                anchors.fill: parent
                                visible: model.icon !== undefined && model.icon !== "" && !model.icon.startsWith("file://")
                                source: visible ? model.icon : ""
                            }

                            // Renders symbol fallback when no icon/preview path is provided
                            StyledSymbol {
                                anchors.centerIn: parent
                                iconSize: 20
                                icon: (model.symbol !== undefined && model.symbol !== "") ? model.symbol : "application"
                                color: isSelected ? Colors.primaryContainerOn : Colors.surfaceVariantOn
                                visible: (model.icon === undefined || model.icon === "")
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            StyledText {
                                text: model.name || ""
                                color: isSelected ? Colors.primaryContainerOn : Colors.surfaceOn
                                font.bold: true
                                font.pixelSize: 13
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            StyledText {
                                text: model.comment || model.exec || ""
                                color: isSelected ? ColorUtils.applyAlpha(Colors.primaryContainerOn, 0.75) : Colors.surfaceVariantOn
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                visible: text !== ""
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: listView.currentIndex = index
                        onClicked: root.itemSelected(filteredModel.get(index))
                    }
                }
            }
        }
    }
}
