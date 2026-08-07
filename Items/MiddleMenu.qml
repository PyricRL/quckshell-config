import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
  id: root

  property size islandSize: {
    switch (Visibilities.middleMenuState) {
      case "closed":
        return Qt.size(150, 24)
      case "hover":
        return Qt.size(300, 300)
      case "pin":
        return Qt.size(150, 40)
      case "pinhover":
        return Qt.size(300, 300)
      default:
        return Qt.size(100, 24)
    }
  }

  WlrLayershell.layer: (Visibilities.middleMenuState === "pin" || Visibilities.middleMenuState === "pinhover" || Visibilities.middleMenuState === "hover")
    ? WlrLayer.Overlay
    : WlrLayer.Top

  default property alias contentArea: contentArea.data

  implicitWidth: 300
  implicitHeight: 500
  color: "transparent"
  anchors.top: true
  exclusionMode: ExclusionMode.Ignore
  mask: Region {item: hoverArea}

  MouseArea {
    anchors.fill: parent
    onClicked: {
      if (Visibilities.middleMenuState === "pin" || Visibilities.middleMenuState === "pinhover") {
        Visibilities.toggleMiddleMenuPinned()
        Visibilities.setMiddleMenuHovered(true)
      } else {
        Visibilities.toggleMiddleMenuPinned()
        Visibilities.setMiddleMenuHovered(true)
      }
    }
  }

  // this is actual content
  Item {
    id: hoverArea
    anchors.horizontalCenter: parent.horizontalCenter

    implicitWidth: islandSize.width + 20
    implicitHeight: islandSize.height + 20

    Behavior on implicitWidth {
      NumberAnimation {
        duration: 200
        easing.type: Easing.OutCubic
      }
    }

    Behavior on implicitHeight {
      NumberAnimation {
        duration: 200
        easing.type: Easing.OutCubic
      }
    }

    Rectangle {
      id: content
      anchors.horizontalCenter: parent.horizontalCenter
      implicitWidth: root.islandSize.width
      implicitHeight: root.islandSize.height

      clip: true

      radius: 4

      Behavior on implicitWidth {
        NumberAnimation {
          duration: 200
          easing.type: Easing.OutCubic
        }
      }

      Behavior on implicitHeight {
        NumberAnimation {
          duration: 200
          easing.type: Easing.OutCubic
        }
      }

      // this is what renders the text 
      Item {
        id: contentArea
        anchors.fill: parent
      }
    }

    HoverHandler {
      margin: 40

      onHoveredChanged: {
        if (Visibilities.middleMenuState !== "pin" && Visibilities.middleMenuState !== "pinhover") {
          Visibilities.setMiddleMenuHovered(hovered)
        } else {
          Visibilities.setMiddleMenuHovered(false)
        }
      }
    }
  }
}
