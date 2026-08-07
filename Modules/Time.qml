import QtQuick

Text {
    id: clock

    text: Qt.formatDateTime(new Date(), "h:mm AP")

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            clock.text = Qt.formatDateTime(new Date(), "h:mm AP")
        }
    }
}
