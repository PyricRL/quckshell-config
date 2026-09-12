pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#1a1b26"
    readonly property color backgroundOn: "#c0caf5"

    readonly property color surface: "#24283b"
    readonly property color surfaceDim: "#16161e"
    readonly property color surfaceBright: "#414868"
    readonly property color surfaceContainerLow: "#292e42"
    readonly property color surfaceContainerHigh: "#3b4261"
    readonly property color surfaceOn: "#a9b1d6"
    readonly property color surfaceVariantOn: "#565f89"

    readonly property color outline: "#3b4261"
    readonly property color outlineVariant: "#292e42"

    readonly property color primary: "#7aadf7"
    readonly property color primaryOn: "#16161e"
    readonly property color primaryContainer: "#414868"
    readonly property color primaryContainerOn: "#c0caf5"

    readonly property color secondary: "#ad8ee6"
    readonly property color secondaryOn: "#16161e"
    readonly property color secondaryContainer: "#3b4261"
    readonly property color secondaryContainerOn: "#c0caf5"

    readonly property color error: "#f7768e"
    readonly property color warning: "#e0af68"
    readonly property color success: "#9ece6a"
    readonly property color info: "#0db9d7"
}
