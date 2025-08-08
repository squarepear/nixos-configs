{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  quickshell = inputs.quickshell.packages."${pkgs.stdenv.hostPlatform.system}".default;
  mainShellQML = pkgs.writeText "mainShell.qml" ''
    import Quickshell
    import Quickshell.Io
    import QtQuick
    import QtQuick.Layouts

    Scope {
      Variants {
        model: Quickshell.screens
        delegate: Component {
          PanelWindow {
            property var modelData
            screen: modelData
            anchors {
              top: true
              left: true
              right: true
            }
            // Removed y: screen.geometry.y (PanelWindow does not support y)
            implicitHeight: 64 // 64px is a good bar height for 4k
            color: "#222222ee"
            Rectangle {
              anchors.fill: parent
              anchors.margins: 0
              color: "transparent"
              RowLayout {
                anchors.fill: parent
                spacing: 32
                // Left section: RAM, CPU, GPU
                RowLayout {
                  spacing: 32
                  ColumnLayout {
                    spacing: 2
                    Text { text: "RAM"; font.bold: true; font.pixelSize: 18; color: "white" }
                    Text {
                      id: ramText
                      text: "..."
                      font.pixelSize: 18
                      color: "white"
                      Process {
                        id: ramProc
                        command: ["sh", "-c", "free -h | awk '/Mem:/ {print $3 \"/\" $2}'"]
                        running: true
                        stdout: StdioCollector {
                          onStreamFinished: ramText.text = this.text.trim()
                        }
                      }
                      Timer { interval: 1000; running: true; repeat: true; onTriggered: ramProc.running = true }
                    }
                  }
                  ColumnLayout {
                    spacing: 2
                    Text { text: "CPU"; font.bold: true; font.pixelSize: 18; color: "white" }
                    Text {
                      id: cpuText
                      text: "..."
                      font.pixelSize: 18
                      color: "white"
                      Process {
                        id: cpuProc
                        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"]
                        running: true
                        stdout: StdioCollector {
                          onStreamFinished: cpuText.text = this.text.trim() + "%"
                        }
                      }
                      Timer { interval: 1000; running: true; repeat: true; onTriggered: cpuProc.running = true }
                    }
                  }
                  ColumnLayout {
                    spacing: 2
                    Text { text: "GPU"; font.bold: true; font.pixelSize: 18; color: "white" }
                    Text {
                      id: gpuText
                      text: "..."
                      font.pixelSize: 18
                      color: "white"
                      Process {
                        id: gpuProc
                        command: ["sh", "-c", "cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo N/A"]
                        running: true
                        stdout: StdioCollector {
                          onStreamFinished: {
                            var val = this.text.trim();
                            if (val !== "N/A") {
                              gpuText.text = val + "%";
                            } else {
                              gpuText.text = val;
                            }
                          }
                        }
                      }
                      Timer { interval: 1000; running: true; repeat: true; onTriggered: gpuProc.running = true }
                    }
                  }
                }
                Item { Layout.fillWidth: true }
                // Center section: User, Music
                RowLayout {
                  spacing: 32
                  ColumnLayout {
                    spacing: 2
                    Text { text: "User"; font.bold: true; font.pixelSize: 18; color: "white" }
                    Text {
                      id: userText
                      text: "..."
                      font.pixelSize: 18
                      color: "white"
                      Process {
                        id: userProc
                        command: ["whoami"]
                        running: true
                        stdout: StdioCollector {
                          onStreamFinished: userText.text = this.text.trim()
                        }
                      }
                      Timer { interval: 5000; running: true; repeat: true; onTriggered: userProc.running = true }
                    }
                  }
                  ColumnLayout {
                    spacing: 2
                    Text { text: "Music"; font.bold: true; font.pixelSize: 18; color: "white" }
                    Text {
                      id: musicText
                      text: "..."
                      font.pixelSize: 18
                      color: "white"
                      Process {
                        id: musicProc
                        command: ["sh", "-c", "playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null || echo 'No music' "]
                        running: true
                        stdout: StdioCollector {
                          onStreamFinished: musicText.text = this.text.trim()
                        }
                      }
                      Timer { interval: 2000; running: true; repeat: true; onTriggered: musicProc.running = true }
                    }
                  }
                }
                Item { Layout.fillWidth: true }
                // Right section: Power buttons
                RowLayout {
                  spacing: 8
                  Rectangle {
                    width: 120; height: 40; radius: 8; color: "#c0392b"; border.color: "#922b21"
                    Text { anchors.centerIn: parent; text: "⏻ Shutdown"; color: "white"; font.pixelSize: 18 }
                    MouseArea {
                      anchors.fill: parent
                      onClicked: shutdownProc.running = true
                      cursorShape: Qt.PointingHandCursor
                    }
                  }
                  Rectangle {
                    width: 120; height: 40; radius: 8; color: "#2980b9"; border.color: "#1b4f72"
                    Text { anchors.centerIn: parent; text: "⟳ Reboot"; color: "white"; font.pixelSize: 18 }
                    MouseArea {
                      anchors.fill: parent
                      onClicked: rebootProc.running = true
                      cursorShape: Qt.PointingHandCursor
                    }
                  }
                  Rectangle {
                    width: 120; height: 40; radius: 8; color: "#27ae60"; border.color: "#196f3d"
                    Text { anchors.centerIn: parent; text: "⇦ Logout"; color: "white"; font.pixelSize: 18 }
                    MouseArea {
                      anchors.fill: parent
                      onClicked: logoutProc.running = true
                      cursorShape: Qt.PointingHandCursor
                    }
                  }
                }
                Process {
                  id: shutdownProc
                  command: ["systemctl", "poweroff"]
                  running: false
                }
                Process {
                  id: rebootProc
                  command: ["systemctl", "reboot"]
                  running: false
                }
                Process {
                  id: logoutProc
                  command: ["loginctl", "terminate-user", userText.text]
                  running: false
                }
              }
            }
          }
        }
      }
    }
  '';
in
{
  config = lib.mkIf (config.pear.desktop.wm == "hyprland") {
    my = {
      home.packages = [
        quickshell
        (pkgs.writeShellScriptBin "qsmenu" ''
          ${lib.getExe quickshell} -n -p ${mainShellQML}
        '')
      ];

      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, TAB, exec, ${lib.getExe quickshell} -n -p ${mainShellQML}"
      ];
    };
  };
}
