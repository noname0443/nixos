// CustomPopup.qml
// This is a separate QML module for a customizable sliding popup window in Quickshell.
// Save this as CustomPopup.qml in your project directory.
// Usage example in your main QML file:
// import "."  // or the path to CustomPopup.qml
// CustomPopup {
//     id: myPopup
//     slideDirection: "right"
//     animationDuration: 500
//     targetScreen: Quickshell.screens[0]  // Set to your desired screen
//     width: 300
//     height: 400
//     color: "lightgray"  // Optional styling
//     isOpen: false  // Bind this to a signal or property to open/close, e.g., onClicked: myPopup.isOpen = !myPopup.isOpen
//
//     // Add any widgets here, e.g.:
//     Calendar {
//         anchors.centerIn: parent
//     }
//     // Or for .md notes:
//     // Text {
//     //     anchors.fill: parent
//     //     text: "# My Notes\n- Item 1\n- Item 2"  // Or load from file: text: Io.File.read("notes.md")
//     //     textFormat: Text.MarkdownText
//     //     wrapMode: Text.WordWrap
//     // }
// }
import Quickshell
import QtQuick

FloatingWindow {
    id: root

    // Customizable properties
    property string slideDirection: "right"  // Options: "left", "right", "top", "bottom"
    property int animationDuration: 300  // Animation speed in milliseconds
    property int easingType: Easing.InOutQuad  // Animation curve (see QtQuick Easing for options)
    property ShellScreen targetScreen: Quickshell.screens[0]  // The screen to display on (customizable)
    property bool isOpen: false  // Set this to true/false to trigger open/close (can bind to signals)

    // Internal state
    property bool _closing: false
    property real _initialPos: 0
    property real _finalPos: 0

    screen: targetScreen  // Assign the target screen

    // Hide by default
    visible: false

    // Update position based on screen changes or direction
    onTargetScreenChanged: _positionFinal()
    onSlideDirectionChanged: _positionFinal()
    onWidthChanged: if (isOpen) _positionFinal()
    onHeightChanged: if (isOpen) _positionFinal()

    // Handle open/close
    onIsOpenChanged: {
        if (isOpen) {
            _open()
        } else {
            _close()
        }
    }

    // Position the window at its final on-screen position
    function _positionFinal() {
        if (slideDirection === "right") {
            x = targetScreen.geometry.width - width
            y = 0  // Top-right corner; customize y if needed
        } else if (slideDirection === "left") {
            x = 0
            y = 0  // Top-left corner
        } else if (slideDirection === "bottom") {
            y = targetScreen.geometry.height - height
            x = 0  // Bottom-left corner; customize x if needed
        } else if (slideDirection === "top") {
            y = 0
            x = 0  // Top-left corner
        }
    }

    // Calculate initial off-screen position based on direction
    function _getInitialPos() {
        if (slideDirection === "right") {
            return targetScreen.geometry.width
        } else if (slideDirection === "left") {
            return -width
        } else if (slideDirection === "bottom") {
            return targetScreen.geometry.height
        } else if (slideDirection === "top") {
            return -height
        }
    }

    // Open function: set to initial pos, show, animate to final
    function _open() {
        _positionFinal()  // Ensure final position is set
        let posProp = (slideDirection === "left" || slideDirection === "right") ? "x" : "y"
        let initial = _getInitialPos()
        root[posProp] = initial  // Set to off-screen
        visible = true
        slideAnim.property = posProp
        slideAnim.from = initial
        slideAnim.to = root[posProp]  // Animate to current (final) pos
        _closing = false
        slideAnim.start()
    }

    // Close function: animate to off-screen, then hide
    function _close() {
        let posProp = (slideDirection === "left" || slideDirection === "right") ? "x" : "y"
        let initial = _getInitialPos()  // Off-screen is "initial" for close
        slideAnim.property = posProp
        slideAnim.from = root[posProp]
        slideAnim.to = initial
        _closing = true
        slideAnim.start()
    }

    // The animation
    PropertyAnimation {
        id: slideAnim
        target: root
        duration: root.animationDuration
        easing.type: root.easingType
        onFinished: {
            if (_closing) {
                visible = false
                _closing = false
            }
        }
    }
}
