pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property string location: "Edwardsville"
    property int intervalMinutes: 15

    property var weatherData: null

    // Exposed weather properties
    readonly property string temp: weatherData?.current_condition?.[0]?.temp_C ? weatherData.current_condition[0].temp_C + "°C" : "--"
    readonly property string condition: weatherData?.current_condition?.[0]?.weatherDesc?.[0]?.value ?? "Loading..."
    readonly property string weatherCode: weatherData?.current_condition?.[0]?.weatherCode ?? ""

    // Maps wttr.in WMO codes directly to Nerd Font weather glyphs
    readonly property string icon: {
        const code = parseInt(weatherCode)
        if (isNaN(code)) return "󰖐"

        if (code === 113) return ""                                             // Sunny / Clear
        if (code === 116) return ""                                            // Partly Cloudy
        if ([119, 122].includes(code)) return "󰖐"                              // Cloudy / Overcast
        if ([143, 248, 260].includes(code)) return ""                          // Fog / Mist
        if ([176, 293, 296, 300, 302, 308].includes(code)) return ""             // Rain / Drizzle
        if ([200, 386, 389, 392, 395].includes(code)) return ""                  // Thunderstorm
        if ([179, 227, 230, 323, 326, 338, 368].includes(code)) return ""        // Snow
        
        return ""
    }

    Process {
        id: process
        command: ["curl", "-s", `https://wttr.in/${root.location}?format=j1`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.weatherData = JSON.parse(text)
                } catch (e) {
                    console.warn("WeatherService: Failed to parse weather data:", e)
                }
            }
        }
    }

    Timer {
        interval: Math.max(1, root.intervalMinutes) * 60 * 1000
        running: true
        repeat: true
        onTriggered: if (!process.running) process.running = true
    }
}
