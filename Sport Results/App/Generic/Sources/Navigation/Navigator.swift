import SwiftUI
import Observation

@Observable
public final class Navigator {

    var path: [AnyHashable] = []
    var dismissClosure: (() -> Void)?
    var presentedModal: AnyHashable?
    var presentedFullScreen: AnyHashable?

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

    public func presentModal(_ destination: AnyHashable) {
        presentedModal = destination
    }

    public func dismissModal() {
        presentedModal = nil
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
