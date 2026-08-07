import QtQuick

Item {
    id: root

    property real value: 0
    property real minimum: 0
    property real maximum: 1

    property color backgroundColor: "#444444"
    property color fillColor: "#999999"

    property real barHeight: 6
    property bool interactive: true

    signal moved(real value)

    implicitWidth: 200
    implicitHeight: 20


    Rectangle {
        anchors.verticalCenter: parent.verticalCenter

        width: parent.width
        height: root.barHeight

        radius: height / 2
        color: root.backgroundColor


        Rectangle {
            width: parent.width * root.progress
            height: parent.height

            radius: parent.radius
            color: root.fillColor
        }
    }


    MouseArea {
        anchors.fill: parent

        enabled: root.interactive

        onPressed: updateValue(mouse.x)
        onPositionChanged: {
            if (pressed)
                updateValue(mouse.x)
        }

        function updateValue(x) {
            let percent = Math.max(0, Math.min(1, x / width))

            root.value =
                root.minimum +
                (root.maximum - root.minimum) * percent

            root.moved(root.value)
        }
    }


    property real progress:
        (root.value - root.minimum) /
        (root.maximum - root.minimum)
}
