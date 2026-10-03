pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#121318"
    readonly property color backgroundOn: "#e2e2e9"

    readonly property color surface: "#121318"
    readonly property color surfaceDim: "#121318"
    readonly property color surfaceBright: "#37393e"
    readonly property color surfaceContainerLow: "#1a1b20"
    readonly property color surfaceContainerHigh: "#282a2f"
    readonly property color surfaceOn: "#e2e2e9"
    readonly property color surfaceVariantOn: "#c5c6d0"

    readonly property color outline: "#8e9099"
    readonly property color outlineVariant: "#44474f"

    readonly property color primary: "#aec6ff"
    readonly property color primaryOn: "#122f60"
    readonly property color primaryContainer: "#2c4678"
    readonly property color primaryContainerOn: "#d8e2ff"

    readonly property color secondary: "#bfc6dc"
    readonly property color secondaryOn: "#293041"
    readonly property color secondaryContainer: "#3f4759"
    readonly property color secondaryContainerOn: "#dbe2f9"

    readonly property color error: "#ffb4ab"
    readonly property color warning: "#dfbbde"
    readonly property color success: "#0e56b9"
    readonly property color info: "#d8e2ff"
}
