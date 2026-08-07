import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../Items/" as Items

PanelWindow {
    id: root

    property bool pinned: false
    property bool expanded: pinned || Items.Visibilities.currentActiveModule === "middlemenu"
    property bool windowExpanded: expanded

    property real collapsedWidth: 250
    property real collapsedHeight: 20

    property real expandedWidth: 350
    property real expandedHeight: 300

    property int expandDuration: 250
    property real collapsedVisualWidth: Math.max(collapsedContent.implicitWidth + 10, 200)

    default property alias expandedContent: expandedContent.data
    property alias collapsedContent: collapsedContent.data

    implicitWidth: windowExpanded
      ? expandedWidth
      : Math.max(collapsedContent.implicitWidth + 10, 200)

    implicitHeight: windowExpanded
      ? expandedHeight
      : collapsedHeight

    anchors.top: true

    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    function toggleMiddleMenu() {
      root.pinned = !root.pinned

      if (root.pinned) {
        Items.Visibilities.setActiveModule("middlemenu")
      } else {
        Items.Visibilities.setActiveModule("")
      }
    }

    onExpandedChanged: {
      if (expanded) {
        collapseDelay.stop()
        windowExpanded = true
      } else {
        collapseDelay.start()
      }
    }

    Item {
        anchors.fill: parent

        Rectangle {
            id: island
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            width: root.expanded
                ? root.expandedWidth
                : root.collapsedVisualWidth

            height: root.expanded
                ? root.expandedHeight
                : root.collapsedHeight

            radius: root.expanded
                ? 4
                : 4

            color: "#ffffff"

            Behavior on width {
                NumberAnimation {
                    duration: root.expandDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: root.expandDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on radius {
                NumberAnimation {
                    duration: root.expandDuration
                    easing.type: Easing.OutCubic
                }
            }


            HoverHandler {
                margin: root.expanded ? 0 : 30

                onHoveredChanged: {
                    if (hovered) {
                        collapseTimer.stop()

                        if (!root.pinned) {
                          Items.Visibilities.setActiveModule("middlemenu")
                        }
                    } else {
                      if (!root.pinned) {
                        collapseTimer.start()
                      }
                    }
                }
            }

            TapHandler {
                anchors.fill: parent

                onClicked: {
                  root.toggleMiddleMenu()
                }
            }

            Item {
                id: collapsedContent
                anchors.fill: parent
                opacity: root.expanded ? 0 : 1
                scale: root.expanded ? 0.0 : 1

                Behavior on opacity {
                  NumberAnimation {
                    duration: 100
                  }
                }

                Behavior on scale {
                  NumberAnimation {
                    duration: 100
                  }
                }
            }

            Item {
              id: expandedContent
              anchors.fill: parent
              opacity: root.expanded ? 1 : 0
              scale: root.expanded ? 1 : 0.0

                Behavior on opacity {
                  NumberAnimation {
                    duration: 100
                  }
                }

                Behavior on scale {
                  NumberAnimation {
                    duration: 100
                  }
                }
            }
        }
    }

    Timer {
        id: collapseTimer

        interval: 300

        onTriggered: {
          if (!root.pinned && Items.Visibilities.currentActiveModule === "middlemenu") {
            Items.Visibilities.setActiveModule("")
          }
        }
    }

    Timer {
      id: collapseDelay

      interval: root.expandDuration

      onTriggered: {
        windowExpanded = false
      }
    }
}
