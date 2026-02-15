import Domain
import SwiftUI
import Theme

struct GeneralSectionView: View {
    @Binding var inputState: AddResultInputState

    var body: some View {
        VStack(alignment: .leading, spacing: .small) {
            sectionTitle

            Card {
                VStack(spacing: .small) {
                    disciplinePicker

                    Divider()

                    nameTextField

                    Divider()

                    locationTextField

                    Divider()

                    datePicker

                    Divider()

                    storagePicker
                }
            }
        }
    }

    private var sectionTitle: some View {
        "key_section_general".localized
            .text
            .foregroundStyle(Color.Text.primary)
            .font(.title3)
            .fontWeight(.medium)
    }

    private var disciplinePicker: some View {
        HStack {
            "key_picker_title".localized.text

            Spacer()

            Picker("key_picker_title".localized, selection: $inputState.selectedDiscipline) {
                ForEach(Discipline.allCases) { discipline in
                    discipline.title.text.tag(discipline)
                }
            }
        }
    }

    private var nameTextField: some View {
        TextField("key_placeholder_match_name".localized, text: $inputState.matchName)
    }

    private var locationTextField: some View {
        TextField("key_placeholder_match_location".localized, text: $inputState.location)
    }

    private var datePicker: some View {
        DatePicker(
            "Datum",
            selection: $inputState.date,
            displayedComponents: [.date]
        )
    }

    private var storagePicker: some View {
        HStack {
            "key_storage_type".localized.text

            Spacer()

            Picker("", selection: $inputState.persistenceKind) {
                ForEach(PersistenceKind.allCases) { kind in
                    kind.title.text.tag(kind)
                }
            }
        }
    }
}

#Preview("GeneralSectionView") {
    GeneralSectionView(
        inputState: .constant(.init())
    )
}
