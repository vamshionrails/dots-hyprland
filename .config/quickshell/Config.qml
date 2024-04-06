pragma Singleton
import QtQuick
import Quickshell

Singleton {
	readonly property bool debug: true
	readonly property QtObject colors: QtObject {
		readonly property string transparent: "#00000000"
		readonly property string bg0: "#D01c1c1c"
		readonly property string fg0: "#FFFFFFFF"
		readonly property string border0: "#D0121212"
		readonly property string bg0Hover: "#E0525252"
		readonly property string bg0Active: "#F06b6b6b"
	}
	readonly property QtObject font: QtObject {
		readonly property string family: "Noto Sans"
		readonly property int pointSize: 8
		readonly property int fluentIconPointSize: 16
	}
}
