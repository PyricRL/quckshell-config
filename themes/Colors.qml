pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#101418"
    readonly property color backgroundOn: "#e0e2e8"

    readonly property color surface: "#101418"
    readonly property color surfaceDim: "#101418"
    readonly property color surfaceBright: "#36393e"
    readonly property color surfaceContainerLow: "#181c20"
    readonly property color surfaceContainerHigh: "#272a2e"
    readonly property color surfaceOn: "#e0e2e8"
    readonly property color surfaceVariantOn: "#c2c7cf"

    readonly property color outline: "#8c9198"
    readonly property color outlineVariant: "#42474e"

    readonly property color primary: "#9acbfa"
    readonly property color primaryOn: "#003352"
    readonly property color primaryContainer: "#0b4a72"
    readonly property color primaryContainerOn: "#cde5ff"

    readonly property color secondary: "#b9c8da"
    readonly property color secondaryOn: "#233240"
    readonly property color secondaryContainer: "#3a4857"
    readonly property color secondaryContainerOn: "#d5e4f6"

    readonly property color error: "#ffb4ab"
    readonly property color warning: "#d2bfe7"
    readonly property color success: "#6e92b4"
    readonly property color info: "#cde5ff"
}
