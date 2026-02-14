import Localizations
import SwiftUI

public extension String {
    var text: some View {
        Text(LocalizedStringKey(self), bundle: Localizations.bundle)
    }
}
