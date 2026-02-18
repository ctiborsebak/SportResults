import Localizations
import Navigation
import SwiftUI
import Theme

public struct ModalResultView: View {

    @Environment(Navigator.self) var navigator: Navigator?
    let viewModel: ModalResultViewModel

    public var body: some View {
        VStack {
            labelView

            buttonsView
                .tint(.Text.primary)
        }
    }

    private var labelView: some View {
        VStack(spacing: .small) {
            Spacer()

            viewModel.input.kind.icon
                .resizable()
                .frame(width: .xlarge, height: .xlarge)

            viewModel.input.caption.text
                .foregroundStyle(Color.Text.secondary)
                .font(.title3)

            Spacer()
        }
    }

    @ViewBuilder
    private var buttonsView: some View {
        switch viewModel.input.kind {

        case .success:
            AppButton(
                onClickAction: {
                    navigator?.dismissModal(returning: ModalResultAction.success)
                },
                caption: "key_close".localized
            )

        case .failure:
            HStack(spacing: .small) {
                AppButton(
                    onClickAction: {
                        navigator?.dismissModal(returning: ModalResultAction.retry)
                    },
                    caption: "key_retry".localized
                )

                AppButton(
                    onClickAction: {
                        navigator?.dismissModal()
                    },
                    caption: "key_close".localized
                )
            }
        }
    }
}

#Preview("ModalResultView Success") {
    ModalResultView(
        viewModel: .init(
            input: .init(
                caption: "Success",
                kind: .success
            )
        )
    )
}

#Preview("ModalResultView Failure") {
    ModalResultView(
        viewModel: .init(
            input: .init(
                caption: "Failure",
                kind: .failure
            )
        )
    )
}
