pragma Singleton

import QtQuick
import Quickshell

// ─────────────────────────────────────────────────────────────
//  Globals — the single source of truth for style + UI state.
//  Services (audio, network, …) live in services/, not here.
//
//  Access from anywhere with `import qs` → Globals.colors.bg, etc.
// ─────────────────────────────────────────────────────────────
Singleton {
    id: root

    // ── Raw palette (mirrors color.conf) ─────────────────────
    component Palette: QtObject {
        readonly property color darkCold:     "#0d1330"
        readonly property color midDarkCold:  "#1b2352"
        readonly property color secdCold:     "#324180"
        readonly property color midLightCold: "#6f7f94"
        readonly property color primCold:     "#b0c2cf"

        readonly property color lightWarm:    "#fcebd2"
        readonly property color midWarm:      "#a38b6c"
        readonly property color primWarm:     "#c99a3e"
        readonly property color secdWarm:     "#8b5a3c"

        readonly property color greenAlt:     "#7a9a6a"
        readonly property color redAlt:       "#c2503f"
        readonly property color blueAlt:      "#5f7fd0"
        readonly property color pinkAlt:      "#9a8fc0"
    }
    readonly property Palette pal: Palette {}

    // ── Semantic colors (what components should use) ─────────
    component Colors: QtObject {
        // backgrounds
        property color bg
        property color bgRaised
        // in-menu surfaces
        property color surface
        property color surfaceAlt
        // text
        property color fg
        property color fgDim
        property color fgMuted
        // accents
        property color accentWarm
        property color accentCold
        // status
        property color success
        property color warning
        property color error
        property color info
        // misc
        property color border
        property color bgEdge
        property color bgMid
    }
    readonly property Colors colors: Colors {
        bg:         root.pal.darkCold
        bgRaised:   root.pal.midDarkCold
        surface:    root.pal.secdCold
        surfaceAlt: root.pal.midLightCold

        fg:         root.pal.lightWarm
        fgDim:      root.pal.primCold
        fgMuted:    root.pal.midLightCold

        accentWarm: root.pal.primWarm
        accentCold: root.pal.primCold

        success:    root.pal.greenAlt
        warning:    root.pal.primWarm
        error:      root.pal.redAlt
        info:       root.pal.blueAlt

        border:     root.pal.midDarkCold
        bgEdge: root.alpha(root.pal.darkCold, 0.8)
        bgMid:  root.alpha(root.pal.secdCold, 0.8)
    }

    // ── Style / metrics ──────────────────────────────────────
    component Style: QtObject {
        // matches the terminal; bg colors get this alpha, Hyprland blurs behind
        readonly property real opacity: 0.85

        readonly property int radius:      10
        readonly property int radiusSmall: 6
        readonly property int padding:     6
        readonly property int spacing:     6
        readonly property int borderWidth: 1

        // fonts: change to whatever kitty uses
        readonly property string fontFamily: "ShureTechMono Nerd Font"
        readonly property string iconFamily: "ShureTechMono Nerd Font"
        readonly property int fontSize:      16
        readonly property int fontSizeSmall: 13
        readonly property int fontSizeLarge: 20

        // top bar
        readonly property int barHeight: 45
        readonly property int barMargin: 6   // gap between screen top and bar

        // corner fans — fractions of the screen size (see components/Fan.qml)
        readonly property int  fanMargin: 24     // window slack for curve bulge + shadow
        readonly property real fanPeel:   0.2    // how long a back blade hugs the one in front

        // shadows where blades overlap
        readonly property real shadowOpacity: 0.45
        readonly property real shadowBlur:    0.6   // 0–1
        readonly property real shadowOffset:  4     // px, away from the corner

        // bar: top-right corner (u = down the right edge ×H, v = left along the top ×W)
        readonly property real barReach:    0.31          // front blade along the top edge (×W)
        readonly property real barDrop:     0.20          // front blade down the right edge (×H)
        readonly property real barBow:      -0.01         // curve bulge (×W); + = toward the corner
        readonly property var  barEnds:     [0.33, 0.50]  // middle / back blades on the right edge (×H)
        readonly property var  barBranches: [0.75, 0.45] // where they peel off (0 = right edge end, 1 = top end)

        // menu: bottom-left corner (u = right along the bottom ×W, v = up the left edge)
        readonly property real menuFoot:    0.38          // front blade on the bottom edge (×W)
        readonly property real menuHead:    0.12          // front blade on the top edge (×W)
        readonly property real menuBow:     -0.015        // curve bulge (×W); + = toward the corner
        readonly property var  menuEnds:    [0.48, 0.58]  // middle / back blades on the bottom edge (×W)
        readonly property var  menuBranches: [0.72, 0.5]  // where they peel off (0 = bottom end, 1 = top end)
        readonly property real menuContentHeight: 0.6     // page area height (×H), bottom-aligned
        readonly property int  menuPadding: 18
        readonly property int  menuColumns: 3
    }
    readonly property Style style: Style {}

    // ── Animation ────────────────────────────────────────────
    component Anim: QtObject {
        readonly property int fast:   180
        readonly property int normal: 240
        readonly property int slow:   600
        readonly property int stagger: 70   // delay between layered pieces
        readonly property int close:  200             // fan blades retracting
        readonly property int easeIn: Easing.InCubic  // accelerate out of view
        readonly property int ease:     Easing.OutCubic
        readonly property int easeBack: Easing.OutBack
    }
    readonly property Anim anim: Anim {}

    // ── Icons (Nerd Font glyphs) ─────────────────────────────
    component Icons: QtObject {
        readonly property string bolt:      String.fromCodePoint(0xF140B) // nf-md-lightning_bolt
        readonly property string back:      String.fromCodePoint(0xF004D) // nf-md-arrow_left
        readonly property string settings:  String.fromCodePoint(0xF0493) // nf-md-cog
        readonly property string music:     String.fromCodePoint(0xF075A) // nf-md-music
        readonly property string bell:      String.fromCodePoint(0xF009A) // nf-md-bell
        readonly property string wifi:      String.fromCodePoint(0xF05A9) // nf-md-wifi
        readonly property string bluetooth: String.fromCodePoint(0xF00AF) // nf-md-bluetooth
        readonly property string wifi1:    String.fromCodePoint(0xF091F) // nf-md-wifi_strength_1
        readonly property string wifi2:    String.fromCodePoint(0xF0922) // nf-md-wifi_strength_2
        readonly property string wifi3:    String.fromCodePoint(0xF0925) // nf-md-wifi_strength_3
        readonly property string wifi4:    String.fromCodePoint(0xF0928) // nf-md-wifi_strength_4
        readonly property string wifiOff:  String.fromCodePoint(0xF092E) // nf-md-wifi_strength_off_outline
        readonly property string ethernet: String.fromCodePoint(0xF0200) // nf-md-ethernet
    }
    readonly property Icons icons: Icons {}

    // ── UI state (writable) ──────────────────────────────────
    // Named `ui` rather than `state` to avoid clashing with Item.state.
    component Ui: QtObject {
        property bool barOpen:  false
        property bool menuOpen: false
        property string menuPage: "main"
    }
    readonly property Ui ui: Ui {}

    // ── Menu navigation ──────────────────────────────────────
    // toggleMenu("")         → open on main / close
    // toggleMenu("network")  → open straight on a page / close if already there
    function toggleMenu(page: string): void {
        if (ui.menuOpen && (page === "" || page === ui.menuPage)) {
            ui.menuOpen = false;
            return;
        }
        ui.menuPage = page === "" ? "main" : page;
        ui.menuOpen = true;
    }

    // Esc / back button: sub-page → main → closed
    function menuBack(): void {
        if (ui.menuPage !== "main")
            ui.menuPage = "main";
        else
            ui.menuOpen = false;
    }

    // ── Helpers ──────────────────────────────────────────────
    function alpha(c: color, a: real): color {
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
