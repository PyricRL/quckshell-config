import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.widgets
import qs.extras

Item {
    id: root

    ListModel { id: appModel }
    ListModel { id: clipboardModel }
    ListModel { id: systemModel }
    ListModel { id: wallpaperModel }

    // Built-in System Actions
    Component.onCompleted: {
        systemModel.append({ "name": "Lock Screen", "comment": "Lock current session", "icon": "", "symbol": "", "exec": "loginctl lock-session" })
        systemModel.append({ "name": "Logout", "comment": "End current session", "icon": "", "symbol": "󰗽", "exec": "loginctl terminate-user $USER" })
        systemModel.append({ "name": "Reboot", "comment": "Restart the system", "icon": "", "symbol": "", "exec": "systemctl reboot" })
        systemModel.append({ "name": "Power Off", "comment": "Shutdown the system", "icon": "", "symbol": "⏻", "exec": "systemctl poweroff" })
        systemModel.append({ "name": "Suspend", "comment": "Sleep the system", "icon": "", "symbol": "󰤄", "exec": "systemctl suspend" })
    }

    // 1. Application Loader Process
    Process {
        id: appLoader
        running: true
        command: ["bash", "-c", Quickshell.shellDir + "/scripts/find-apps.sh"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = data.trim()
                if (!line) return
                const parts = line.split("|")
                if (parts.length >= 4) {
                    appModel.append({
                        "name": parts[0].trim(),
                        "comment": parts[1].trim(),
                        "icon": parts[2].trim(),
                        "symbol": "",
                        "exec": parts[3].trim()
                    })
                }
            }
        }
    }

    function fetchClipboard() {
        clipboardModel.clear()
        clipboardLoader.running = false
        clipboardLoader.running = true
    }

    function fetchWallpapers() {
        wallpaperModel.clear()
        wallpaperLoader.running = false
        wallpaperLoader.running = true
    }

    Connections {
        target: States
        function onLauncherModeChanged() {
            if (States.currentActiveModule === "launcher" && States.launcherMode === "clipboard") {
                root.fetchClipboard()
            }
            if (States.currentActiveModule === "launcher" && States.launcherMode === "wallpaper") {
                root.fetchWallpapers()
            }
        }
        function onCurrentActiveModuleChanged() {
            if (States.currentActiveModule === "launcher" && States.launcherMode === "clipboard") {
                root.fetchClipboard()
            }
        }
    }

    // 2. Clipboard Loader Process
    Process {
        id: clipboardLoader
        running: false
        command: [
            "bash",
            "-c",
            "mkdir -p /tmp/cliphist-previews; " +
            "cliphist list | head -50 | { count=50; while read -r line; do " +
            "  id=$(echo \"$line\" | cut -f1); " +
            "  text=$(echo \"$line\" | cut -f2-); " +
            "  if echo \"$text\" | grep -qiE '\\[\\[ binary data.*(png|jpg|jpeg|webp)'; then " +
            "    imgpath=\"/tmp/cliphist-previews/$id.png\"; " +
            "    if [ ! -s \"$imgpath\" ]; then cliphist decode \"$id\" > \"$imgpath\" 2>/dev/null; fi; " +
            "    if [ -f \"$imgpath\" ] && [ -s \"$imgpath\" ]; then " +
            "      dimensions=$(identify -format '%wx%h' \"$imgpath\" 2>/dev/null || echo 'unknown'); " +
            "      filesize=$(du -h \"$imgpath\" | cut -f1); " +
            "      echo \"$count|Image ($dimensions, $filesize)|file://$imgpath\"; " +
            "    fi; " +
            "  else " +
            "    echo \"$count|$text|$id\"; " +
            "  fi; " +
            "  count=$((count - 1)); " +
            "done; }"
        ]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = data.trim()
                if (!line) return
                
                const parts = line.split("|")
                if (parts.length >= 2) {
                    const position = parts[0].trim()
                    const rawText = parts[1].trim()
                    const clipboardId = parts[2] ? parts[2].trim() : ""
                    const imagePath = parts[1].includes("Image (") ? parts[2].trim() : ""

                    if (position && rawText) {
                        clipboardModel.append({
                            "name": rawText,
                            "comment": "Clipboard item #" + position,
                            "icon": imagePath,
                            "symbol": imagePath !== "" ? "" : "",
                            "exec": clipboardId
                        })
                    }
                }
            }
        }
    } 

    Process {
        id: wallpaperLoader
        running: false

        command: [
            "bash",
            "-c",
            "find \"$HOME/Pictures/Wallpapers\" -maxdepth 1 -type f " +
            "\\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \\) " +
            "-printf '%f|%p\\n'"
        ]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = data.trim()
                if (!line) return

                const parts = line.split("|")
                if (parts.length < 2) return

                wallpaperModel.append({
                    "name": parts[0].trim(),
                    "comment": "Wallpaper",
                    "icon": "file://" + parts[1].trim(),
                    "symbol": "󰸉",
                    "exec": parts[1].trim()
                })
            }
        }
    }

    function getActiveModel() {
        if (States.launcherMode === "clipboard") return clipboardModel
        if (States.launcherMode === "system") return systemModel
        if (States.launcherMode === "wallpaper") return wallpaperModel
        return appModel
    }

    function getPlaceholderText() {
        if (States.launcherMode === "clipboard") return "Search clipboard..."
        if (States.launcherMode === "system") return "Search system actions..."
        if (States.launcherMode === "wallpaper") return "Search wallpapers..."
        return "Search applications..."
    }

    // 3. Self-contained Window Launcher Interface
    StyledLauncher {
        active: States.currentActiveModule === "launcher"
        placeholderText: root.getPlaceholderText()
        sourceModel: root.getActiveModel()
        gridMode: States.launcherMode === "wallpaper" || States.launcherMode === "system"

        onCloseRequested: States.setActiveModule("")

        onItemSelected: (item) => {
            if (!item || !item.exec) return

            if (States.launcherMode === "clipboard") {
                Quickshell.execDetached(["bash", "-c", `cliphist decode ${item.exec} | wl-copy`])
            } else if (States.launcherMode === "system") {
                Quickshell.execDetached(["bash", "-c", item.exec])
            } else if (States.launcherMode === "wallpaper") {
                Quickshell.execDetached(["awww", "img", item.exec, "--transition-type", "fade", "--transition-duration", "0.7" ])
                Quickshell.execDetached(["matugen", "image", item.exec, "-m", "dark", "--source-color-index", "0"])
            } else {
                let cleanExec = item.exec.replace(/%[fFuUiIdDnNkKmMsS]/g, "").trim()
                Quickshell.execDetached(["bash", "-c", cleanExec])
            }

            States.setActiveModule("")
        }
    }
}
