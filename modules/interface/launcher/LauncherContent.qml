import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import qs.modules.widgets
import qs.themes
import qs.extras
import qs.modules.functions

Item {
    id: root

    ListModel { id: appModel }
    ListModel { id: filteredModel }

    property int selectedIndex: 0

    function addCustomCommands() {
      appModel.append({
        "name": "Lock Screen",
        "comment": "Lock desktop screen",
        "icon": "",
        "symbol": "",
        "exec": "",
        "category": "system",
      })
    }

    Component.onCompleted: { 
        addCustomCommands()
        appLoader.running = true
    }

    onVisibleChanged: {
        if (visible) {
            searchInput.text = ""
            updateFilter("")
            selectedIndex = 0
            searchInput.forceActiveFocus()
        }
    }

    Process {
        id: appLoader
        running: false
        command: ["bash", "-c", "$HOME/.config/quickshell/scripts/find-apps.sh"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = data.trim()
                if (!line) return

                const parts = line.split("|")
                if (parts.length >= 4) {
                    appModel.append({
                        "name": parts[0].trim(),
                        "comment": parts[1].trim(),
                        "icon": parts[2].trim(),
                        "symbol": "",
                        "exec": parts[3].trim(),
                        "category": "app"
                    })
                }
                root.updateFilter(searchInput.text)
            }
        }
    }

   function updateFilter(query) {
        filteredModel.clear()
        const rawQuery = query.trim()
        if (rawQuery === "") {
            // Show default application view when input is empty
            populateForCategory("app", "")
            return
        }

        const firstChar = rawQuery.charAt(0)
        const searchText = rawQuery.substring(1).toLowerCase().trim()

        // Map prefixes to categories
        switch (firstChar) {
            case "@":
                populateForCategory("app", searchText)
                break
            case "#":
                populateForCategory("file", searchText)
                break
            case ">":
                populateForCategory("action", searchText)
                break
            case "?":
                populateForCategory("web", searchText)
                break
            case ":":
                populateForCategory("system", searchText)
                break
            case "!":
                populateForCategory("shell", searchText)
                break
            case "=":
                populateForCategory("calculator", searchText)
                break
            case "%":
                populateForCategory("settings", searchText)
                break
            default:
                // Standard search without prefix (defaults to apps)
                populateForCategory("app", rawQuery.toLowerCase().trim())
                break
        }
    }

    function populateForCategory(categoryName, queryText) {
        let exactMatches = []
        let prefixMatches = []
        let substringMatches = []

        for (let i = 0; i < appModel.count; i++) {
            const item = appModel.get(i)
            
            // Match only items in the active category
            if (item.category !== categoryName) continue

            const nameLower = item.name.toLowerCase()
            const commentLower = item.comment ? item.comment.toLowerCase() : ""

            if (queryText === "" || nameLower === queryText) {
                exactMatches.push(item)
            } else if (nameLower.startsWith(queryText)) {
                prefixMatches.push(item)
            } else if (nameLower.includes(queryText) || commentLower.includes(queryText)) {
                substringMatches.push(item)
            }
        }

        const sortedResults = exactMatches.concat(prefixMatches, substringMatches)
        for (let i = 0; i < sortedResults.length; i++) {
            filteredModel.append(sortedResults[i])
        }

        selectedIndex = filteredModel.count > 0 ? 0 : -1
        listView.currentIndex = selectedIndex
    } 

    function launch(execStr) {
        if (!execStr) return
        Quickshell.execDetached(["bash", "-c", execStr + " &"])
        States.setActiveModule("")
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Search Bar Input Container
        StyledRect {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            radius: 8
            color: Colors.surfaceContainerLow

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    placeholderText: "Search applications..."
                    placeholderTextColor: Colors.surfaceVariantOn
                    color: Colors.backgroundOn
                    font.pixelSize: 14
                    background: null
                    focus: true

                    onTextChanged: root.updateFilter(text)

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Down || (event.key === Qt.Key_Tab && !(event.modifiers & Qt.ShiftModifier))) {
                            root.selectedIndex = Math.min(root.selectedIndex + 1, filteredModel.count - 1)
                            listView.currentIndex = root.selectedIndex
                            listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier))) {
                            root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
                            listView.currentIndex = root.selectedIndex
                            listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            // embed custom key commands here
                            if (text === ":echo") {
                              console.log("Echo")
                              States.setActiveModule("")
                              event.accepted = true
                              return
                            }
                            if (filteredModel.count > 0 && root.selectedIndex >= 0) {
                                root.launch(filteredModel.get(root.selectedIndex).exec)
                            }
                            event.accepted = true
                        }
                    }
                }
            }
        }

        // Applications View
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: filteredModel
            currentIndex: root.selectedIndex
            clip: true
            spacing: 4

            delegate: StyledRect {
                id: delegateRect

                property bool isSelected: listView.currentIndex === index

                width: listView.width
                implicitHeight: 52
                radius: 6
                color: isSelected ? Colors.primaryContainer : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    // Icon Image via Quickshell.Widgets
                    IconImage {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        visible: model.icon !== ""
                        source: model.icon
                    }

                    // Fallback symbol if icon string is empty
                    StyledSymbol {
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        iconSize: 24
                        icon: model.symbol !== "" ? model.symbol : "application"
                        fill: model.symbol !== "" ? 1 : 0
                        color: isSelected ? Colors.primaryContainerOn : Colors.surfaceVariantOn
                        visible: model.icon === ""
                    }

                    // Text Details
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        StyledText {
                            text: name
                            color: isSelected ? Colors.primaryContainerOn : Colors.surfaceOn
                            font.bold: true
                            font.pixelSize: 13
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        StyledText {
                            text: comment !== "" ? comment : exec
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
                    onClicked: root.launch(exec)
                }
            }
        }
    }
}

