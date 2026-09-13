pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#121318"
    readonly property color backgroundOn: "#e3e2e9"

    readonly property color surface: "#121318"
    readonly property color surfaceDim: "#121318"
    readonly property color surfaceBright: "#38393f"
    readonly property color surfaceContainerLow: "#1a1b21"
    readonly property color surfaceContainerHigh: "#292a2f"
    readonly property color surfaceOn: "#e3e2e9"
    readonly property color surfaceVariantOn: "#c5c6d0"

    readonly property color outline: "#8f909a"
    readonly property color outlineVariant: "#45464f"

    readonly property color primary: "#b3c5ff"
    readonly property color primaryOn: "#192e60"
    readonly property color primaryContainer: "#314578"
    readonly property color primaryContainerOn: "#dae1ff"

    readonly property color secondary: "#c1c6dd"
    readonly property color secondaryOn: "#2a3042"
    readonly property color secondaryContainer: "#414659"
    readonly property color secondaryContainerOn: "#dde2f9"

    readonly property color error: "#ffb4ab"
    readonly property color warning: "#e1bbdc"
    readonly property color success: "#6f7896"
    readonly property color info: "#dae1ff"
}
