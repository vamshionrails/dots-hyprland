import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../lib"
import ".."

Button {
  required default property Item content;


  contentItem: content
  background: Rectangle {
    radius: 4
    color: parent.down ? Config.colors.bg0Active: (parent.hovered ? Config.colors.bg0Hover : Config.colors.transparent)
  }
}
