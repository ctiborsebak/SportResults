import Navigation
import SwiftUI
import Theme

struct NoMatchResultsView: View {

    @Environment(Navigator.self) var navigator: Navigator?
    var onSuccessfullAddition: () -> Void

    init(
        onSuccessfullAddition: @escaping () -> Void
    ) {
        self.onSuccessfullAddition = onSuccessfullAddition
    }

    var body: some View {
        VStack(spacing: .small) {
            Spacer()

            "key_no_records".localized.text
                .foregroundStyle(Color.Text.tertiary)
                .font(.title3)

            AppButton(
                onClickAction: {
                    navigator?.presentModalWithResult(ResultsRoute.addResult) { (action: AddResultAction?) in
                        switch action {
                        case .success:
                            onSuccessfullAddition()
                        default:
                            break
                        }
                    }
                },
                icon: Image(systemName: "plus"),
                caption: "key_add_result".localized
            )
            .tint(.Text.primary)

            Spacer()
        }
    }
}

#Preview("NoMatchResultsView") {
    NoMatchResultsView(
        onSuccessfullAddition: {}
    )
}
