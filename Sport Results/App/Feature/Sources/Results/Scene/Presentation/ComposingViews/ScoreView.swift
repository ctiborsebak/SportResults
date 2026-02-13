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
                .formatted(.time(pattern: .minuteSecond))
                .text
                .font(.subheadline)
                .foregroundStyle(Color.Text.tertiary)

            ZStack {
                // NOTE: "Spacer" view to ensure that the ":" is always in dead center of the view
                HStack(spacing: .xxsmall) {
                    widestScore
                    Text(":")
                    widestScore
                }
                .opacity(0)

                HStack(spacing: .xxsmall) {
                    state.homeScore.text
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    ":".text

                    state.awayScore.text
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .foregroundStyle(Color.Text.primary)
            .font(.largeTitle)
            .fontWeight(.bold)
            .fixedSize(horizontal: true, vertical: false)
        }
    }

    @ViewBuilder
    private var widestScore: some View {
        let home = state.homeScore
        let away = state.awayScore
        (String(max(home, away))).text
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
