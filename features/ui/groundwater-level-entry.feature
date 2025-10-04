@ui @field-measurement @BDMS-151
Feature: Record groundwater level measurement via mobile form
  As a field technician
  I want to enter and validate groundwater level data in the Ocotillo mobile UI
  So that I can consistently record measurement data in the field

  Background:
    Given I am logged in as a field technician
    And I am at a well site with Ocotillo open on a mobile device

  @happy-path @form-entry
  Scenario: Complete and submit a valid groundwater level measurement
    When I open the "New Measurement" form
    And I enter the well ID "NM-123"
    And I enter the date "2025-10-02" and time "09:30"
    And I enter the measured groundwater level "145.3"
    And I select the measurement method "Electric tape"
    And I enter my initials as the observer
    And I save the form
    Then I should see a confirmation message that the record was saved
    And the new record should appear in the well’s measurement history list

  @validation @required-fields
  Scenario Outline: Required field validation
    When I open the "New Measurement" form
    And I leave the <field> blank
    And I attempt to save the form
    Then I should see an inline error indicating "<field> is required"
    And the form should not be submitted

    Examples:
      | field               |
      | Well ID             |
      | Date                |
      | Time                |
      | Groundwater Level   |
      | Measurement Method  |
      | Observer Initials   |

  @optional-fields
  Scenario Outline: Record optional field values
    When I open the "New Measurement" form
    And I enter a value in the <field> field: "<value>"
    And I save the form
    Then the <field> and value should be displayed in the measurement summary view

    Examples:
      | field                | value                    |
      | Notes                | "Well cap was damaged"   |
      | Environmental Cond.  | "Rainy, muddy conditions"|
      | GPS Coordinates      | "34.051N, 106.892W"      |
      | Depth to Pump Intake | "60 ft"                  |

  @validation @value-check
  Scenario: Invalid groundwater level value
    When I enter "ABC" in the groundwater level field
    And I attempt to save the form
    Then I should see an error indicating "Groundwater level must be numeric"
    And the form should not submit

  @validation @date-check
  Scenario: Invalid date or time entry
    When I enter a future date "2050-01-01"
    And I attempt to save the form
    Then I should see an error indicating "Date cannot be in the future"

  @offline @sync
  Scenario: Record measurement offline
    Given I have no connectivity
    When I fill out and save the "New Measurement" form
    Then I should see a message "Saved locally – will sync when online"
    And the record should appear in my local unsynced records list

  @offline @conflict
  Scenario: Notify user of sync conflict after going online
    Given I recorded a measurement offline
    And another technician has submitted a measurement for the same well and time
    When connectivity is restored and my record syncs
    Then I should see a conflict notification in the app
    And I should be prompted to review and resolve before final submission
