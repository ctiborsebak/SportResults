import Domain
import SwiftUI

struct PersistenceIcon: View {

    let state: State

    struct State {
        let kind: PersistenceKind
    }

    var body: some View {
        state.kind.icon
            .foregroundStyle(state.kind.textColor)
    }
}

#Preview("PersistenceIcon") {
    VStack(spacing: .small) {
        ForEach(PersistenceKind.allCases) {
            PersistenceIcon(state: .init(kind: $0))
        }
    }
}
