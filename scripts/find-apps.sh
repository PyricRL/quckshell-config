#!/usr/bin/env bash
# List desktop applications for the launcher

CACHE_FILE="/tmp/quickshell-app-list.cache"

BLACKLIST=(
    "xfce4-about.desktop"
    "avahi-discover.desktop"
    "bssh.desktop"
    "bvnc.desktop"
    "qv4l2.desktop"
    "qvidcap.desktop"
    "lstopo.desktop"
    "uuctl.desktop"
    "codium.desktop"
    "xgps.desktop"
    "xgpsspeed.desktop"
)

WHITELIST=(
    "wallpaper.desktop"
    "theme.desktop"
    "powermenu.desktop"
)

SEARCH_PATHS=(
    "$HOME/.nix-profile/share/applications"
    "$HOME/.local/state/nix/profiles/profile/share/applications"
    "/etc/profiles/per-user/$USER/share/applications"
    "/run/current-system/sw/share/applications"
    "$HOME/.local/share/applications"
    "$HOME/.local/share/flatpak/exports/share/applications"
    "/var/lib/flatpak/exports/share/applications"
    "/usr/local/share/applications"
    "/usr/share/applications"
)

ICON_BASE_DIRS=(
    # System hicolor (where Heroic and Prism SVG/PNGs were found)
    "/run/current-system/sw/share/icons/hicolor/scalable/apps"
    "/run/current-system/sw/share/icons/hicolor/256x256/apps"
    "/run/current-system/sw/share/icons/hicolor/512x512/apps"
    "/run/current-system/sw/share/icons/hicolor/128x128/apps"
    "/run/current-system/sw/share/icons/hicolor/64x64/apps"
    "/run/current-system/sw/share/icons/hicolor/48x48/apps"

    # Profile hicolor
    "$HOME/.nix-profile/share/icons/hicolor/scalable/apps"
    "$HOME/.nix-profile/share/icons/hicolor/256x256/apps"
    "$HOME/.nix-profile/share/icons/hicolor/512x512/apps"
    "$HOME/.nix-profile/share/icons/hicolor/128x128/apps"
    "$HOME/.nix-profile/share/icons/hicolor/64x64/apps"
    "$HOME/.nix-profile/share/icons/hicolor/48x48/apps"

    # Steam Shortcuts
    "$HOME/.local/share/icons/hicolor/32x32/apps"
    "$HOME/.local/share/icons/hicolor/48x48/apps"
    "$HOME/.local/share/icons/hicolor/scalable/apps"
    "$HOME/.local/share/icons"

    # Flatpak Exported & Appstream Icons
    "$HOME/.local/share/flatpak/exports/share/icons/hicolor/scalable/apps"
    "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps"

    # Papirus Theme Paths
    "$HOME/.nix-profile/share/icons/Papirus/scalable/apps"
    "$HOME/.nix-profile/share/icons/Papirus/48x48/apps"
    "/run/current-system/sw/share/icons/Papirus/scalable/apps"
    "/run/current-system/sw/share/icons/Papirus/48x48/apps"

    # Pixmaps Fallback
    "$HOME/.nix-profile/share/pixmaps"
    "/run/current-system/sw/share/pixmaps"
    "$HOME/.local/share/pixmaps"
)

resolve_icon() {
    local icon_name="$1"
    [ -z "$icon_name" ] && echo "" && return

    # Direct absolute file path check
    if [[ "$icon_name" == /* ]]; then
        if [ -f "$icon_name" ]; then
            echo "file://$icon_name"
            return
        elif [ -f "${icon_name}.png" ]; then
            echo "file://${icon_name}.png"
            return
        elif [ -f "${icon_name}.svg" ]; then
            echo "file://${icon_name}.svg"
            return
        fi
    fi

    # Strip extension if supplied in desktop file
    local base_name="${icon_name%.*}"

    for base_dir in "${ICON_BASE_DIRS[@]}"; do
        [ ! -d "$base_dir" ] && continue

        # Check exact icon name, base name, and lowercase variations
        for name in "$icon_name" "$base_name" "${base_name,,}"; do
            if [ -f "$base_dir/$name.svg" ]; then
                echo "file://$base_dir/$name.svg"
                return
            elif [ -f "$base_dir/$name.png" ]; then
                echo "file://$base_dir/$name.png"
                return
            fi
        done

        # Reverse domain fallback (e.g., com.heroicgameslauncher.hgl -> hgl)
        if [[ "$base_name" == *.* ]]; then
            local short_name="${base_name##*.}"
            if [ -f "$base_dir/$short_name.svg" ]; then
                echo "file://$base_dir/$short_name.svg"
                return
            elif [ -f "$base_dir/$short_name.png" ]; then
                echo "file://$base_dir/$short_name.png"
                return
            fi
        fi

        # Steam numeric ID fallback
        if [[ "$base_name" =~ ^[0-9]+$ ]]; then
            if [ -f "$base_dir/steam_icon_$base_name.png" ]; then
                echo "file://$base_dir/steam_icon_$base_name.png"
                return
            fi
        elif [[ "$base_name" == steam_icon_* ]]; then
            if [ -f "$base_dir/$base_name.png" ]; then
                echo "file://$base_dir/$base_name.png"
                return
            fi
        fi
    done

    echo ""
}
generate_list() {
    declare -A seen_apps

    for dir in "${SEARCH_PATHS[@]}"; do
        [ ! -d "$dir" ] && continue
        
        for desktop_file in "$dir"/*.desktop; do
            [ -f "$desktop_file" ] || continue
            basename_file=$(basename "$desktop_file")
            
            [[ -n "${seen_apps[$basename_file]}" ]] && continue
            seen_apps[$basename_file]=1
            
            skip=0
            for blacklisted in "${BLACKLIST[@]}"; do
                [[ "$basename_file" == "$blacklisted" ]] && skip=1 && break
            done
            for whitelisted in "${WHITELIST[@]}"; do
                [[ "$basename_file" == "$whitelisted" ]] && skip=0 && break
            done
            [[ $skip -eq 1 ]] && continue
            
            grep -q "^NoDisplay=true" "$desktop_file" 2>/dev/null && continue
            
            name=$(grep -m 1 "^Name=" "$desktop_file" | cut -d= -f2-)
            comment=$(grep -m 1 "^Comment=" "$desktop_file" | cut -d= -f2-)
            icon=$(grep -m 1 "^Icon=" "$desktop_file" | cut -d= -f2-)
            exec=$(grep -m 1 "^Exec=" "$desktop_file" | cut -d= -f2- | sed 's/%[uUfF]//g' | sed 's/%[cdnNvmki]//g')
            terminal=$(grep -m 1 "^Terminal=" "$desktop_file" | cut -d= -f2-)
            
            [ -z "$name" ] && continue
            [ -z "$exec" ] && continue
            [ -z "$comment" ] && comment="Application"
            
            if [[ "$terminal" == "true" ]]; then
                exec="alacritty -e $exec"
            fi

            icon_path=$(resolve_icon "$icon")
            
            echo "$name|$comment|$icon_path|$exec"
        done
    done | sort -u
}

generate_list > "$CACHE_FILE"
cat "$CACHE_FILE"
