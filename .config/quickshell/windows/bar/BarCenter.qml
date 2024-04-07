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
        onClicked: startMenu.visible = !startMenu.visible
        Image {
            anchors.centerIn: parent
            source: "../../assets/distributor-logo-windows.svg"
            fillMode: Image.PreserveAspectFit
        }
        // icon {
        //     name: "distributor-logo-windows"
        //     height: 32
        //     width: 32
        // }
    }
}
