import Domain
import SwiftUI

struct MatchMetadataView: View {

    let state: State

    struct State {
        let name: String
        let location: String
        let date: Date
        let persistenceKind: PersistenceKind
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .xsmall) {
            state.name.text
                .lineLimit(1)
                .font(.headline)
                .foregroundStyle(state.persistenceKind.textColor)

            String(
                state.date.formatted(.shortMonthDay)
                + " • "
                + state.location
            )
            .text
            .lineLimit(1)
            .font(.caption)
            .foregroundStyle(Color.Text.secondary)
        }
    }
}

#Preview("MatchMetadataView") {
    MatchMetadataView(
        state: .init(
            name: "Derby",
            location: "FK Loko Holesovice",
            date: Date.now,
            persistenceKind: .remote
        )
    )
}
