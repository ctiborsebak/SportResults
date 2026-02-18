import Domain
import SwiftUI
import Theme

struct ResultsLoadingView: View {
    @State var opacity: CGFloat = 0.4

    let placeholderResults = Array(
        repeating: MatchResult(
            discipline: .basketball,
            name: "           ",
            location: "       ",
            date: Date.now,
            duration: .seconds(48*60),
            persistenceKind: .local,
            home: .init(name: "        ", score: 11),
            away: .init(name: "        ", score: 11)
        ),
        count: 7
    )

    var body: some View {
        List(placeholderResults) {
            MatchResultCard(state: $0)
                .listRowInsets(EdgeInsets(top: .xsmall, leading: .small, bottom: .xsmall, trailing: .small))
                .listRowSeparator(.hidden)
        }
        .redacted(reason: .placeholder)
        .opacity(opacity)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
            ) {
                opacity = 1.0
            }
        }
        .listStyle(.plain)
    }
}

#Preview("ResultsLoadingView") {
    ResultsLoadingView()
}
