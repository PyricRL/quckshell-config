import QtQuick
import "../../config.js" as Theme

Text {
  property bool muted: false
  property bool small: false
  property bool bold: false

  color: muted ? Theme.colors.textMuted : Theme.colors.text
  font.family: Theme.bar.fontFamily
  font.pixelSize: small ? Theme.bar.fontSizeSmall : Theme.bar.fontSize
  font.bold: bold
}
