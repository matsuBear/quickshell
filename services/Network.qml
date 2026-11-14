pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Network status from NetworkManager (nmcli).
// Refreshes when `nmcli monitor` reports a change, plus a slow poll so the
// wifi signal strength stays current (signal changes aren't monitor events).
Singleton {
    id: root

    property string type: "none"     // "wifi" | "ethernet" | "none"
    property string name: ""         // SSID or connection name
    property int strength: 0         // wifi signal, 0–100
    readonly property bool connected: type !== "none"

    function refresh(): void {
        if (!devices.running)
            devices.running = true;
    }

    // ── Which device is connected ────────────────────────────
    Process {
        id: devices
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        stdout: StdioCollector {
            onStreamFinished: root.parseDevices(text)
        }
    }

    // ── Signal of the active wifi network ────────────────────
    Process {
        id: wifi
        command: ["nmcli", "-t", "-f", "ACTIVE,SIGNAL", "device", "wifi", "list", "--rescan", "no"]
        stdout: StdioCollector {
            onStreamFinished: root.parseWifi(text)
        }
    }

    // ── Triggers ─────────────────────────────────────────────
    Process {
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser {
            onRead: debounce.restart()   // monitor prints bursts of lines per change
        }
    }
    Timer {
        id: debounce
        interval: 500
        onTriggered: root.refresh()
    }
    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    // ── Parsing (nmcli -t: fields separated by ':', literal ':' escaped as '\:') ──
    function parseDevices(text: string): void {
        let t = "none", n = "";
        for (const line of text.trim().split("\n")) {
            const parts = line.split(":");
            const devType = parts[0], state = parts[1];
            const conn = parts.slice(2).join(":").replace(/\\:/g, ":");
            if (state !== "connected")
                continue;
            if (devType === "wifi") {          // wifi wins over ethernet
                t = "wifi";
                n = conn;
                break;
            }
            if (devType === "ethernet" && t === "none") {
                t = "ethernet";
                n = conn;
            }
        }
        root.type = t;
        root.name = n;
        if (t === "wifi")
            wifi.running = true;
        else
            root.strength = 0;
    }

    function parseWifi(text: string): void {
        for (const line of text.trim().split("\n")) {
            if (line.startsWith("yes:")) {
                root.strength = parseInt(line.split(":")[1]) || 0;
                return;
            }
        }
    }
}
