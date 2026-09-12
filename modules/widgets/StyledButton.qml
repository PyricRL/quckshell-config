import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.themes
import qs.modules.functions

Control {
    id: root

    property alias text: label.text
    property string icon: ""
    property int iconSize: 20
    property int fontSize: 14
    property bool checkable: false
    property bool checked: false
    property bool beingHovered: mouse_area.containsMouse

    property int iconOffsetX: 0
    property int iconOffsetY: 0

    // "primary" | "secondary" | "background"
    property string variant: "primary"

    property real tint: 0.0

    signal clicked
    signal toggled(bool checked)

    property color base_bg: {
      switch (variant) {
        case "primary":
          return Colors.primary
        case "secondary":
          return Colors.secondary
        case "background":
          return Colors.background
        default:
          return Colors.secondary
      }
    }

    property color base_fg: {
      switch (variant) {
        case "primary":
          return Colors.primaryOn
        case "secondary":
          return Colors.secondaryOn
        case "background":
          return Colors.backgroundOn
        default:
          return Colors.secondaryOn
      }
    }

    property color tinted_bg: {
      const amount = Math.abs(tint)

      if (tint < 0)
        return Qt.darker(base_bg, 1.0 + amount)

      if (tint > 0)
        return Qt.lighter(base_bg, 1.0 + amount)

      return base_bg
    }


    property color background_color: {
        if (!root.enabled)
            return ColorUtils.transparentize(tinted_bg, 0.4)

        if (mouse_area.pressed)
            return Qt.darker(tinted_bg, 1.2)

        if (mouse_area.containsMouse)
            return Qt.lighter(tinted_bg, 1.1)

        return tinted_bg
    }
    

    property color disabled_bg: ColorUtils.transparentize(tinted_bg, 0.4)
    property color disabled_fg: ColorUtils.transparentize(base_fg, 0.4)
    property color hover_bg: Qt.lighter(tinted_bg, 1.1)
    property color pressed_bg: Qt.darker(tinted_bg, 1.2)

    property color text_color: !root.enabled ? disabled_fg : base_fg

    implicitWidth: (label.text === "" && icon !== "")
        ? implicitHeight
        : row.implicitWidth + implicitHeight
    implicitHeight: 40

    contentItem: Item {
        anchors.fill: parent
        Row {
            id: row
            anchors.centerIn: parent
            spacing: root.icon !== "" && label.text !== "" ? 2 : 0

            StyledSymbol {
                visible: root.icon !== ""
                icon: root.icon
                iconSize: root.iconSize
                color: root.text_color

                anchors.horizontalCenterOffset: root.iconOffsetX
                anchors.verticalCenterOffset: root.iconOffsetY
            }

            StyledText {
                id: label
                font.pixelSize: root.fontSize
                color: root.text_color
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }
        }
    }

    background: Rectangle {
        id: background
        radius: 6
        color: root.background_color
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        onClicked: {
            if (!root.enabled) return
            if (root.checkable) {
                root.checked = !root.checked
                root.toggled(root.checked)
            }
            root.clicked()
        }
    }
}
