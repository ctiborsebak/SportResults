import Testing
@testable import Results

@Test
func validator_inputs_should_not_be_valid_initially() {
    let validator = AddResultInputStateValidator()
    let state = AddResultInputState()

    let output = validator.validate(state)

    #expect(!output.isMatchNameValid)
    #expect(!output.isLocationNameValid)
    #expect(!output.isDurationValid)
    #expect(!output.isHomeParticipantNameValid)
    #expect(!output.isAwayParticipantNameValid)

    #expect(!output.isValid)
}

@Test
func validator_should_return_true_when_all_requirements_met() {
    let validator = AddResultInputStateValidator()
    var state = AddResultInputState()

    state.matchName = "Derby"
    state.location = "Main Pitch"
    state.hours = 1
    state.homeParticipantName = "Home Team"
    state.awayParticipantName = "Away Team"

    let output = validator.validate(state)

    #expect(output.isMatchNameValid)
    #expect(output.isLocationNameValid)
    #expect(output.isDurationValid)
    #expect(output.isHomeParticipantNameValid)
    #expect(output.isAwayParticipantNameValid)

    #expect(output.isValid)
}

@Test
func validator_should_be_false_if_match_name_is_missing() {
    let validator = AddResultInputStateValidator()
    var state = AddResultInputState()

    state.matchName = ""
    state.location = "Main Pitch"
    state.hours = 1
    state.homeParticipantName = "Home Team"
    state.awayParticipantName = "Away Team"

    let output = validator.validate(state)

    #expect(!output.isMatchNameValid)
    #expect(!output.isValid)
}

@Test
func validator_should_be_false_if_location_is_missing() {
    let validator = AddResultInputStateValidator()
    var state = AddResultInputState()

    state.matchName = "Derby"
    state.location = ""
    state.hours = 1
    state.homeParticipantName = "Home Team"
    state.awayParticipantName = "Away Team"

    let output = validator.validate(state)

    #expect(!output.isLocationNameValid)
    #expect(!output.isValid)
}

@Test
func validator_should_be_false_if_duration_has_not_changed() {
    let validator = AddResultInputStateValidator()
    var state = AddResultInputState()

    state.matchName = "Derby"
    state.location = "Main Pitch"
    state.hours = 0
    state.minutes = 0
    state.seconds = 0
    state.homeParticipantName = "Home Team"
    state.awayParticipantName = "Away Team"

    let output = validator.validate(state)

    #expect(!output.isDurationValid)
    #expect(!output.isValid)
}

@Test
func validator_should_be_false_if_home_participant_is_missing() {
    let validator = AddResultInputStateValidator()
    var state = AddResultInputState()

    state.matchName = "Derby"
    state.location = "Main Pitch"
    state.hours = 1
    state.homeParticipantName = ""
    state.awayParticipantName = "Away Team"

    let output = validator.validate(state)

    #expect(!output.isHomeParticipantNameValid)
    #expect(!output.isValid)
}

@Test
func validator_should_be_false_if_away_participant_is_missing() {
    let validator = AddResultInputStateValidator()
    var state = AddResultInputState()

    state.matchName = "Derby"
    state.location = "Main Pitch"
    state.hours = 1
    state.homeParticipantName = "Home Team"
    state.awayParticipantName = ""

    let output = validator.validate(state)

    #expect(!output.isAwayParticipantNameValid)
    #expect(!output.isValid)
}
