@@well_management
@retrieval
@backend
@REQ-WELL-001
@JIRA-1234
Feature: Retrieve deployments and associated sensors by well name
  As a field technician
  I want to retrieve a table of all deployments and associated sensors for a given well name
  So that I can verify configuration and field status for that well

  Background:
    Given the system has valid well and deployment data in the database
    And the user is authenticated as a field technician
    And the system is connected to the data service

  @positive @happy_path
  Scenario: Retrieve deployments and sensors for an existing well
    Given a well named "Well-Alpha" exists with deployments
      | deployment_id | sensor_id | sensor_type   |
      | D001          | S001      | Pressure      |
      | D001          | S002      | Temperature   |
      | D002          | S003      | Flow Rate     |
    When the technician retrieves deployments for the well "Well-Alpha"
    Then the system should return a table containing all deployments and sensors for that well
    And the response should include 3 sensors
    And the table should display columns: "deployment_id", "sensor_id", "sensor_type"

  @edge_case
  Scenario: Retrieve deployments for a well with no sensors
    Given a well named "Well-Beta" exists with deployments but no sensors
      | deployment_id | sensor_id | sensor_type |
      | D010          |           |             |
    When the technician retrieves deployments for the well "Well-Beta"
    Then the system should return a table with deployment rows but no sensor details
    And a message "No sensors associated with this well" should be displayed

  @negative @error_handling
  Scenario: Retrieve deployments for a non-existent well
    Given no well exists named "Well-Zulu"
    When the technician retrieves deployments for the well "Well-Zulu"
    Then the system should display an error message "Well not found"
    And the response table should be empty

  @validation
  Scenario Outline: Validate input for well name
    Given the technician provides a well name <well_name>
    When the technician requests the deployments list
    Then the system should <expected_result>

    Examples:
      | well_name     | expected_result                                 |
      | Well-Alpha    | return the deployments table                    |
      | NULL          | display an error Invalid well name input      |
      | 1234          | display an error Well name must be text value |