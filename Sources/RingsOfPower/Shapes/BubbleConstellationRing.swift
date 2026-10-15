import SwiftUI

public struct BubbleConstellationRing: View {

    public let thicknessRatio: CGFloat

    public let strandCount: Int
    public let nodeCount: Int
    public let nodeReach: Int
    public let lineOpacity: CGFloat

    public let bubbleRadius: CGFloat
    public let bubbleThickness: CGFloat

    public init(thicknessRatio: CGFloat = 0.5,
                strandCount: Int = 3,
                nodeCount: Int = 20,
                nodeReach: Int = 1,
                lineOpacity: CGFloat = 0.5,
                bubbleRadius: CGFloat = 12,
                bubbleThickness: CGFloat = 4
    ) {
        self.thicknessRatio = thicknessRatio
        self.strandCount = strandCount
        self.nodeCount = nodeCount
        self.nodeReach = nodeReach
        self.lineOpacity = lineOpacity
        self.bubbleRadius = bubbleRadius
        self.bubbleThickness = bubbleThickness
    }

    public var body: some View {
        Circle()
    }
}
