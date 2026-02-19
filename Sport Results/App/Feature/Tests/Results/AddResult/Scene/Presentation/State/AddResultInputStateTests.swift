import Foundation
import Testing
@testable import Results

struct AddResultInputStateTests {

    @Test
    func duration_should_not_be_changed_initially() {
        let state = AddResultInputState()
        #expect(!state.hasDurationChanged)
    }

    @Test
    func duration_should_change_when_hours_modified() {
        var state = AddResultInputState()
        state.hours = 1
        #expect(state.hasDurationChanged)
    }

    @Test
    func duration_should_change_when_minutes_modified() {
        var state = AddResultInputState()
        state.minutes = 30
        #expect(state.hasDurationChanged)
    }

    @Test
    func duration_should_change_when_seconds_modified() {
        var state = AddResultInputState()
        state.seconds = 45
        #expect(state.hasDurationChanged)
    }

    @Test
    func state_should_not_have_changes_initially() {
        let state = AddResultInputState()
        #expect(!state.didChange)
    }

    @Test
    func state_should_register_change_for_matchName() {
        var state = AddResultInputState()
        state.matchName = "Final"
        #expect(state.didChange)
    }

    @Test
    func state_should_register_change_for_location() {
        var state = AddResultInputState()
        state.location = "Stadium"
        #expect(state.didChange)
    }

    @Test
    func state_should_register_change_for_duration() {
        var state = AddResultInputState()
        state.minutes = 90
        #expect(state.didChange)
    }

    @Test
    func state_should_register_change_for_homeParticipantName() {
        var state = AddResultInputState()
        state.homeParticipantName = "Home Team"
        #expect(state.didChange)
    }

    @Test
    func state_should_register_change_for_awayParticipantName() {
        var state = AddResultInputState()
        state.awayParticipantName = "Away Team"
        #expect(state.didChange)
    }

    @Test
    func mandatory_inputs_should_not_be_filled_initially() {
        let state = AddResultInputState()
        #expect(!state.areMandatoryInputsFilled)
    }

    @Test
    func mandatory_inputs_should_be_false_if_any_required_field_is_missing() {
        var state = AddResultInputState()

        state.matchName = "Derby"
        state.location = "Main Pitch"
        state.minutes = 90
        state.homeParticipantName = "Home Team"
        state.awayParticipantName = "Away Team"

        #expect(state.areMandatoryInputsFilled)

        state.location = ""

        #expect(!state.areMandatoryInputsFilled)
    }

    @Test
    func mandatory_inputs_should_be_true_when_all_requirements_met() {
        var state = AddResultInputState()
        state.matchName = "Derby"
        state.location = "Main Pitch"
        state.minutes = 90
        state.homeParticipantName = "Home Team"
        state.awayParticipantName = "Away Team"

        #expect(state.areMandatoryInputsFilled)
    }

    @Test
    func state_should_register_change_for_next_day() {
        var state = AddResultInputState()
        state.date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        #expect(state.didChange)
    }

    @Test
    func state_should_register_change_for_previous_day() {
        var state = AddResultInputState()
        state.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        #expect(state.didChange)
    }

    @Test
    func state_should_not_register_change_for_same_day_time_difference() {
        var state = AddResultInputState()

        state.date = Calendar.current.date(bySettingHour: 12, minute: 34, second: 56, of: state.date)!

        #expect(!state.didChange)
    }
}
