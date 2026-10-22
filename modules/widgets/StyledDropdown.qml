import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.themes
import qs.modules.functions

ComboBox {
    id: root
    width: 200
    implicitHeight: 40

    property string defaultText: "Select an option"
    property string currentIcon: ""
    property int initialIndex: 1 // Default to -1 so we know if it's set
    property string textBefore: ""
    property int textBeforeSize: 14

    signal itemSelected(var value)

    textRole: "text"
    valueRole: "value"

    // Whenever the model gets populated/changed, if we have an initial index target, apply it
    onModelChanged: {
        updateInitialSelection();
    }

    onCountChanged: {
        updateInitialSelection();
    }

    onInitialIndexChanged: {
        updateInitialSelection();
    }

    function updateInitialSelection() {
        if (initialIndex >= 0 && count > initialIndex && currentIndex !== initialIndex) {
            currentIndex = initialIndex;
        }
    }

    onCurrentIndexChanged: {
        if (currentIndex >= 0 && currentIndex < count) {
            var selectedItem = itemAt(currentIndex);
            if (selectedItem) {
                if (selectedItem.icon !== undefined) {
                    currentIcon = selectedItem.icon;
                }
                itemSelected(selectedItem.value);
            }
        }
    }

    background: Rectangle {
        color: Colors.primary
        radius: 6
        height: root.height
    }

    contentItem: RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8
        height: root.height

        Text {
            Layout.maximumWidth: 20
            Layout.minimumWidth: 20
            text: root.textBefore
            visible: root.textBefore !== ""
            color: Colors.primaryOn
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
        }

        Text {
            text: root.displayText !== "" ? root.displayText : root.defaultText
            color: Colors.primaryOn
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }

    popup: Popup {
        y: root.height + 4
        width: root.width
        height: Math.min(contentItem.contentHeight + 10, 250)
        modal: false
        focus: true

        background: Rectangle {
            color: Qt.lighter(Colors.background, 1.1)
            radius: 6
        }

        contentItem: ListView {
            id: listView
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
            interactive: contentHeight > height

            delegate: StyledButton {
                required property int index
                required property var modelData

                width: popup.width
                height: 40
                text: modelData.text !== undefined ? modelData.text : ""
                icon: modelData.icon !== undefined ? modelData.icon : ""
                variant: "background"

                onClicked: {
                    root.currentIndex = index;
                    if (modelData.icon !== undefined) {
                        root.currentIcon = modelData.icon;
                    }
                    root.itemSelected(modelData.value);
                    root.popup.close();
                }
            }
        }
    }
}
