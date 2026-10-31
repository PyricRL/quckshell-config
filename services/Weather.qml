pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property string location: "Edwardsville"
    property int intervalMinutes: 15

    property var weatherData: null

    readonly property string temp: weatherData?.current?.temperature_2m + "°F" ?? ""
    readonly property string weatherCode: weatherData?.current?.weather_code ?? ""

    readonly property string icon: {
        const code = parseInt(weatherCode);

        if ([0, 2, 3].includes(code))
            return "";
        if ([1].includes(code))
            return "";
        if ([4].includes(code))
            return "";
        if ([5].includes(code))
            return "";
        if ([6].includes(code))
            return "";
        if ([7].includes(code))
            return "";
        if ([8, 19].includes(code))
            return "";
        if ([9, 30, 31, 32, 33, 34, 35].includes(code))
            return "";
        if ([10, 11, 12, 28, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49].includes(code))
            return "";
        if ([13].includes(code))
            return "";
        if ([17, 29, 91, 92, 93, 94, 95, 96, 97, 99].includes(code))
            return "";
        if ([14, 15, 16, 21, 58, 59, 60, 61, 62, 63, 64, 65].includes(code))
            return "";
        if ([20, 50, 51, 52, 53, 54, 55].includes(code))
            return "";
        if ([23, 24, 26, 56, 57, 66, 67, 68, 69, 79, 83, 84].includes(code))
            return "";
        if ([22, 70, 71, 72, 73, 74, 75, 77].includes(code))
            return "";
        if ([76, 78].includes(code))
            return "";
        if ([36, 37].includes(code))
            return "";
        if ([38, 39].includes(code))
            return "";
        if ([25, 80, 81, 82].includes(code))
            return "";
        if ([27, 87, 88, 89, 90].includes(code))
            return "";
        if ([85, 86].includes(code))
            return "";
        if ([98].includes(code))
            return "";
        return "";
    }

    Process {
        id: process
        command: ["curl", "-s", `https://api.open-meteo.com/v1/forecast?latitude=38.8114&longitude=-89.9532&current=temperature_2m,weather_code&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.weatherData = JSON.parse(text);
                } catch (e) {
                    console.warn("WeatherService: Failed to parse weather data:", e);
                }
            }
        }
    }

    Timer {
        interval: Math.max(1, root.intervalMinutes) * 60 * 1000
        running: true
        repeat: true
        onTriggered: if (!process.running)
            process.running = true
    }
}
