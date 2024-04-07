import ".."
import "./bar"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PopupWindow {
    // id: startMenu

    id: startMenu

    required property PanelWindow parent
    property bool open: false

    parentWindow: winbar
    relativeX: parentWindow.width / 2 - width / 2
    relativeY: -height
    color: "transparent"
    width: 666 // :amogus:
    height: 738
    onOpenChanged: {
        if (open) {
            visible = true;
            popupAnim.to = 12;
        } else {
            popupAnim.to = height;
        }
        popupAnim.restart();
    }

    Rectangle {
        id: popupItem

        width: startMenu.width - 24
        height: startMenu.height - 24
        x: 12
        y: startMenu.height
        radius: 12
        color: Config.colors.bg0

        border {
            color: Config.colors.border0
            width: 1
        }

        SmoothedAnimation {
            id: popupAnim

            target: popupItem
            property: "y"
            velocity: 2000
            duration: 200
            reversingMode: SmoothedAnimation.Immediate
            onFinished: {
                if (popupItem.y == startMenu.height)
                    startMenu.visible = false;

            }

            easing {
                period: 200
                bezierCurve: [0.1, 1, 0, 1]
            }

        }

        layer {
            enabled: true

            effect: DropShadow {
                radius: 10
                color: "#DD000000"
                samples: 16
            }

        }

    }

}
