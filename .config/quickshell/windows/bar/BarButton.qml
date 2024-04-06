import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../lib"
import "../../"

Button {
  topInset: 4
  bottomInset: 4
  required default property Item content;
  id: barbtn
  Layout.fillHeight: true
  // Layout.alignment:

  contentItem: content
  background: Rectangle {
    radius: 4
    color: barbtn.down ? Config.colors.bg0Active: (barbtn.hovered ? Config.colors.bg0Hover : Config.colors.transparent)
  }
}
