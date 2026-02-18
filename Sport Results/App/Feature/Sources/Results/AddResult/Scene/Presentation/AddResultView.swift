import Domain
import Localizations
import ModalResult
import Navigation
import SwiftUI
import Theme

struct AddResultView: View {

    @Environment(Navigator.self) var navigator: Navigator?
    @State var viewModel: AddResultViewModel

    var body: some View {
        VStack(spacing: .small) {
            closeButton
                .padding(.horizontal, .medium)

            ScrollView {
                VStack(spacing: .large) {
                    GeneralSectionView(inputState: $viewModel.inputState)

                    MatchSectionView(inputState: $viewModel.inputState)

                    saveButton
                }
                .padding(.top, .medium)
                .padding(.horizontal, .medium)
            }
        }
        .foregroundStyle(Color.Text.primary)
        .tint(viewModel.inputState.persistenceKind.textColor)
        .padding(.vertical, .medium)
        .disabled(viewModel.isLoading)
        .hideKeyboardOnTap()
        .onChange(of: viewModel.saveModalResult) { _, newResult in
            handleSaveResultModal(newResult)
        }
    }
}

private extension AddResultView {
    private var saveButton: some View {
        AppButton(
            onClickAction: {
                Task {
                    await viewModel.save()
                }
            },
            icon: viewModel.inputState.persistenceKind.icon,
            caption: "key_save".localized,
            isLoading: viewModel.isLoading
        )
    }

    private var closeButton: some View {
        AppButton(
            onClickAction: {
                // TODO: Should display an alert so that the user MUST confirm match result discard
                navigator?.dismissModal()
            },
            icon: Image(systemName: "xmark"),
            caption: "key_discard".localized
        )
        .tint(.Semantic.error)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func handleSaveResultModal(_ input: ModalResultInput?) {
        guard let resultInput = input else { return }

        navigator?.presentModalWithResult(
            AddResultRoute.result(resultInput),
            onDismiss: { (action: ModalResultAction?) in
                viewModel.resetSaveModal()

                switch action {

                case .success:
                    navigator?.dismissModal(returning: AddResultAction.success)
                case .retry:
                    Task {
                        // NOTE: Edge case -> In case of instantinaious result we have to wait for the modal dismissal animation, else there can be unexpected behavior.
                        try await Task.sleep(for: .seconds(.animationDelay))
                        await viewModel.save()
                    }

                default:
                    break
                }
            }
        )
    }
}

#Preview("AddResultsView") {
    AddResultView(
        viewModel: AddResultViewModel(
            saveResultUseCase: PreviewSaveResultUseCase()
        )
    )
}
