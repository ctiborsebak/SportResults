import SwiftUI

struct ParticipantView: View {

    let state: State

    struct State {
        let name: String
        let alignment: Alignment
    }

    var body: some View {
        state.name.text
            .foregroundStyle(Color.Text.primary)
            .font(.subheadline)
            .fontWeight(.heavy)
            .multilineTextAlignment(state.alignment == .leading ? .leading : .trailing)
            .frame(maxWidth: .infinity, alignment: state.alignment)
    }
}

#Preview("ParticipantView") {
    ParticipantView(
        state: .init(
            name: "Loko Holesovice",
            alignment: .leading
        )
    )
}
