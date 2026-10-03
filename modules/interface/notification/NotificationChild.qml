import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.themes
import qs.services
import qs.modules.widgets

Rectangle {
    id: root

    required property int index
    required property string summary
    required property string body
    required property string appName
    required property string appIcon
    required property string image
    required property int expireTimeout
    required property string timeDate

    property bool dismissing: false

    Layout.fillWidth: true
    implicitHeight: Math.max(contentLayout.implicitHeight + 20, 70)
    radius: 6
    color: Colors.background

    transform: Translate {
        id: slideTrans
        x: 0
    }

    Timer {
        running: true
        interval: root.expireTimeout
        onTriggered: root.animateAndDismiss()
    }

    SequentialAnimation {
        id: exitAnim

        ParallelAnimation {
            NumberAnimation {
                target: slideTrans
                property: "x"
                to: 100
                duration: 200
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: root
                property: "opacity"
                to: 0
                duration: 200
                easing.type: Easing.InCubic
            }
        }

        ScriptAction {
            script: Notif.dismissPopup(root.index)
        }
    }

    function animateAndDismiss() {
        if (!dismissing) {
            dismissing = true;
            exitAnim.start();
        }
    }

    RowLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        Item {
            id: mediaContainer
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            visible: root.image !== "" || root.appIcon !== ""

            // 1. BASE IMAGE (Only visible if an image exists)
            ClippingRectangle {
                id: baseImage
                anchors.fill: parent
                radius: 6
                clip: true
                visible: root.image !== ""
                color: "transparent"

                Image {
                    anchors.fill: parent
                    source: root.image
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                }
            }

            // 2. APP ICON (Badge overlay when image exists, full size otherwise)
            ClippingRectangle {
                id: appIcon
                radius: root.image !== "" ? 4 : 6
                clip: true
                visible: root.appIcon !== ""

                // Explicit width and height for non-Layout parent
                width: root.image !== "" ? 24 : parent.width
                height: root.image !== "" ? 24 : parent.height

                // Conditional anchors
                anchors {
                    bottom: root.image !== "" ? parent.bottom : undefined
                    right: root.image !== "" ? parent.right : undefined
                    bottomMargin: root.image !== "" ? -6 : 0
                    rightMargin: root.image !== "" ? -6 : 0
                    fill: root.image === "" ? parent : undefined
                }

                color: "transparent"

                Image {
                    anchors.fill: parent
                    anchors.margins: root.image !== "" ? 2 : 0
                    source: {
                            const src = root.appIcon;
                            if (!src) return "";
                            if (src.startsWith("/") || src.startsWith("file://") || src.startsWith("image://")) {
                                return src;
                            }
                            const resolved = Quickshell.iconPath(src);
                            return resolved !== "" ? resolved : ("image://icon/" + src);
                        }
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 2
          RowLayout {
              Layout.fillWidth: true

              StyledText {
                  text: root.summary
                  bold: true
                  fontSize: 16
                  Layout.fillWidth: true
                  elide: Text.ElideRight
              }

              StyledText {
                  text: root.timeDate
                  fontSize: 10
                  opacity: 0.6
                  Layout.alignment: Qt.AlignRight
              }
          }
          StyledText {
              text: root.body
              Layout.fillWidth: true
              elide: Text.ElideRight
          }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.animateAndDismiss()
    }
}
