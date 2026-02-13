import Domain
import Foundation
import SwiftUI
import Theme

struct MatchResultCard: View {
    let state: MatchResult

    init(state: MatchResult) {
        self.state = state
    }

    var body: some View {
        Card(accentColor: state.persistenceKind.accentColor) {
            VStack(alignment: .leading, spacing: .small) {
                HStack(spacing: .xsmall) {
                    Badge(
                        state: .init(
                            image: state.discipline.icon,
                            accentColor: state.persistenceKind.accentColor,
                            textColor: state.persistenceKind.textColor
                        )
                    )

                    MatchMetadataView(
                        state: .init(
                            name: state.name,
                            location: state.location,
                            date: state.date,
                            persistenceKind: state.persistenceKind
                        )
                    )

                    Spacer()

                    PersistenceIcon(
                        state: .init(
                            kind: state.persistenceKind
                        )
                    )
                }

                HStack(spacing: .xsmall) {
                    ParticipantView(
                        state: .init(
                            name: state.home.name,
                            alignment: .leading
                        )
                    )

                    HStack(spacing: .xxsmall) {
                        ScoreView(
                            state: .init(
                                homeScore: state.home.score,
                                awayScore: state.away.score,
                                duration: state.duration
                            )
                        )
                        .padding(.horizontal, .xsmall)
                    }

                    ParticipantView(
                        state: .init(
                            name: state.away.name,
                            alignment: .trailing
                        )
                    )
                }
            }
        }
    }
}

#Preview("MatchResultCard") {
    MatchResultCard(
        state: .init(
            discipline: .soccer,
            name: "Derby",
            location: "FK Loko Holešovice",
            date: Date.now,
            duration: Duration.seconds(90 * 60),
            persistenceKind: .local,
            home: .init(
                name: "FK Loko Holešovice",
                score: 20
            ),
            away: .init(
                name: "Horní Počernice",
                score: 1
            )
        )
    )
}
