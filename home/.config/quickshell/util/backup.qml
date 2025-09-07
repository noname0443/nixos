// ~/.config/quickshell/backup.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

FloatingWindow {
  id: backupPopup
  title: "Backup"
  width: 560
  height: 360
  minimumSize: Qt.size(480, 300)
  visible: true

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: "#181825"
    border.color: "#585b70"
    border.width: 1

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12

      // Header row
      RowLayout {
        Layout.fillWidth: true
        spacing: 12
        Label {
          text: "Backup"
          color: "white"
          font.pixelSize: 18
          font.bold: true
        }
        Item { Layout.fillWidth: true }
        Button { text: "✕"; onClicked: Qt.quit() }
      }

      // Status row
      RowLayout {
        Layout.fillWidth: true
        spacing: 10
        BusyIndicator { id: busy; running: false; visible: running }
        Label { id: statusText; text: "Ready to back up."; color: "white"; font.pixelSize: 14 }
      }

      // Log area (fills remaining height)
      Frame {
        Layout.fillWidth: true
        Layout.fillHeight: true
        background: Rectangle { color: "#11111b"; radius: 8; border.color: "#313244"; border.width: 1 }

        ScrollView {
          anchors.fill: parent
          TextArea {
            id: logArea
            readOnly: true
            wrapMode: TextArea.NoWrap
            text: ""
            color: "#cdd6f4"
            font.family: "monospace"
            background: null
          }
        }
      }

      // Buttons row (natural height at bottom)
      RowLayout {
        id: buttonRow
        Layout.fillWidth: true
        spacing: 8

        Button {
          id: startBtn
          text: "Start"
          onClicked: {
            startBtn.enabled = false
            cancelBtn.enabled = true
            backupProc.running = true
            busy.running = true
            statusText.text = "Running…"
            statusText.color = "#cdd6f4"
            logArea.text = ""
          }
        }
        Button {
          id: cancelBtn
          text: "Cancel"
          enabled: false
          onClicked: {
            statusText.text = "Cancelled."
            statusText.color = "#f9e2af"
            backupProc.running = false
            busy.running = false
            cancelBtn.enabled = false
            startBtn.enabled = true
          }
        }
      }
    }
  }

  Process {
    id: backupProc
    command: ["bash", "-lc", "rclone sync ~/Sync google_enc: -v -P --stats=1s"]
    stdout: SplitParser { id: out }
    stderr: SplitParser { id: err }

    Component.onCompleted: {
      function appendLine(prefix, line) {
        logArea.text += (prefix ? prefix + " " : "") + line + "\n"
        logArea.cursorPosition = logArea.length
      }
      out.read.connect(line => appendLine("", line))
      err.read.connect(line => appendLine("[err]", line))
    }

    onExited: (code, _status) => {
      busy.running = false
      cancelBtn.enabled = false
      startBtn.enabled = true
      if (code === 0) {
        statusText.text = "Completed successfully."
        statusText.color = "#a6e3a1"
      } else {
        statusText.text = "Failed (exit " + code + ")."
        statusText.color = "#f38ba8"
      }
    }
  }
}
