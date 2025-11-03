# Created by jakeross at 10/21/25
@backend @BDMS-199 @BDMS-233 @production
Feature: Retrieve well notes by well name
  As a user
  I want to retrieve well notes for a given well name
  So that I can understand all necessary context about the well using info not captured in structured fields
  Background:
    Given a functioning api
    And the system has valid well and location data in the database

  @positive @happy_path
  Scenario: Retrieve well notes for an existing well
    When the user retrieves the well 1
    Then the system should return a 200 status code
    And the system should return a response in JSON format
    And the response should include location notes
    And the response should include construction notes
    And the response should include casing notes
    And the response should include general well notes
    And the notes should be a non-empty string

  @negative @sad_path
  Scenario: Retrieve well notes for a non-existing well
    When the user retrieves the well 9999
    Then the system should return a 404 status code
    And the system should return a response in JSON format
    And the response should include an error message indicating the well was not found