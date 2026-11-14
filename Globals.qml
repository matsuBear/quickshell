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

        // trapezoid panels (bar, later the bottom menu)
        readonly property real panelAngle:  65   // side slope vs. the screen edge, in degrees (90 = rectangle)
        readonly property real panelBorder: 2.5  // metallic border thickness
    }
    readonly property Style style: Style {}

    // ── Animation ────────────────────────────────────────────
    component Anim: QtObject {
        readonly property int fast:   180
        readonly property int normal: 240
        readonly property int slow:   360
        readonly property int ease:     Easing.OutCubic
        readonly property int easeBack: Easing.OutBack
    }
    readonly property Anim anim: Anim {}

    // ── Icons (Nerd Font glyphs) ─────────────────────────────
    component Icons: QtObject {
        readonly property string bolt: String.fromCodePoint(0xF140B) // nf-md-lightning_bolt
    }
    readonly property Icons icons: Icons {}

    // ── UI state (writable) ──────────────────────────────────
    // Named `ui` rather than `state` to avoid clashing with Item.state.
    component Ui: QtObject {
        property bool barOpen:  false
        property bool menuOpen: false
        property string menuPage: "settings"
    }
    readonly property Ui ui: Ui {}

    // ── Helpers ──────────────────────────────────────────────
    function alpha(c: color, a: real): color {
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
