# Created by jakeross at 10/21/25
@backend @BDMS-199
Feature: Retrieve well notes by well name
  As a user
    I want to retrieve well notes for a given well name
    So that I can view important information about the well's location
    Background:
      Given a functioning api
      And the system has valid well and location data in the database

  @positive @happy_path
  Scenario: Retrieve location notes for an existing well
    When the user retrieves the well "WL-0001"
    Then the system should return a 200 status code
    And the system should return a response in JSON format
    And the response should include notes
    And the notes should be a non-empty string