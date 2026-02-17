import Domain
import SwiftUI
import Theme

struct MatchSectionView: View {
    @Binding var inputState: AddResultInputState

    var body: some View {
        VStack(alignment: .leading, spacing: .small) {
            sectionTitle

            Card {
                VStack(spacing: .small) {
                    durationPicker

                    Divider()

                    VStack(spacing: .small) {
                        HStack {
                            homeTeamNameInputField

                            Spacer()

                            awayTeamNameInputField
                        }

                        scoreInputFields
                    }
                }
            }
        }
    }

    private var sectionTitle: some View {
        "key_section_match_information".localized
            .text
            .foregroundStyle(Color.Text.primary)
            .font(.title3)
            .fontWeight(.medium)
    }

    private var durationPicker: some View {
        HStack {
            "key_duration".localized
                .text

            Spacer()

            Group {
                Picker("", selection: $inputState.hours) {
                    ForEach(0..<10) { Text("\($0) h").tag($0) }
                }

                Picker("", selection: $inputState.minutes) {
                    ForEach(0..<60) { Text("\($0) m").tag($0) }
                }

                Picker("", selection: $inputState.seconds) {
                    ForEach(0..<60) { Text("\($0) s").tag($0) }
                }
            }
            .frame(height: .xxlarge)
            .pickerStyle(.wheel)
        }
    }

    private var homeTeamNameInputField: some View {
        TextField("key_home".localized, text: $inputState.homeParticipantName)
    }

    private var awayTeamNameInputField: some View {
        TextField("key_away".localized, text: $inputState.awayParticipantName)
            .multilineTextAlignment(.trailing)
    }

    private var scoreInputFields: some View {
        HStack {
            TextField("key_score".localized, value: $inputState.homeParticipantScore, format: .number)

            Spacer()

            TextField("key_score".localized, value: $inputState.awayParticipantScore, format: .number)
                .multilineTextAlignment(.trailing)
        }
        .font(.largeTitle)
        .fontWeight(.bold)
        .keyboardType(.numberPad)
    }
}

#Preview("MatchSectionView") {
    MatchSectionView(
        inputState: .constant(.init())
    )
}
