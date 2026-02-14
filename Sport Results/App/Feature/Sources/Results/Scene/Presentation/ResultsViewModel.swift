import Domain
import SwiftUI

@Observable
final class ResultsViewModel {

    var matchResults: [MatchResult] = []
    var selectedFilter: MatchResultsFilter = .all
}
