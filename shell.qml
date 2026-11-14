import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.windows

ShellRoot {
    // ── Windows ──────────────────────────────────────────────
    TopBar {}
    SideMenu {}

    // ── Keybinds ─────────────────────────────────────────────
    // Hyprland: bind to the `global` dispatcher with "quickshell:toggleBar"
    GlobalShortcut {
        name: "toggleBar"
        description: "Toggle the top status bar"
        onPressed: Globals.ui.barOpen = !Globals.ui.barOpen
    }

    // "quickshell:toggleMenu"
    GlobalShortcut {
        name: "toggleMenu"
        description: "Toggle the side menu"
        onPressed: Globals.toggleMenu("")
    }

    // ── IPC ──────────────────────────────────────────────────
    // qs ipc call bar toggle | open | close
    IpcHandler {
        target: "bar"
        function toggle(): void { Globals.ui.barOpen = !Globals.ui.barOpen; }
        function open(): void   { Globals.ui.barOpen = true; }
        function close(): void  { Globals.ui.barOpen = false; }
    }

    // qs ipc call menu toggle ""          → main page
    // qs ipc call menu toggle network     → straight to a page
    // qs ipc call menu close
    IpcHandler {
        target: "menu"
        function toggle(page: string): void { Globals.toggleMenu(page); }
        function close(): void              { Globals.ui.menuOpen = false; }
    }
}
