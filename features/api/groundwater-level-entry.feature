@backend @field-measurement @BDMS-151
Feature: Process, validate, and sync groundwater measurement data
  As a backend system
  I want to validate, store, and synchronize groundwater measurement data
  So that all measurements are accurate, consistent, and traceable

  Background:
    Given the system has a valid field technician account
    And well site "NM-123" exists in the database

  @storage @happy-path
  Scenario: Persist valid groundwater measurement
    Given a valid measurement submission for well "NM-123"
    When the backend receives the payload
    Then the record should be saved to the database with all required fields
    And an audit log entry should record the submitter and timestamp

  @validation @required-fields
  Scenario Outline: Reject submission with missing required fields
    Given a measurement submission with missing <field>
    When the backend validates the request
    Then the response should indicate "Missing required field: <field>"
    And the record should not be stored

    Examples:
      | field               |
      | well_id             |
      | date                |
      | time                |
      | groundwater_level   |
      | method              |
      | observer_initials   |

  @validation @value-check
  Scenario: Reject invalid groundwater level values
    Given a measurement payload with groundwater_level="ABC"
    When the backend validates the submission
    Then the response should include "Groundwater level must be numeric"
    And the record should be rejected

  @validation @date-check
  Scenario: Reject invalid date or time
    Given a measurement payload with a date in the future
    When the backend validates the submission
    Then the response should include "Date cannot be in the future"

  @offline-sync
  Scenario: Sync offline-stored record when connectivity restored
    Given a record stored locally on a mobile device
    When connectivity is restored and sync begins
    Then the backend should accept the record and insert it into the main dataset
    And mark the sync as successful in the user’s sync log

  @conflict-resolution
  Scenario: Handle sync conflict for duplicate time entries
    Given two records exist for well "NM-123" at timestamp "2025-10-02 09:30"
    And one was submitted offline after the online version already exists
    When the offline record syncs
    Then the backend should detect the conflict
    And return a conflict response with both record payloads
    And flag the conflict for user resolution
