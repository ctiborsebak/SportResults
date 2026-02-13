import SwiftUI

public struct Card<Content: View>: View {

    private let accentColor: Color
    private let content: Content

    public init(
        accentColor: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.accentColor = accentColor
        self.content = content()
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.small)
            .background(
                RoundedRectangle(cornerRadius: .medium,)
                    .fill(accentColor)
            )
    }
}

#Preview("Card") {
    Card(accentColor: .Accent.blue) {
        VStack(alignment: .leading, spacing: .small) {
            "Title".text
                .font(.title)

            Button("Button") {}
        }
    }
}
