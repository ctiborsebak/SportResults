import Navigation
import SwiftUI

public struct ResultsViewFactory: ViewFactoryType {
    public func makeView(for destination: AnyHashable) -> some View {
        if let route = destination as? ResultsRoute {
            switch route {
            case .addResult:
                AddResultComposer().make()
            }
        }
    }
}
