import SwiftUI

public struct ModalResultInput: Equatable, Hashable {
    let caption: String
    let kind: ResultKind

    public init(
        caption: String,
        kind: ResultKind
    ) {
        self.caption = caption
        self.kind = kind
    }

    public enum ResultKind {
        case success
        case failure
    }
}

extension ModalResultInput.ResultKind {
    var icon: Image {
        switch self {

        case .failure:
            return .init(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.multicolor)


        case .success:
            return .init(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.multicolor)
        }
    }
}

