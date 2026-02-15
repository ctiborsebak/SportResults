import Foundation

public extension String {
    var localized: Self {
        String(localized: LocalizationValue(self), bundle: Localizations.bundle)
    }
}
