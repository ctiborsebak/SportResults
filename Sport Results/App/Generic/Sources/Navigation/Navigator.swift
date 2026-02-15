import SwiftUI
import Observation

@Observable
public final class Navigator {
    var path: [AnyHashable] = []
    var presentedModals: [ModalDestination] = []
    var presentedFullScreen: AnyHashable?
    var dismissClosure: (() -> Void)?

    public init() {}

    public func dismiss() {
        dismissClosure?()
    }

    public func navigate(to destination: AnyHashable) {
        path.append(destination)
    }

    public func pop() {
        _ = path.popLast()
    }

    public func popToRoot() {
        path.removeAll()
    }

    public func popTo(_ destination: AnyHashable) {
        if let index = path.firstIndex(where: { $0 == destination }) {
            path.removeLast(path.count - index - 1)
        }
    }

    public func presentModal(
        _ destination: AnyHashable,
        onDismiss: ((Any?) -> Void)? = nil
    ) {
        presentedModals.append(
            ModalDestination(destination: destination, onDismiss: onDismiss)
        )
    }

    public func dismissModal(returning result: Any? = nil) {
        if let last = presentedModals.popLast() {
            last.onDismiss?(result)
        }
    }

    public func handleModalDismiss(at index: Int) {
        guard index < presentedModals.count else { return }
        let modal = presentedModals.remove(at: index)
        modal.onDismiss?(nil)
    }

    public func presentFullScreen(_ destination: AnyHashable) {
        presentedFullScreen = destination
    }

    public func dismissFullScreen() {
        presentedFullScreen = nil
    }
}

extension AnyHashable: @retroactive Identifiable {
    public var id: Int { self.hashValue }
}
