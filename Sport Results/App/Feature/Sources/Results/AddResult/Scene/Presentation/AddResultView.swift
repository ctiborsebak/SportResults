import Domain
import Localizations
import Navigation
import SwiftUI
import Theme

struct AddResultView: View {

    @Environment(Navigator.self) var navigator: Navigator?
    @State var viewModel: AddResultViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .large) {
                GeneralSectionView(inputState: $viewModel.inputState)

                MatchSectionView(inputState: $viewModel.inputState)

                saveButton
            }
            .padding(.horizontal, .medium)
        }
        .foregroundStyle(Color.Text.primary)
        .tint(viewModel.inputState.persistenceKind.textColor)
        .padding(.vertical, .medium)
        .hideKeyboardOnTap()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                closeButton
            }
        }
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
        Button {
            navigator?.dismiss()
        } label: {
            "key_close".text
        }
    }
}

#Preview("AddResultsView") {
    AddResultView(
        viewModel: AddResultViewModel()
    )
}
