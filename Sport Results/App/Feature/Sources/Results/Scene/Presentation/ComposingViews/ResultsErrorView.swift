import SwiftUI
import Theme

struct ResultsErrorView: View {

    private var onRetry: () -> Void

    init(onRetry: @escaping () -> Void) {
        self.onRetry = onRetry
    }

    var body: some View {
        VStack(spacing: .small) {
            Spacer()

            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.multicolor)
                .resizable()
                .frame(width: .xlarge, height: .xlarge)

            "Something went wrong".text
                .font(.title3)
                .foregroundStyle(Color.Text.tertiary)

            Spacer()

            AppButton(
                onClickAction: onRetry,
                caption: "key_retry".localized
            )
            .tint(Color.Text.primary)
        }
        .padding(.small)
    }
}

#Preview("ResultsErrorView") {
    ResultsErrorView(onRetry: {})
}
