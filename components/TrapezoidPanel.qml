import QtQuick
import QtQuick.Shapes
import qs

// Trapezoid background glued to a screen edge.
// The wide edge sits against the screen, the sides slope inward, and a
// metallic border runs along the visible edges only (sides + free edge).
// The two free-edge corners can be rounded with `radius`.
//
//   edge: "top"     ‾\______/‾       edge: "left"   |\
//   edge: "bottom"  _/‾‾‾‾‾‾\_                      | |
//                                                   |/
//
// Geometry is described in local terms:
//   u = along the screen edge, v = away from it.
//   innerLength = length of the free edge, depth = distance screen → free edge.
// The item's size follows (`length` along the edge, `depth` across it).
// Put content in a sibling item, not inside this one.
Item {
    id: root

    property string edge: "top"           // "top" | "bottom" | "left" | "right"
    property real innerLength: 100
    property real depth: 40
    property real angle: Globals.style.panelAngle   // side slope vs. the screen edge, degrees; lower = more spread
    property real radius: 0                          // free-edge corner rounding
    property real borderWidth: Globals.style.panelBorder

    // ── Geometry ─────────────────────────────────────────────
    readonly property bool vertical: edge === "left" || edge === "right"
    readonly property real rad: angle * Math.PI / 180
    readonly property real cs: Math.cos(rad)
    readonly property real sn: Math.sin(rad)

    readonly property real slant: depth / Math.tan(rad)             // run of a side along u
    readonly property real length: innerLength + slant * 2           // wide edge length
    readonly property real sideInset: borderWidth / sn               // inner side shift along u
    readonly property real innerSlant: (depth - borderWidth) / Math.tan(rad)

    // free-edge corners (u coordinates), outer and inner
    readonly property real c1: slant
    readonly property real c2: length - slant
    readonly property real i1: sideInset + innerSlant
    readonly property real i2: length - sideInset - innerSlant
    readonly property real vi: depth - borderWidth                   // inner free edge, v

    // rounding: tangent lengths, clamped; inner one shrinks so the border stays even
    readonly property real r: Math.max(0, Math.min(radius, innerLength / 2, depth / sn / 2))
    readonly property real ri: Math.max(0, r - borderWidth * Math.tan(rad / 2))

    implicitWidth: vertical ? depth : length
    implicitHeight: vertical ? length : depth

    // local (u, v) → item (x, y)
    function px(u: real, v: real): real {
        switch (edge) {
        case "left":  return v;
        case "right": return width - v;
        default:      return u;
        }
    }
    function py(u: real, v: real): real {
        switch (edge) {
        case "left":
        case "right":  return u;
        case "bottom": return height - v;
        default:       return v;
        }
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        // ── Fill (outer outline; the opaque border covers its edges) ──
        ShapePath {
            strokeWidth: -1
            fillGradient: LinearGradient {
                x1: root.px(0, 0);           y1: root.py(0, 0)
                x2: root.px(root.length, 0); y2: root.py(root.length, 0)
                GradientStop { position: 0.0; color: Globals.colors.bgEdge }
                GradientStop { position: 0.5; color: Globals.colors.bgMid }
                GradientStop { position: 1.0; color: Globals.colors.bgEdge }
            }

            startX: root.px(0, 0); startY: root.py(0, 0)
            PathLine { x: root.px(root.length, 0); y: root.py(root.length, 0) }
            PathLine { x: root.px(root.c2 + root.r * root.cs, root.depth - root.r * root.sn)
                       y: root.py(root.c2 + root.r * root.cs, root.depth - root.r * root.sn) }
            PathQuad { controlX: root.px(root.c2, root.depth); controlY: root.py(root.c2, root.depth)
                       x: root.px(root.c2 - root.r, root.depth); y: root.py(root.c2 - root.r, root.depth) }
            PathLine { x: root.px(root.c1 + root.r, root.depth); y: root.py(root.c1 + root.r, root.depth) }
            PathQuad { controlX: root.px(root.c1, root.depth); controlY: root.py(root.c1, root.depth)
                       x: root.px(root.c1 - root.r * root.cs, root.depth - root.r * root.sn)
                       y: root.py(root.c1 - root.r * root.cs, root.depth - root.r * root.sn) }
            PathLine { x: root.px(0, 0); y: root.py(0, 0) }
        }

        // ── Border: outer outline minus inner outline (even-odd) ──
        ShapePath {
            strokeWidth: -1
            fillRule: ShapePath.OddEvenFill

            fillGradient: LinearGradient {
                x1: root.px(0, 0);           y1: root.py(0, 0)
                x2: root.px(root.length, 0); y2: root.py(root.length, 0)
                GradientStop { position: 0.00; color: Globals.pal.secdWarm  }
                GradientStop { position: 0.02; color: Globals.pal.midWarm   }
                GradientStop { position: 0.10; color: Globals.pal.primCold  }
                GradientStop { position: 0.50; color: Globals.pal.lightWarm }
                GradientStop { position: 0.90; color: Globals.pal.primCold  }
                GradientStop { position: 0.98; color: Globals.pal.midWarm   }
                GradientStop { position: 1.00; color: Globals.pal.secdWarm  }
            }

            // outer
            startX: root.px(0, 0); startY: root.py(0, 0)
            PathLine { x: root.px(root.length, 0); y: root.py(root.length, 0) }
            PathLine { x: root.px(root.c2 + root.r * root.cs, root.depth - root.r * root.sn)
                       y: root.py(root.c2 + root.r * root.cs, root.depth - root.r * root.sn) }
            PathQuad { controlX: root.px(root.c2, root.depth); controlY: root.py(root.c2, root.depth)
                       x: root.px(root.c2 - root.r, root.depth); y: root.py(root.c2 - root.r, root.depth) }
            PathLine { x: root.px(root.c1 + root.r, root.depth); y: root.py(root.c1 + root.r, root.depth) }
            PathQuad { controlX: root.px(root.c1, root.depth); controlY: root.py(root.c1, root.depth)
                       x: root.px(root.c1 - root.r * root.cs, root.depth - root.r * root.sn)
                       y: root.py(root.c1 - root.r * root.cs, root.depth - root.r * root.sn) }
            PathLine { x: root.px(0, 0); y: root.py(0, 0) }

            // inner
            PathMove { x: root.px(root.sideInset, 0); y: root.py(root.sideInset, 0) }
            PathLine { x: root.px(root.length - root.sideInset, 0); y: root.py(root.length - root.sideInset, 0) }
            PathLine { x: root.px(root.i2 + root.ri * root.cs, root.vi - root.ri * root.sn)
                       y: root.py(root.i2 + root.ri * root.cs, root.vi - root.ri * root.sn) }
            PathQuad { controlX: root.px(root.i2, root.vi); controlY: root.py(root.i2, root.vi)
                       x: root.px(root.i2 - root.ri, root.vi); y: root.py(root.i2 - root.ri, root.vi) }
            PathLine { x: root.px(root.i1 + root.ri, root.vi); y: root.py(root.i1 + root.ri, root.vi) }
            PathQuad { controlX: root.px(root.i1, root.vi); controlY: root.py(root.i1, root.vi)
                       x: root.px(root.i1 - root.ri * root.cs, root.vi - root.ri * root.sn)
                       y: root.py(root.i1 - root.ri * root.cs, root.vi - root.ri * root.sn) }
            PathLine { x: root.px(root.sideInset, 0); y: root.py(root.sideInset, 0) }
        }
    }
}
