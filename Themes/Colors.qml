pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#1a1b26"
    readonly property color onBackground: "#c0caf5"

    readonly property color surface: "#24283b"
    readonly property color surfaceDim: "#16161e"
    readonly property color surfaceBright: "#414868"
    readonly property color surfaceContainerLow: "#292e42"
    readonly property color surfaceContainerHigh: "#3b4261"
    readonly property color onSurface: "#a9b1d6"
    readonly property color onSurfaceVariant: "#565f89"

    readonly property color outline: "#3b4261"
    readonly property color outlineVariant: "#292e42"

    readonly property color primary: "#7aadf7"
    readonly property color onPrimary: "#16161e"
    readonly property color primaryContainer: "#414868"
    readonly property color onPrimaryContainer: "#c0caf5"

    readonly property color secondary: "#ad8ee6"
    readonly property color onSecondary: "#16161e"
    readonly property color secondaryContainer: "#3b4261"
    readonly property color onSecondaryContainer: "#c0caf5"

    readonly property color error: "#f7768e"
    readonly property color warning: "#e0af68"
    readonly property color success: "#9ece6a"
    readonly property color info: "#0db9d7"

    readonly property color disabled: "#565f89"
    readonly property color onDisabled: "#3b4261"
}
