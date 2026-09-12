import QtQuick

StyledText {
  property string icon: ""
  property int fill: 0
  property int iconSize: 20

  font.pixelSize: iconSize
  text: icon
  font.variableAxes: {
    "FILL": fill
  }
}
