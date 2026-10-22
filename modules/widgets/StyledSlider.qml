import Quickshell
import QtQuick
import QtQuick.Controls
import qs.themes

Slider {
    id: control

    property real startValue: 0
    property real endValue: 100
    from: startValue
    to: endValue

    // Add a property to define where the red overvolume zone starts (defaults to 100)
    property real overvolumeThreshold: 100

    stepSize: 5
    snapMode: Slider.SnapAlways

    property real valueToBind: 0

    value: valueToBind

    onMoved: {
        valueToBind = value;
    }

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 8
        width: control.availableWidth
        height: implicitHeight
        radius: 6
        color: Colors.surfaceContainerHigh

        // Permanent red background zone starting at your custom threshold
        Rectangle {
            x: (control.overvolumeThreshold / control.to) * parent.width
            width: parent.width - x
            height: parent.height
            color: Colors.error
            radius: 6
        }

        // Active slider fill
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: Colors.primary
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2

        implicitWidth: 15
        implicitHeight: 15
        radius: 6
    }
}
