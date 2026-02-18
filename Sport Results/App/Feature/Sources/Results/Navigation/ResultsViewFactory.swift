import ModalResult
import Navigation
import SwiftUI

public struct ResultsViewFactory: ViewFactoryType {

    public func makeView(for destination: AnyHashable) -> some View {
        switch destination as Any {

        case let route as ResultsRoute:
            handleResultsRoute(route)

        case let route as AddResultRoute:
            handleAddResultRoute(route)

        default:
            EmptyView()
        }
    }
}

@MainActor
private extension ResultsViewFactory {
    @ViewBuilder
    func handleResultsRoute(_ route: ResultsRoute) -> some View {
        switch route {
        case .addResult:
            AddResultComposer().make()

        case .result(let input):
            ModalResultComposer().make(input: input)
        }
    }

    func handleAddResultRoute(_ route: AddResultRoute) -> some View {
        switch route {
        case .result(let input):
            ModalResultComposer().make(input: input)
        }
    }
}
