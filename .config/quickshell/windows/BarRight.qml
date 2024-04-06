import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../lib"
import ".."

RowLayout {
    id: barRight
    anchors.right: barRect.right
    anchors.top: barRect.top
    anchors.bottom: barRect.bottom
    spacing: 15
    RoundButton {
        radius: 4
        background: Rectangle {
            radius: 4
            color: parent.down ? Config.colors.bg0Active: (parent.hovered ? Config.colors.bg0Hover : Config.colors.transparent)
        }
        RowLayout {
            spacing: 0
            Text {
                color: Config.colors.fg0
                font.family: Icons.fluent.fontFamily
                font.pointSize: Icons.fluent.fontPointSize
                text: `${Icons.fluent.battery.c0}`
            }
            Text {
                color: Config.colors.fg0
                font.family: Icons.fluent.fontFamily
                font.pointSize: Icons.fluent.fontPointSize
                text: `${Icons.fluent.wifi.strong}`
            }
            Text {
                color: Config.colors.fg0
                font.family: Icons.fluent.fontFamily
                font.pointSize: Icons.fluent.fontPointSize
                text: `${Icons.fluent.battery.c0}`
            }
        }
    }
    ColumnLayout {
        spacing: 0
        Text {
            id: clock
            color: Config.colors.fg0
            font.pointSize: Config.font.pointSize
            Layout.alignment: Qt.AlignRight
            Process {
                command: ["date", "+%I:%M %p"]
                running: true
                stdout: SplitParser {
                    onRead: data => clock.text = data
                }
            }
        }
        Text {
            id: clockdate
            color: Config.colors.fg0
            font.pointSize: Config.font.pointSize
            Layout.alignment: Qt.AlignRight
            Process {
                command: ["date", "+%d/%m/%Y"]
                running: true
                stdout: SplitParser {
                    onRead: data => clockdate.text = data
                }
            }
        }
    }
    Rectangle {
        width: 10
    }
}
