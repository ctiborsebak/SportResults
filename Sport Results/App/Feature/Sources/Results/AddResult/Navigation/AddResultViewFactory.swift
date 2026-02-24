import ModalResult
import Navigation
import SwiftUI

struct AddResultViewFactory: ViewFactoryType {

    func makeView(for destination: AnyHashable) -> some View {
        switch destination {

        case let route as AddResultRoute:
            handleAddResultsRoute(route)

        default:
            EmptyView()
        }
    }
}

@MainActor
private extension AddResultViewFactory {
    func handleAddResultsRoute(_ route: AddResultRoute) -> some View {
        switch route {
        case .result(let input):
            ModalResultComposer().make(input: input)
        }
    }
}
