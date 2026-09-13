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
    property bool gridMode: false

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

    readonly property int itemGridColumns: 3

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
        if (root.gridMode) {
            gridView.currentIndex = selectedIndex
        } else {
            listView.currentIndex = selectedIndex
        }
    }

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

    // Container box holding search input and view layouts
    StyledRect {
        id: container
        anchors.centerIn: parent
        width: 600
        height: 480
        radius: 6
        color: Colors.background

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
                            const modes = ["apps", "clipboard", "system", "wallpaper"]
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

                        // Navigation for GridView Mode
                        if (root.gridMode) {
                            if (event.key === Qt.Key_Right) {
                                if (filteredModel.count > 0) {
                                    root.selectedIndex = (root.selectedIndex + 1) % filteredModel.count
                                    gridView.currentIndex = root.selectedIndex
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Left) {
                                if (filteredModel.count > 0) {
                                    root.selectedIndex = (root.selectedIndex - 1 + filteredModel.count) % filteredModel.count
                                    gridView.currentIndex = root.selectedIndex
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Down) {
                                if (filteredModel.count > 0) {
                                    root.selectedIndex = Math.min(filteredModel.count - 1, root.selectedIndex + itemGridColumns)
                                    gridView.currentIndex = root.selectedIndex
                                }
                                event.accepted = true
                            } else if (event.key === Qt.Key_Up) {
                                if (filteredModel.count > 0) {
                                    root.selectedIndex = Math.max(0, root.selectedIndex - itemGridColumns)
                                    gridView.currentIndex = root.selectedIndex
                                }
                                event.accepted = true
                            }
                        } 
                        // Navigation for ListView Mode
                        else {
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
                            }
                        }

                        // Select Item
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
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
                        id: tabDelegate
                        property bool isCurrent: States.launcherMode === modelData.id
                        Layout.fillWidth: true
                        implicitHeight: 32
                        radius: 6
                        color: isCurrent ? Colors.primaryContainer : Colors.surfaceContainerLow

                        StyledText {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: tabDelegate.isCurrent ? Colors.primaryContainerOn : Colors.surfaceVariantOn
                            font.bold: tabDelegate.isCurrent
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

            // 1. Standard Results List (Apps, Clipboard, System)
            ListView {
                id: listView
                visible: !root.gridMode
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: filteredModel
                currentIndex: root.selectedIndex
                clip: true
                spacing: 4

                delegate: StyledRect {
                    id: listDelegate
                    property bool isSelected: listView.currentIndex === index

                    width: listView.width
                    implicitHeight: 48
                    radius: 6
                    color: listDelegate.isSelected ? Colors.primaryContainer : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        Item {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32

                            Image {
                                id: imgPreview
                                anchors.fill: parent
                                visible: model.icon !== undefined && model.icon !== "" && model.icon.startsWith("file://")
                                source: {
                                  if (visible) {
                                    if (model.icon) {
                                      return model.icon
                                    }
                                    return ""
                                  }
                                  return ""
                                }
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                                mipmap: true
                            }

                            IconImage {
                                anchors.fill: parent
                                visible: model.icon !== undefined && model.icon !== "" && !model.icon.startsWith("file://")
                                source: visible ? model.icon : ""
                            }

                            StyledSymbol {
                                anchors.centerIn: parent
                                iconSize: 20
                                icon: (model.symbol !== undefined && model.symbol !== "") ? model.symbol : "application"
                                color: listDelegate.isSelected ? Colors.primaryContainerOn : Colors.surfaceVariantOn
                                visible: (model.icon === undefined || model.icon === "")
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            StyledText {
                                text: model.name || ""
                                color: listDelegate.isSelected ? Colors.primaryContainerOn : Colors.surfaceOn
                                font.bold: true
                                font.pixelSize: 13
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            StyledText {
                                text: model.comment || model.exec || ""
                                color: listDelegate.isSelected ? ColorUtils.applyAlpha(Colors.primaryContainerOn, 0.75) : Colors.surfaceVariantOn
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

            // 2. Wallpaper Grid View (Activated for Wallpaper Mode)
            GridView {
                id: gridView
                visible: root.gridMode
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: filteredModel
                currentIndex: root.selectedIndex
                clip: true

                cellWidth: Math.floor(width / root.itemGridColumns)
                cellHeight: 130

                delegate: Item {
                    id: gridDelegate
                    width: gridView.cellWidth
                    height: gridView.cellHeight

                    readonly property bool isSelected: gridView.currentIndex === index

                    StyledRect {
                        anchors.fill: parent
                        anchors.margins: 4
                        radius: 6
                        color: gridDelegate.isSelected ? Colors.primaryContainer : Colors.surfaceContainerLow

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 4
                            spacing: 4

                            Item {
                              Layout.fillWidth: true
                              Layout.fillHeight: true
                              Image {
                                  anchors.fill: parent
                                  visible: model.icon !== undefined && model.icon !== ""
                                  source: {
                                    if (visible) {
                                      if (model.icon) {
                                        return model.icon
                                      }
                                      return ""
                                    }
                                    return ""
                                  }
                                  fillMode: Image.PreserveAspectCrop
                                  asynchronous: true
                                  cache: true
                                  mipmap: true
                              }

                              StyledSymbol {
                                anchors.centerIn: parent
                                visible: (model.icon === undefined || model.icon === "") && (model.symbol !== undefined && model.symbol !== "")
                                iconSize: 40
                                icon: model.symbol || ""
                                color: gridDelegate.isSelected ? Colors.primaryContainerOn : Colors.surfaceOn
                              }
                            }


                            StyledText {
                                Layout.fillWidth: true
                                text: model.name || ""
                                color: gridDelegate.isSelected ? Colors.primaryContainerOn : Colors.surfaceOn
                                font.pixelSize: 11
                                font.bold: gridDelegate.isSelected
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideMiddle
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: gridView.currentIndex = index
                            onClicked: root.itemSelected(filteredModel.get(index))
                        }
                    }
                }
            }
        }
    }
}
