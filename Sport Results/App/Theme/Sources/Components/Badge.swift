import SwiftUI

public struct Badge: View {
    let state: BadgeState

    public init(state: BadgeState) {
        self.state = state
    }

    public var body: some View {
        state.image
            .fontWeight(.medium)
            .foregroundColor(state.textColor)
            .padding(.xsmall)
            .background(
                state.accentColor
                    .overlay(Color.white.opacity(0.2))
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(state.textColor, lineWidth: 0.5)
            )
    }
}

public struct BadgeState {
    let image: Image
    let accentColor: Color
    let textColor: Color

    public init(
        image: Image,
        accentColor: Color,
        textColor: Color
    ) {
        self.image = image
        self.accentColor = accentColor
        self.textColor = textColor
    }
}

#Preview("Badge") {
    Badge(
        state: .init(
            image: Image(systemName: "square.and.arrow.up.circle"),
            accentColor: .Accent.mint,
            textColor: .Text.mint
        )
    )
}
