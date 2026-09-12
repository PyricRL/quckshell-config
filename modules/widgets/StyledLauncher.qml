import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.themes

Item {
    id: root

    property ListModel sourceModel
    property string placeholderText: "Search..."
    property int selectedIndex: 0

    // Custom Signal
    signal itemSelected(var item)

    ListModel { id: displayModel }

    function refreshFilter(query) {
        displayModel.clear()
        if (!sourceModel) return

        const q = (query || "").toLowerCase().trim()
        for (let i = 0; i < sourceModel.count; i++) {
            const item = sourceModel.get(i)
            const nameLower = (item.name || "").toLowerCase()
            const commentLower = (item.comment || "").toLowerCase()

            if (q === "" || nameLower.includes(q) || commentLower.includes(q)) {
                displayModel.append(item)
            }
        }

        selectedIndex = displayModel.count > 0 ? 0 : -1
        listView.currentIndex = selectedIndex
    }

    onSourceModelChanged: refreshFilter(searchInput.text)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        StyledRect {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
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

                onTextChanged: root.refreshFilter(text)

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Down || (event.key === Qt.Key_Tab && !(event.modifiers & Qt.ShiftModifier))) {
                        if (displayModel.count > 0) {
                            root.selectedIndex = (root.selectedIndex + 1) % displayModel.count
                            listView.currentIndex = root.selectedIndex
                            listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                        }
                        event.accepted = true
                    } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier))) {
                        if (displayModel.count > 0) {
                            root.selectedIndex = (root.selectedIndex - 1 + displayModel.count) % displayModel.count
                            listView.currentIndex = root.selectedIndex
                            listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                        }
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        if (displayModel.count > 0 && root.selectedIndex >= 0 && root.selectedIndex < displayModel.count) {
                            const selectedItem = displayModel.get(root.selectedIndex)
                            console.log("[StyledLauncher] Executing via Enter:", selectedItem.name, selectedItem.exec)
                            root.itemSelected(selectedItem)
                        } else {
                            console.warn("[StyledLauncher] Enter pressed but selection is invalid. Index:", root.selectedIndex)
                        }
                        event.accepted = true
                    }
                }
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: displayModel
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

                    Item {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28

                        IconImage {
                            anchors.fill: parent
                            visible: model.icon !== undefined && model.icon !== ""
                            source: model.icon !== undefined ? model.icon : ""
                        }

                        StyledSymbol {
                            anchors.centerIn: parent
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            iconSize: 24
                            icon: (model.symbol !== undefined && model.symbol !== "") ? model.symbol : "application"
                            color: isSelected ? Colors.primaryContainerOn : Colors.surfaceVariantOn
                            visible: model.icon === undefined || model.icon === ""
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
                    onClicked: {
                        const clickedItem = displayModel.get(index)
                        console.log("[StyledLauncher] Executing via Click:", clickedItem.name, clickedItem.exec)
                        root.itemSelected(clickedItem)
                    }
                }
            }
        }
    }
}
