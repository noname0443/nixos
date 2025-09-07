import QtQuick

Item {
    id: root
    // ===== Public API =====
    // Content (same as before)
    property alias text: label.text
    property url iconSource: ""
    property real implicitIconSize: 16
    property real fontSize: 12
    default property alias contentData: slot.data
    readonly property bool hasCustomContent: slot.data.length > 0

    // Visuals / layout (same as before)
    property color color: "#2D2E33"
    property color hoverColor: Qt.darker(color, 1.08)
    property color pressedColor: Qt.darker(color, 1.18)
    property color disabledColor: "#40424A"
    property color textColor: "#FFFFFF"
    property color borderColor: Qt.rgba(1,1,1,0.12)
    property real borderWidth: 1
    property int paddingH: 14
    property int paddingV: 8
    property int spacing: 8
    property real radius: height / 2

    // Behavior
    property bool enabled: true
    property bool checkable: false
    property bool checked: false

    // Outline mode (same as before)
    property bool outlined: false
    property color outlineColor: "#8BA1FF"
    property real outlineWidth: 2

    // Hover state exposed
    property bool hovered: mArea.containsMouse

    // ===== Activation mode =====
    // "click" | "hover" | "press"
    property string activationMode: "click"

    // Hover activation tuning
    property int hoverActivateDelay: 140       // ms: delay before hover activates
    property bool hoverActivateOnce: true      // if true, activates once per entry
    property bool hoverCancelOnExit: true      // cancel pending activation if mouse leaves

    // Press activation tuning
    property bool pressOnlyInside: true        // only activate if press started inside

    signal clicked()
    signal pressed()
    signal released()
    signal toggled(bool checked)
    signal activated()                         // unified activation

    implicitHeight: hasCustomContent
                  ? Math.max(28, paddingV * 2 + slot.implicitHeight)
                  : Math.max(28, paddingV * 2 + Math.max(label.implicitHeight, implicitIconSize))
    implicitWidth: hasCustomContent
                 ? paddingH * 2 + slot.implicitWidth
                 : paddingH * 2
                   + (iconSource !== "" ? implicitIconSize + spacing : 0)
                   + label.implicitWidth

    // ===== Background =====
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.radius
        color: !root.enabled
               ? root.disabledColor
               : root.outlined
                 ? (mArea.pressed ? Qt.rgba(255,255,255,0.07)
                    : root.hovered ? Qt.rgba(255,255,255,0.04)
                    : "transparent")
                 : (mArea.pressed ? root.pressedColor
                    : root.hovered ? root.hoverColor
                    : root.checked ? Qt.darker(root.color, 1.12)
                    : root.color)
        border.width: root.outlined ? root.outlineWidth : root.borderWidth
        border.color: root.outlined
                      ? (root.hovered ? Qt.lighter(root.outlineColor, 1.2)
                                       : root.outlineColor)
                      : root.borderColor
        antialiasing: true
        Behavior on color { ColorAnimation { duration: 90 } }
        Behavior on border.color { ColorAnimation { duration: 90 } }
    }

    // ===== Built-in (icon + text) =====
    Row {
        id: builtin
        visible: !root.hasCustomContent
        anchors.centerIn: parent
        spacing: root.spacing

        Image {
            visible: iconSource !== ""
            source: iconSource
            width: root.implicitIconSize
            height: root.implicitIconSize
            fillMode: Image.PreserveAspectFit
            mipmap: true
            opacity: root.enabled ? 1.0 : 0.6
        }
        Text {
            id: label
            color: root.textColor
            font.pixelSize: root.fontSize
            opacity: root.enabled ? 1.0 : 0.6
            elide: Text.ElideRight
        }
    }

    // ===== Custom content slot =====
    Item {
        id: slot
        visible: root.hasCustomContent
        anchors.fill: parent
        implicitWidth: Math.max(inner.implicitWidth, 0)
        implicitHeight: Math.max(inner.implicitHeight, 0)

        Item {
            id: inner
            anchors.centerIn: parent
            implicitWidth: contentCol.implicitWidth
            implicitHeight: contentCol.implicitHeight

            Column {
                id: contentCol
                spacing: 0
                leftPadding: paddingH
                rightPadding: paddingH
                topPadding: paddingV
                bottomPadding: paddingV
                // contentData children land here
            }
        }
    }

    // ===== Hover activation timer =====
    Timer {
        id: hoverTimer
        interval: root.hoverActivateDelay
        repeat: false
        onTriggered: {
            if (!root.enabled) return
            if (root.activationMode === "hover" && root.hovered) {
                if (root.checkable) {
                    root.checked = !root.checked
                    root.toggled(root.checked)
                }
                root.activated()
            }
        }
    }

    // ===== Input handling =====
    MouseArea {
        id: mArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        preventStealing: true

        onEntered: {
            if (root.activationMode === "hover") {
                if (root.hoverActivateOnce) hoverTimer.restart()
                else { hoverTimer.interval = root.hoverActivateDelay; hoverTimer.restart() }
            }
        }
        onExited: {
            if (root.activationMode === "hover" && root.hoverCancelOnExit) {
                hoverTimer.stop()
            }
        }

        onPressed: {
            root.pressed()
            if (root.activationMode === "press") {
                if (root.pressOnlyInside) {
                    if (containsMouse) {
                        if (root.checkable) {
                            root.checked = !root.checked
                            root.toggled(root.checked)
                        }
                        root.activated()
                    }
                } else {
                    if (root.checkable) {
                        root.checked = !root.checked
                        root.toggled(root.checked)
                    }
                    root.activated()
                }
            }
        }
        onReleased: root.released()

        onClicked: {
            root.clicked()
            if (root.activationMode === "click") {
                if (root.checkable) {
                    root.checked = !root.checked
                    root.toggled(root.checked)
                }
                root.activated()
            }
        }
    }

    // ===== Keyboard (kept for click mode for accessibility) =====
    Keys.onPressed: (e) => {
        if (!root.enabled) return
        if (root.activationMode !== "click") return
        if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter || e.key === Qt.Key_Space) {
            if (root.checkable) {
                root.checked = !root.checked
                root.toggled(root.checked)
            }
            root.clicked()
            root.activated()
            e.accepted = true
        }
    }

    // ===== Focus ring =====
    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: "transparent"
        border.width: root.activeFocus ? 2 : 0
        border.color: root.outlined ? Qt.lighter(root.outlineColor, 1.15)
                                    : Qt.rgba(1,1,1,0.25)
    }
}
