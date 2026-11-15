import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import qs

// Three layered blades fanning out of a screen corner.
//
// Local frame: origin at the corner, u along one screen edge, v along the other.
//   - The front blade's curve runs from Z = (zU, 0) on the u axis to A = (aU, aV).
//   - Each blade behind peels off the one in front of it (tangentially, at
//     `branches[k]` along that curve) and lands further out on the u axis at `ends[k]`.
// Each blade is the region between its curve and the two screen edges, so only
// the sliver beyond the blade in front of it is visible.
//
// Children of a Fan are content: they live in window coordinates and slide
// with the front blade.
Item {
    id: root

    // ── Corner + axes ────────────────────────────────────────
    property bool cornerLeft: true          // corner on the left (else right) screen edge
    property bool cornerTop: false          // corner on the top (else bottom) screen edge
    property bool uVertical: false    // u runs along the vertical screen edge (else the horizontal one)

    // ── Shape (px) ───────────────────────────────────────────
    property real zU: 300                   // front blade, where it meets the u axis
    property real aU: 100                   // front blade, far end
    property real aV: 600
    property real bow: 0                    // front curve bulge; + = toward the corner
    property var ends: [400, 500]           // middle / back blades, where they meet the u axis
    property var branches: [0.7, 0.5]       // where each peels off its parent (0 = u-axis end, 1 = far end)
    property real peel: 0.2                 // how long a blade hugs its parent before diverging

    // ── Behaviour ────────────────────────────────────────────
    property bool shown: false
    property int stagger: Globals.anim.stagger   // delay between blades sliding

    default property alias content: contentLayer.data

    // ── Geometry ─────────────────────────────────────────────
    // geo[k] = [p0, p1, p2]: quadratic curve of blade k (0 = front), from the u axis outward
    readonly property var geo: {
        const Z = [zU, 0], A = [aU, aV];
        const dx = A[0] - Z[0], dy = A[1] - Z[1], len = Math.hypot(dx, dy);
        const M = [(Z[0] + A[0]) / 2 - dy / len * bow, (Z[1] + A[1]) / 2 + dx / len * bow];
        const out = [[Z, M, A]];
        for (let k = 0; k < 2; ++k) {
            const P = out[k], t = branches[k];
            const B = bez(P, t), T = tangent(P, t), tl = Math.hypot(T[0], T[1]);
            const E = [ends[k], 0];
            const h = peel * Math.hypot(B[0] - E[0], B[1] - E[1]);
            out.push([E, [B[0] - T[0] / tl * h, B[1] - T[1] / tl * h], B]);
        }
        return out;
    }

    function bez(P: var, t: real): var {
        const s = 1 - t;
        return [s * s * P[0][0] + 2 * s * t * P[1][0] + t * t * P[2][0],
                s * s * P[0][1] + 2 * s * t * P[1][1] + t * t * P[2][1]];
    }
    function tangent(P: var, t: real): var {
        return [2 * (1 - t) * (P[1][0] - P[0][0]) + 2 * t * (P[2][0] - P[1][0]),
                2 * (1 - t) * (P[1][1] - P[0][1]) + 2 * t * (P[2][1] - P[1][1])];
    }

    // u of the front curve at a given v: use it to fit content inside the front blade
    function frontUAt(v: real): real {
        const P = geo[0];
        const v0 = P[0][1], v1 = P[1][1], v2 = P[2][1];
        const a = v0 - 2 * v1 + v2, b = 2 * (v1 - v0), c = v0 - v;
        let t;
        if (Math.abs(a) < 1e-6) {
            t = -c / b;
        } else {
            const s = Math.sqrt(Math.max(0, b * b - 4 * a * c));
            t = (-b + s) / (2 * a);
            if (t < 0 || t > 1) t = (-b - s) / (2 * a);
        }
        return bez(P, Math.min(1, Math.max(0, t)))[0];
    }

    // local (u, v) → item (x, y)
    function mx(u: real, v: real): real {
        const d = uVertical ? v : u;
        return cornerLeft ? d : width - d;
    }
    function my(u: real, v: real): real {
        const d = uVertical ? u : v;
        return cornerTop ? d : height - d;
    }

    // ── Blades, back to front ────────────────────────────────
    Blade {
        fan: root
        index: 2
        castShadow: true
        GradientStop { position: 0.0; color: Globals.pal.primCold }
        GradientStop { position: 1.0; color: Globals.pal.lightWarm }
    }
    Blade {
        fan: root
        index: 1
        castShadow: true
        GradientStop { position: 0.0;  color: Globals.pal.midLightCold }
        GradientStop { position: 0.65; color: Globals.pal.midWarm }
        GradientStop { position: 1.0;  color: Globals.pal.primWarm }
    }
    Blade {
        id: front
        fan: root
        index: 0
        castShadow: true
        GradientStop { position: 0.0;  color: Globals.pal.midDarkCold }
        GradientStop { position: 0.45; color: Globals.pal.secdCold }
        GradientStop { position: 1.0;  color: Globals.pal.midLightCold }
    }

    // content rides along with the front blade
    Item {
        id: contentLayer
        anchors.fill: parent
        transform: Translate {
            x: front.slideX * front.off
            y: front.slideY * front.off
        }
    }

    // ─────────────────────────────────────────────────────────
    component Blade: Item {
        id: blade

        required property var fan          // the Fan (inline components can't see outer ids)
        property int index
        property bool castShadow: false
        default property alias stops: grad.stops

        readonly property var g: fan.geo[index]

        anchors.fill: parent

        // ── slide: each blade starts `index * stagger` ms after the front one ──
        property bool open: false
        property real off: 1     // 0 = in place, 1 = pushed off-screen
        NumberAnimation {
            id: slide
            target: blade
            property: "off"
        }

        Timer {
            id: delay
            // opening: front first (0, 1, 2); closing: back first (2, 1, 0)
            interval: (fan.shown ? blade.index : 2 - blade.index) * fan.stagger
            onTriggered: {
                const opening = fan.shown;
                slide.stop();
                slide.from = blade.off;          // start from wherever it is (handles reversal)
                slide.to = opening ? 0 : 1;
                slide.duration = opening ? Globals.anim.normal : Globals.anim.close;
                slide.easing.type = opening ? Globals.anim.ease : Globals.anim.easeIn;
                slide.start();
            }
        }
        Connections {
            target: fan
            function onShownChanged() { delay.restart(); }
        }
        Component.onCompleted: off = fan.shown ? 0 : 1
        // push out along -u by the whole window
        readonly property real reach: fan.uVertical ? fan.height : fan.width
        readonly property real slideX: fan.mx(-reach, 0) - fan.mx(0, 0)
        readonly property real slideY: fan.my(-reach, 0) - fan.my(0, 0)
        transform: Translate {
            x: blade.slideX * blade.off
            y: blade.slideY * blade.off
        }

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            // the shadow is rendered once into a texture; sliding moves the
            // parent, so it is not recomputed during the animation
            layer.enabled: blade.castShadow
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "black"
                shadowOpacity: Globals.style.shadowOpacity
                shadowBlur: Globals.style.shadowBlur
                // cast away from the corner, along +u
                shadowHorizontalOffset: (fan.mx(1, 0) - fan.mx(0, 0)) * Globals.style.shadowOffset
                shadowVerticalOffset:   (fan.my(1, 0) - fan.my(0, 0)) * Globals.style.shadowOffset
            }

            ShapePath {
                strokeWidth: -1
                fillGradient: LinearGradient {
                    id: grad
                    // corner → middle of the blade's curved edge
                    x1: fan.mx(0, 0)
                    y1: fan.my(0, 0)
                    x2: fan.mx(blade.g[1][0], blade.g[1][1])
                    y2: fan.my(blade.g[1][0], blade.g[1][1])
                }

                startX: fan.mx(0, 0); startY: fan.my(0, 0)
                PathLine { x: fan.mx(blade.g[0][0], blade.g[0][1]); y: fan.my(blade.g[0][0], blade.g[0][1]) }
                PathQuad {
                    controlX: fan.mx(blade.g[1][0], blade.g[1][1]); controlY: fan.my(blade.g[1][0], blade.g[1][1])
                    x: fan.mx(blade.g[2][0], blade.g[2][1]);        y: fan.my(blade.g[2][0], blade.g[2][1])
                }
                // back to the v axis (hidden behind the blade in front), then home
                PathLine { x: fan.mx(0, blade.g[2][1]); y: fan.my(0, blade.g[2][1]) }
                PathLine { x: fan.mx(0, 0); y: fan.my(0, 0) }
            }
        }
    }
}
