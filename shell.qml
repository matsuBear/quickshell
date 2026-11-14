import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.windows

ShellRoot {
    // ── Windows ──────────────────────────────────────────────
    TopBar {}

    // ── Keybinds ─────────────────────────────────────────────
    // Hyprland: bind to the `global` dispatcher with "quickshell:toggleBar"
    GlobalShortcut {
        name: "toggleBar"
        description: "Toggle the top status bar"
        onPressed: Globals.ui.barOpen = !Globals.ui.barOpen
    }

    // ── IPC ──────────────────────────────────────────────────
    // qs ipc call bar toggle | open | close
    IpcHandler {
        target: "bar"
        function toggle(): void { Globals.ui.barOpen = !Globals.ui.barOpen; }
        function open(): void   { Globals.ui.barOpen = true; }
        function close(): void  { Globals.ui.barOpen = false; }
    }
}
