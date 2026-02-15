import Navigation
import SwiftUI

struct AddResultViewFactory: ViewFactoryType {
    func makeView(for destination: AnyHashable) -> some View {
        if let route = destination as? AddResultRoute {
            switch route {
            case .result:
                // TODO: Navigate to save result result
                Rectangle().foregroundStyle(.mint)
            }
        }
    }
}
