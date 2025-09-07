import QtQuick
import QtQuick.Layouts
import Quickshell

// Root is a Scope so it can live beside other shell windows
Scope {
    id: root

    // --- Public API ---
    // Which edge to slide from: "top", "bottom", "left", or "right"
    property string direction: "top"
    // Duration in ms
    property int duration: 250
    // Qt.Easing type name; common ones: "InOutQuad", "OutCubic", etc.
    property string easing: "InOutQuad"
    // Optional dim overlay behind the panel
    property color backdropColor: "#40000000"
    // Corner radius for the panel box
    property int radius: 12
    // Padding inside the panel box
    property int padding: 16
    // Maximum size constraints (default: auto/implicit)
    property int maxWidth: 0
    property int maxHeight: 0

    // Signals
    signal opened()
    signal closed()

    // Methods to control the popup
    function open() {
        if (!loader.active) {
            loader.loading = true
        }
        // If already active, just run the show animation
        if (panel) panel.showAnimated()
    }

    function close() {
        if (panel) panel.hideAnimated()
    }

    // --- Implementation ---

    // Keep the window unloaded when not in use to save memory
    LazyLoader {
        id: loader
        // Create the window lazily
        PanelWindow {
            id: panel
            // Transparent window; we draw our own backdrop
            color: "transparent"

            // Fill whole screen with the overlay mouse-catcher
            anchors {
                left: true; right: true; top: true; bottom: true
            }

            // Backdrop: click outside to close
            Rectangle {
                id: backdrop
                anchors.fill: parent
                color: root.backdropColor

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.close()
                }
            }

            // Content container box that slides in/out
            Rectangle {
                id: box
                color: "#2b2b2b"
                radius: root.radius
                border.color: "#40ffffff"

                // Size: follow content implicit size unless constrained
                implicitWidth: Math.min(maxWidth>0 ? maxWidth : contentLayout.implicitWidth + root.padding*2,
                                        panel.width)
                implicitHeight: Math.min(maxHeight>0 ? maxHeight : contentLayout.implicitHeight + root.padding*2,
                                         panel.height)

                // Position the box along the edge given by direction
                anchors {
                    // We'll anchor to the appropriate edge and center on the opposite axis
                    top: (root.direction === "top")
                    bottom: (root.direction === "bottom")
                    left: (root.direction === "left")
                    right: (root.direction === "right")

                    horizontalCenter: (root.direction === "top" || root.direction === "bottom") ? parent.horizontalCenter : undefined
                    verticalCenter: (root.direction === "left" || root.direction === "right") ? parent.verticalCenter : undefined

                    // Leave a small margin from edges
                    margins: 18
                }

                // Slide offset (we animate x or y from off-screen to 0)
                property real offX: (root.direction === "left")  ? -width - 24
                                   : (root.direction === "right") ?  width + 24
                                   : 0
                property real offY: (root.direction === "top")    ? -height - 24
                                   : (root.direction === "bottom") ?  height + 24
                                   : 0

                // Current animated offsets
                property real shiftX: offX
                property real shiftY: offY
                x: shiftX
                y: shiftY
                opacity: 0.0

                // Easing helper
                property var ease: Qt.Easing[root.easing] ?? Qt.Easing.InOutQuad

                // Public animation helpers called by parent
                function runShow() {
                    // Start from off-screen each time
                    shiftX = offX
                    shiftY = offY
                    opacity = 0.0

                    // Kick the animations
                    animX.to = 0
                    animY.to = 0
                    animOpacity.to = 1.0

                    animX.start()
                    animY.start()
                    animOpacity.start()
                }

                function runHide() {
                    animX.to = offX
                    animY.to = offY
                    animOpacity.to = 0.0

                    animX.start()
                    animY.start()
                    animOpacity.start()
                }

                // Content padding + layout
                // Put your calendar/markdown/etc. inside 'contentBox'
                Item {
                    id: contentPadding
                    anchors.fill: parent
                    anchors.margins: root.padding

                    ColumnLayout {
                        id: contentLayout
                        anchors.fill: parent
                        spacing: 10

                        // Default slot where user content lands
                        Item {
                            id: contentBox
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }

                // Animations
                NumberAnimation {
                    id: animX
                    target: box
                    property: "shiftX"
                    from: box.shiftX
                    to: 0
                    duration: root.duration
                    easing.type: box.ease
                    onFinished: checkOpened()
                }
                NumberAnimation {
                    id: animY
                    target: box
                    property: "shiftY"
                    from: box.shiftY
                    to: 0
                    duration: root.duration
                    easing.type: box.ease
                    onFinished: checkOpened()
                }
                NumberAnimation {
                    id: animOpacity
                    target: box
                    property: "opacity"
                    from: box.opacity
                    to: 1.0
                    duration: Math.max(120, root.duration * 0.7)
                    easing.type: box.ease
                }

                // After show completes, emit opened() once
                function checkOpened() {
                    if (shiftX === 0 && shiftY === 0 && opacity >= 1.0)
                        root.opened()
                }
            } // box

            // Methods on the window to coordinate show/hide + unload
            function showAnimated() {
                box.runShow()
            }
            function hideAnimated() {
                box.runHide()
            }

            // When the hide animation finishes (opacity hits 0), unload
            // We use onStopped signal of animOpacity via Connections to catch both hide/show uses.
            Connections {
                target: animOpacity
                function onStopped() {
                    if (box.opacity === 0.0) {
                        root.closed()
                        loader.active = false  // unload the whole window
                    }
                }
            }

            // Ensure animations start after geometry is ready
            Component.onCompleted: box.runShow()
        } // PanelWindow
    } // LazyLoader
}
