import ModalResult
import Navigation
import SwiftUI

public struct ResultsViewFactory: ViewFactoryType {

    public func makeView(for destination: AnyHashable) -> some View {
        switch destination {

        case let route as ResultsRoute:
            handleResultsRoute(route)

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
            AddResultHostView()

        case .result(let input):
            ModalResultComposer().make(input: input)
        }
    }
}

private struct AddResultHostView: View {
    @Environment(Navigator.self) private var navigator: Navigator?

    var body: some View {
        AddResultComposer().make(
            dismissClosure: { result in
                navigator?.dismissModal(returning: result)
            }
        )
    }
}
