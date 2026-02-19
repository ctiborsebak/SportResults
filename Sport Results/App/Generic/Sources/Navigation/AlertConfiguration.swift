import SwiftUI

public struct AlertAction: Identifiable, Equatable {

    public let id = UUID()
    public let title: String
    public let role: ButtonRole?
    public let action: (() -> Void)?

    public init(title: String, role: ButtonRole? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.role = role
        self.action = action
    }

    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        lhs.id == rhs.id
    }
}

public struct AlertConfiguration: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let actions: [AlertAction]

    public init(
        title: String,
        message: String? = nil,
        actions: [AlertAction] = []
    ) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}
