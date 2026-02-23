import SwiftUI
import Observation

@MainActor
@Observable
public final class Navigator {
    var path: [AnyHashable] = []
    var presentedModals: [ModalDestination] = []
    var presentedFullScreen: AnyHashable?
    var presentedAlert: AlertConfiguration?
    var dismissClosure: (() -> Void)?
    @ObservationIgnored
    private var deferredAfterDismissActions: [() -> Void] = []

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
        onDismiss: (() -> Void)? = nil
    ) {
        presentedModals.append(
            ModalDestination(
                destination: destination,
                onDismiss: onDismiss.map { action in { _ in action() } }
            )
        )
    }

    public func presentModalWithResult<T>(
        _ destination: AnyHashable,
        onDismiss: @escaping (T?) -> Void
    ) {
        presentedModals.append(
            ModalDestination(destination: destination) { anyResult in
                let typedResult = anyResult as? T
                onDismiss(typedResult)
            }
        )
    }

    public func dismissModal(returning result: Any? = nil) {
        if let last = presentedModals.popLast() {
            enqueueDeferredAfterDismissAction {
                last.onDismiss?(result)
            }
        }
    }

    public func presentFullScreen(_ destination: AnyHashable) {
        presentedFullScreen = destination
    }

    public func dismissFullScreen() {
        presentedFullScreen = nil
    }

    public func presentAlert(
        configuration: AlertConfiguration
    ) {
        presentedAlert = configuration
    }

    public func dismissAlert() {
        presentedAlert = nil
    }

    public func dismissAlert(perform action: (() -> Void)?) {
        if let action {
            enqueueDeferredAfterDismissAction(action)
        }
        presentedAlert = nil
    }
}

extension Navigator {
    func handleModalDismiss(at index: Int) {
        guard index < presentedModals.count else { return }

        let modal = presentedModals.remove(at: index)
        modal.onDismiss?(nil)
    }

    func handleAlertDismiss() {
        Task { @MainActor in
            // NOTE: Native alert doesnt have onDismiss closure, we are effectively making one. This was an issue when the alert was dismissing a modal, the dismissal animation was not animated properly and looked kind of janky.
            try? await Task.sleep(for: .seconds(0.1))
            runNextDeferredAfterDismissActionIfNeeded()
        }
    }

    func handlePresentationDismissCompletion() {
        runNextDeferredAfterDismissActionIfNeeded()
    }

    private func enqueueDeferredAfterDismissAction(_ action: @escaping () -> Void) {
        deferredAfterDismissActions.append(action)
    }

    private func runNextDeferredAfterDismissActionIfNeeded() {
        guard !deferredAfterDismissActions.isEmpty else { return }

        let deferredAction = deferredAfterDismissActions.removeFirst()
        deferredAction()
    }
}

extension AnyHashable: @retroactive Identifiable {
    public var id: Int { self.hashValue }
}
