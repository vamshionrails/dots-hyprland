import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import ".."
import "./bar"


PopupWindow {
  id: startMenu

  width: 500
  height: 500
  parentWindow: winbar
  relativeX: parentWindow.width / 2 - width / 2
  relativeY: -height
  visible: true

  color: Config.colors.transparent

  Rectangle {
    anchors.topMargin: 12
    anchors.bottomMargin: 12
    anchors.leftMargin: 12
    anchors.rightMargin: 12
    radius: 12
    id: barRect
    anchors.fill: parent
    color: Config.colors.bg0
  }
}