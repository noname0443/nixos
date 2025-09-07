import Quickshell
import QtQuick
import "modules" as Modules

Scope {
    id: root

    property string currentTime: {
        var date = sysClock.date;
        var timeStr = Qt.formatDateTime(date, "hh:mm AP");
        var offsetMinutes = -date.getTimezoneOffset();
        var sign = offsetMinutes >= 0 ? "+" : "-";
        var absOffset = Math.abs(offsetMinutes);
        var offsetHours = Math.floor(absOffset / 60).toString().padStart(2, "0");
        var offsetMins = (absOffset % 60).toString().padStart(2, "0");
        var offsetStr = sign + offsetHours + ":" + offsetMins;
        var dayStr = Qt.formatDateTime(date, "ddd · MMM yyyy-MM-dd");
        return timeStr + " " + offsetStr + " " + dayStr;
    }

    SystemClock {
        id: sysClock

        precision: SystemClock.Seconds  // Updates every second
    }

    // Top panel with clock (one per monitor)
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            color: "#aa1a233a"  // Semi-transparent dark blue/gray

            implicitHeight: 45
            screen: modelData

            anchors {
                left: true
                right: true
                top: true
            }

            Modules.OvalButton {
                id: ob

                activationMode: "hover"
                anchors.centerIn: parent
                hoverActivateDelay: 0
                hoverActivateOnce: true
                outlineColor: "#88C0D0"
                outlined: true
                width: intText.width * 1.1

                states: [
                    State {
                        name: "hovered"
                        when: hovered

                        PropertyChanges {
                            scale: 2
                            target: this
                        }
                    }
                ]
                transitions: [
                    Transition {
                        NumberAnimation {
                            duration: 120
                            properties: "scale"
                        }
                    }
                ]

                onActivated: popup.isOpen = true

                Text {
                    id: intText

                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 14
                    text: root.currentTime
                }    // simple hover reaction
            }

            Modules.CustomPopup {
                id: popup

                animationDuration: 500
                color: "lightgray"  // Optional styling
                height: 400
                isOpen: false  // Bind this to a signal or property to open/close, e.g., onClicked: myPopup.isOpen = !myPopup.isOpen

                slideDirection: "right"
                targetScreen: Quickshell.screens[0]  // Set to your desired screen
                width: 300

                Text {
                    anchors.fill: parent
                    text: "# My Notes\n- Item 1\n- Item 2"  // Or load from file: text: Io.File.read("notes.md")
                    textFormat: Text.MarkdownText
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    //// Bottom panel (empty, one per monitor)
    //Variants {
    //    model: Quickshell.screens

    //    PanelWindow {
    //        required property var modelData
    //        screen: modelData

    //        anchors {
    //            bottom: true
    //            left: true
    //            right: true
    //        }

    //        implicitHeight: 30
    //        color: "#aa1a233a"  // Semi-transparent dark blue/gray
    //    }
    //}

    //// Left panel (empty, one per monitor)
    //Variants {
    //    model: Quickshell.screens

    //    PanelWindow {
    //        required property var modelData
    //        screen: modelData

    //        anchors {
    //            left: true
    //            top: true
    //            bottom: true
    //        }

    //        implicitWidth: 50
    //        color: "#aa1a233a"  // Semi-transparent dark blue/gray
    //    }
    //}
}
