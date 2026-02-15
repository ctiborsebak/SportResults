import Domain
import Localizations
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
                .padding(.horizontal, .medium)
            }
        }
        .foregroundStyle(Color.Text.primary)
        .tint(viewModel.inputState.persistenceKind.textColor)
        .padding(.vertical, .medium)
        .hideKeyboardOnTap()
    }

    private var saveButton: some View {
        AppButton(
            onClickAction: {
                // TODO: ViewModel.save
            },
            icon: viewModel.inputState.persistenceKind.icon,
            caption: "key_save".localized,
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
}

#Preview("AddResultsView") {
    AddResultView(
        viewModel: AddResultViewModel()
    )
}
