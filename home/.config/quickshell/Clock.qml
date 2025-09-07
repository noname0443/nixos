import QtQuick

Text {
    id: root

    // Initial time display
    text: Qt.formatDateTime(new Date(), "hh:mm:ss")

    Timer {
        interval: 1000  // Update every second
        running: true
        repeat: true
        onTriggered: root.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
    }
}
