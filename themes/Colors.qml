pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#101417"
    readonly property color backgroundOn: "#dfe3e8"

    readonly property color surface: "#101417"
    readonly property color surfaceDim: "#101417"
    readonly property color surfaceBright: "#353a3e"
    readonly property color surfaceContainerLow: "#181c20"
    readonly property color surfaceContainerHigh: "#262a2e"
    readonly property color surfaceOn: "#dfe3e8"
    readonly property color surfaceVariantOn: "#c1c7ce"

    readonly property color outline: "#8b9198"
    readonly property color outlineVariant: "#41474d"

    readonly property color primary: "#94cdf7"
    readonly property color primaryOn: "#00344d"
    readonly property color primaryContainer: "#004c6e"
    readonly property color primaryContainerOn: "#c8e6ff"

    readonly property color secondary: "#b7c9d9"
    readonly property color secondaryOn: "#21323f"
    readonly property color secondaryContainer: "#384956"
    readonly property color secondaryContainerOn: "#d3e5f5"

    readonly property color error: "#ffb4ab"
    readonly property color warning: "#cec0e8"
    readonly property color success: "#2a343c"
    readonly property color info: "#c8e6ff"
}
