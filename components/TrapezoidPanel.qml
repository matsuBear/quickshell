import QtQuick
import QtQuick.Shapes
import qs

// Trapezoid background glued to a screen edge.
// The wide edge sits against the screen, the sides slope inward, and a
// metallic border runs along the visible edges only (sides + free edge).
//
//   flip: false → glued to the top    ‾\______/‾   (top bar)
//   flip: true  → glued to the bottom  _/‾‾‾‾‾‾\_   (bottom menu)
//
// Set `innerWidth` (width of the free edge) and `height`; the panel's
// width follows (innerWidth + both slants). Put content in a sibling item,
// not inside this one, so flipping never mirrors your content.
Item {
    id: root

    property real innerWidth: 100
    property real angle: Globals.style.panelAngle
    property real borderWidth: Globals.style.panelBorder
    property bool flip: false

    // geometry
    readonly property real rad: angle * Math.PI / 180
    readonly property real slant: height / Math.tan(rad)                     // horizontal run of a side
    readonly property real sideInset: borderWidth / Math.sin(rad)            // inner side, shifted along x
    readonly property real innerSlant: (height - borderWidth) / Math.tan(rad)

    implicitWidth: innerWidth + slant * 2

    transform: Scale {
        origin.y: root.height / 2
        yScale: root.flip ? -1 : 1
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer   // proper AA without MSAA layers

        // ── Fill (outer polygon; the opaque border covers its edges, so no seam) ──
        ShapePath {
            strokeWidth: -1
            fillGradient: LinearGradient {
                x1: 0;          y1: 0
                x2: root.width; y2: 0
                GradientStop { position: 0.0; color: Globals.colors.bgEdge }
                GradientStop { position: 0.5; color: Globals.colors.bgMid }
                GradientStop { position: 1.0; color: Globals.colors.bgEdge }
        }

            startX: 0; startY: 0
            PathLine { x: root.width;              y: 0 }
            PathLine { x: root.width - root.slant; y: root.height }
            PathLine { x: root.slant;              y: root.height }
            PathLine { x: 0;                       y: 0 }
        }

        // ── Border: outer polygon minus inner polygon (even-odd) ──
        // Both share the screen edge at y = 0, so that edge has no border.
        ShapePath {
            strokeWidth: -1
            fillRule: ShapePath.OddEvenFill

            // Brushed-metal glint: mostly lightWarm, thin dark-cold streaks,
            // soft midWarm shoulders so the streaks don't look like stripes.
            fillGradient: LinearGradient {
                x1: 0;          y1: 0
                x2: root.width; y2: 0          // horizontal: follows the bar's long axis
                GradientStop { position: 0.00; color: Globals.pal.secdWarm  }   // @acct
                GradientStop { position: 0.02; color: Globals.pal.midWarm  }   // @acct
                GradientStop { position: 0.10; color: Globals.pal.primCold  }   // @prim
                GradientStop { position: 0.50; color: Globals.pal.lightWarm }   // @high-tone
                GradientStop { position: 0.90; color: Globals.pal.primCold  }   // @prim
                GradientStop { position: 0.98; color: Globals.pal.midWarm  }   // @prim
                GradientStop { position: 1.00; color: Globals.pal.secdWarm  }   // @acct
            }

            // outer
            startX: 0; startY: 0
            PathLine { x: root.width;              y: 0 }
            PathLine { x: root.width - root.slant; y: root.height }
            PathLine { x: root.slant;              y: root.height }
            PathLine { x: 0;                       y: 0 }

            // inner
            PathMove { x: root.sideInset;                                   y: 0 }
            PathLine { x: root.width - root.sideInset;                      y: 0 }
            PathLine { x: root.width - root.sideInset - root.innerSlant;    y: root.height - root.borderWidth }
            PathLine { x: root.sideInset + root.innerSlant;                 y: root.height - root.borderWidth }
            PathLine { x: root.sideInset;                                   y: 0 }
        }
    }
}
