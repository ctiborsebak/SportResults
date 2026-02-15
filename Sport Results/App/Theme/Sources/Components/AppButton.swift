import SwiftUI

public struct AppButton: View {
    let onClickAction: () -> Void
    let icon: Image
    let caption: String
    let isLoading: Bool

    public init(
        onClickAction: @escaping () -> Void,
        icon: Image,
        caption: String,
        isLoading: Bool = false
    ) {
        self.onClickAction = onClickAction
        self.icon = icon
        self.caption = caption
        self.isLoading = isLoading
    }

    public var body: some View {
        Button {
            onClickAction()
        } label: {
            HStack(spacing: .xsmall) {
                switch isLoading {
                case true:
                    ProgressView().progressViewStyle(.circular)
                case false:
                    icon
                }

                caption.text
            }
            .padding(.vertical, .xsmall)
            .padding(.horizontal, .small)
            .font(.headline)
            .fontWeight(.bold)
        }
        .disabled(isLoading)
        .buttonStyle(.bordered)
    }
}

#Preview("AppButton") {
    VStack(spacing: .small) {
        AppButton(
            onClickAction: {},
            icon: Image(systemName: "cloud.circle.fill"),
            caption: "Save Result"
        )

        AppButton(
            onClickAction: {},
            icon: Image(systemName: "cloud.circle.fill"),
            caption: "Save Result",
            isLoading: true
        )

    }
}
