pragma ComponentBehavior: Bound

import QtQuick

import qs.themes

Text {
  id: root

  property int fontSize
  property bool bold

  renderType: Text.NativeRendering
  textFormat: Text.PlainText
  color: Colors.surfaceOn
  font.pixelSize: fontSize ? fontSize : 14 
  font.bold: bold ? bold : false
}
