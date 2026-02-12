import Results
import SwiftUI

@main
struct Sport_ResultsApp: App {
    var body: some Scene {
        WindowGroup {
            ResultsComposer().make()
        }
    }
}
