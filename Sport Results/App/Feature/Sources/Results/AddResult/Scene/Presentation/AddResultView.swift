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
            discardButton
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
        .onChange(of: viewModel.isPresentingProvideAllInputsAlert) { _, isPresenting in
            handleProvideAllResultsAlert(isPresenting)
        }
        .onChange(of: viewModel.isPresentingDiscardChangesAlert) { _, isPresenting in
            handleDiscardChangesAlert(isPresenting)
        }
        .onChange(of: viewModel.isDismissing) { _, isDismissing in
            handleDismiss(isDismissing)
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

    private var discardButton: some View {
        AppButton(
            onClickAction: {
                viewModel.discard()
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
                        await viewModel.save()
                    }

                default:
                    break
                }
            }
        )
    }

    private func handleProvideAllResultsAlert(_ isPresenting: Bool) {
        guard isPresenting else { return }

        let alertConfiguration = AlertConfiguration(
            title: "key_provide_all_fields_alert".localized,
            actions: [
                AlertAction(title: "key_close".localized) {
                    viewModel.hideAlert()
                }
            ]
        )

        navigator?.presentAlert(configuration: alertConfiguration)
    }

    private func handleDiscardChangesAlert(_ isPresenting: Bool) {
        guard isPresenting else { return }

        let alertConfiguration = AlertConfiguration(
            title: "key_discard_confirm_alert".localized,
            actions: [
                .init(title: "key_discard".localized, role: .destructive) {
                    viewModel.dismiss()
                },
                .init(title: "key_close".localized, role: .cancel) {
                    viewModel.hideAlert()
                }
            ]
        )

        navigator?.presentAlert(configuration: alertConfiguration)
    }

    private func handleDismiss(_ isDismissing: Bool) {
        guard isDismissing else { return }

        navigator?.dismissModal()
    }
}

#Preview("AddResultsView") {
    AddResultView(
        viewModel: AddResultViewModel(
            saveResultUseCase: PreviewSaveResultUseCase(),
            addResultInputStateConverter: AddResultInputStateConverter()
        )
    )
}
