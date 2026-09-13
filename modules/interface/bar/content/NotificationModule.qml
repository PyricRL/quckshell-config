import QtQuick
import QtQuick.Layouts

import qs.modules.widgets
import qs.extras

Item {
  id: appContainer

  Layout.alignment: Qt.AlignVCenter
  implicitWidth: iconItem.implicitWidth
  implicitHeight: 32

  StyledButton {
    id: iconItem

    Layout.alignment: Qt.AlignVCenter

    variant: "background"

    text: ""
    icon: ""
    iconSize: 20

    implicitHeight: 32
    implicitWidth: 32

    onClicked: States.toggleModule("notification")
  }
}
