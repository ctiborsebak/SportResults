import SwiftUI

struct ScoreView: View {

    let state: State

    struct State {
        let homeScore: Int
        let awayScore: Int
        let duration: Duration
    }

    var body: some View {
        VStack(spacing: .zero) {
            state.duration
                .formatted(.time(pattern: .hourMinuteSecond))
                .text
                .font(.subheadline)
                .foregroundStyle(Color.Text.tertiary)

            ScoreLayout(spacing: .xxsmall) {
                Text("\(state.homeScore)")
                Text(":")
                Text("\(state.awayScore)")
            }
            .foregroundStyle(Color.Text.primary)
            .font(.largeTitle)
            .fontWeight(.bold)
        }
    }
}

// NOTE: This layout ensures that the ":" is always in dead center of the view -> looks better / uniformed. This workaround has a disadvantage though, the scores take up the frame of the wider of these two numbers, therefore a text around score (3000:0) will get wrapped around the frame width of "3000" on both sides, this edge case logic should be revisited.
private struct ScoreLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let homeSize = subviews[0].sizeThatFits(.unspecified)
        let colonSize = subviews[1].sizeThatFits(.unspecified)
        let awaySize = subviews[2].sizeThatFits(.unspecified)

        let maxSideWidth = max(homeSize.width, awaySize.width)

        let totalWidth = (maxSideWidth * 2) + colonSize.width + (spacing * 2)
        let totalHeight = max(homeSize.height, max(colonSize.height, awaySize.height))

        return CGSize(width: totalWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let homeSize = subviews[0].sizeThatFits(.unspecified)
        let colonSize = subviews[1].sizeThatFits(.unspecified)
        let awaySize = subviews[2].sizeThatFits(.unspecified)

        let maxSideWidth = max(homeSize.width, awaySize.width)

        let homeX = bounds.minX + maxSideWidth - homeSize.width
        subviews[0].place(at: CGPoint(x: homeX, y: bounds.minY), proposal: .unspecified)

        let colonX = bounds.minX + maxSideWidth + spacing
        subviews[1].place(at: CGPoint(x: colonX, y: bounds.minY), proposal: .unspecified)

        let awayX = bounds.minX + maxSideWidth + colonSize.width + (spacing * 2)
        subviews[2].place(at: CGPoint(x: awayX, y: bounds.minY), proposal: .unspecified)
    }
}

#Preview("ScoreView") {
    ScoreView(
        state: .init(
            homeScore: 200,
            awayScore: 1,
            duration: .seconds(90 * 60)
        )
    )
}
