import SwiftUI
import Observation

@Observable
public final class ModalDestination: Identifiable {
    public let id = UUID()
    public let destination: AnyHashable
    public let onDismiss: ((Any?) -> Void)?

    public init(
        destination: AnyHashable,
        onDismiss: ((Any?) -> Void)? = nil
    ) {
        self.destination = destination
        self.onDismiss = onDismiss
    }
}
