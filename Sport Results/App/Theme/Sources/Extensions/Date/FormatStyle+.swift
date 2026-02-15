import Foundation

public extension FormatStyle where Self == Date.FormatStyle {

    static var shortMonthDay: Self {
        Date.FormatStyle()
            .month(.abbreviated)
            .day(.defaultDigits)
    }
}
