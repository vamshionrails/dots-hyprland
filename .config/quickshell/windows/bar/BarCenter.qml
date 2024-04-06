import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../lib"
import "../../"

RowLayout {
    id: barRight
    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        bottom: parent.bottom
    }
    spacing: 5
    BarButton {
        Image {
            anchors.centerIn: parent
            source: "/home/end/.local/share/icons/Win11-dark/apps/scalable/distributor-logo-windows.svg"
            fillMode: Image.PreserveAspectFit
        }
    }
}
