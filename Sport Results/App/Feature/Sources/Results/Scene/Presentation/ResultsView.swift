import Localizations
import Navigation
import SwiftUI

public struct ResultsView: View {

    @Environment(Navigator.self) var navigator: Navigator?
    @State var viewModel: ResultsViewModel

    public var body: some View {
        VStack(spacing: .medium) {
            Picker("", selection: $viewModel.selectedFilter) {
                "key_filter_all".text.tag(MatchResultsFilter.all)
                "key_filter_local".text.tag(MatchResultsFilter.local)
                "key_filter_remote".text.tag(MatchResultsFilter.remote)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, .small)

            List(viewModel.matchResults) { result in
                MatchResultCard(state: result)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // TODO: Viewmodel delete(result)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                    // NOTE: The horizontal padding has to be applied to the items itself, not the whole List, otherwise the scroll indicator would be padded aswell -> missplaced
                    .listRowInsets(EdgeInsets(top: .xsmall, leading: .small, bottom: .xsmall, trailing: .small))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .padding(.vertical, .small)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("key_results_title".localized)
        .toolbar {
            ToolbarItem {
                Button {
                    navigator?.presentModal(ResultsRoute.addResult)
                } label: {
                    Image(systemName: "plus")
                        .padding(.xsmall)
                }
            }
        }
    }
}

#Preview("ResultsView") {
    let viewModel = ResultsViewModel()
    viewModel.matchResults = .init(
        repeating: .init(
            discipline: .basketball,
            name: "Našinci",
            location: "Sokol Pisek",
            date: Date.now,
            duration: .seconds(48*60),
            persistenceKind: .local,
            home: .init(name: "Sršni Písek", score: 3333),
            away: .init(name: "TJ Sokol Blatná", score: 3)
        ),
        count: 10
    )

    return ResultsView(
        viewModel: viewModel
    )
}
