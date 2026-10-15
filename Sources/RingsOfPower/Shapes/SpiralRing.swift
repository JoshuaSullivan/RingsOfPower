import SwiftUI

/// A `Shape` that draws one or more evenly spaced spiral lines winding inward from the outer edge
/// of the circle.
///
/// Each path starts on the outer rim and spirals clockwise (in screen space) toward the center,
/// advancing in radius and angle by a constant amount per segment. The start angles of the paths are
/// spaced evenly around the circle, so every path is a rotated copy of the first. Paths are
/// open polylines, so the shape is meant to be stroked rather than filled.
///
/// The spiral is approximated with straight line segments; raise ``segmentsPerRevolution`` if the
/// curve looks faceted at large sizes.
///
/// ```swift
/// SpiralRing(thicknessRatio: 0.5, pathCount: 3, revolutionCount: 1.5)
///     .stroke(.blue, lineWidth: 2)
/// ```
///
/// The shape draws in the largest centered square that fits the rect it is given.
public nonisolated struct SpiralRing: Shape {

    /// The fraction of the radius that each spiral travels inward, from `0` to `1`.
    ///
    /// A value of `1` sends the spiral to within one segment of the center of the circle; lower
    /// values stop short, leaving an empty hole of radius `(1 - thicknessRatio) × radius`. Clamped
    /// to `0...1` on initialization.
    public let thicknessRatio: CGFloat

    /// The number of spiral paths drawn, spaced evenly around the circle.
    ///
    /// Clamped to a minimum of `1` on initialization.
    public let pathCount: Int

    /// The number of line segments used to draw each complete revolution of a path.
    ///
    /// Higher values give a smoother curve at the cost of more path points. Clamped to a minimum of
    /// `3` on initialization.
    public let segmentsPerRevolution: Int

    /// The number of full revolutions each path makes on its way from the outer rim inward.
    ///
    /// This value can be fractional, such as `1.5`. Larger values wind the spiral more tightly.
    /// Negative values are not allowed.
    public let revolutionCount: CGFloat

    /// The rotation, in radians, applied to every path.
    ///
    /// With a value of `0`, the first path starts at the 3 o'clock position on the outer rim.
    /// Positive values rotate the whole shape clockwise.
    public let rotationOffset: CGFloat

    /// Whether the spiral is drawn clockwise or counterclockwise.
    public let clockwise: Bool

    /// Creates a spiral ring.
    ///
    /// - Parameters:
    ///   - thicknessRatio: The fraction of the radius each spiral travels inward, from `0` to `1`.
    ///     Defaults to `1`.
    ///   - pathCount: The number of spiral paths, spaced evenly around the circle. Defaults to `4`.
    ///   - segmentsPerRevolution: The number of line segments per full revolution of a path.
    ///     Defaults to `60`.
    ///   - revolutionCount: The number of full revolutions each path makes, which may be fractional.
    ///     Must not be negative. Defaults to `2`.
    ///   - rotationOffset: The rotation applied to every path, in radians. Defaults to `0`.
    ///   - clockwise: Determines if the spiral is drawn clockwise or counterclockwise. Defaults to `true`.
    public init(thicknessRatio: CGFloat = 1, pathCount: Int = 4, segmentsPerRevolution: Int = 60, revolutionCount: CGFloat = 2.0, rotationOffset: CGFloat = 0.0, clockwise: Bool = true) {
        self.thicknessRatio = max(0, min(1, thicknessRatio))
        self.pathCount = max(1, pathCount)
        self.segmentsPerRevolution = max(3, segmentsPerRevolution)
        self.revolutionCount = max(0, revolutionCount)
        self.rotationOffset = rotationOffset
        self.clockwise = clockwise
    }

    public nonisolated func path(in rect: CGRect) -> Path {
        let pathSegmentCount = Int(CGFloat(segmentsPerRevolution) * revolutionCount)
        let pathOffset: CGFloat = (2 * .pi) / CGFloat(pathCount)
        let drawRect = rect.centeredSquare()
        let center = drawRect.center
        let radius = drawRect.width * 0.5
        let r0 = radius * (1 - thicknessRatio)
        let dr = (radius - r0) / CGFloat(pathSegmentCount - 1)
        let da: CGFloat = (((2 * .pi) * revolutionCount) / CGFloat(pathSegmentCount - 1)) * (clockwise ? 1 : -1)

        var p = Path()
        for i in 0..<pathCount {
            let a0 = pathOffset * CGFloat(i) + rotationOffset
            var x = cos(a0) * radius + center.x
            var y = sin(a0) * radius + center.y
            p.move(to: .init(x: x, y: y))
            for j in 0..<pathSegmentCount {
                let a = a0 + CGFloat(j) * da
                let r = radius - CGFloat(j) * dr
                x = cos(a) * r + center.x
                y = sin(a) * r + center.y
                p.addLine(to: .init(x: x, y: y))
            }
        }
        return p
    }
}

#Preview {
    VStack {
        SpiralRing()
            .stroke(.red)
        SpiralRing(thicknessRatio: 0.5, pathCount: 3, revolutionCount: 3.66667, rotationOffset: .pi * 0.33333)
            .stroke(.green)
        SpiralRing(thicknessRatio: 0.8 , pathCount: 6, revolutionCount: 0.3333, clockwise: false)
            .stroke(.blue)
    }
    .padding()
}
