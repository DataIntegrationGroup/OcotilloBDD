# Created by jakeross at 10/17/25
@backend
Feature: Retrieve location by well name
  As a field technician
  I want to retrieve the location information for a given well name
  So that I can verify the well's geographical details

  Background:
    Given the system has valid well and location data in the database
    And the user is authenticated as a field technician
    And the system is connected to the data service

  @positive @happy_path
  Scenario: Retrieve location for an existing well
    Given a well named "Well-Alpha" exists with location details
    When the technician retrieves the location for the well "Well-Alpha"
    Then the system should return the location details for that well
    And the response should include latitude, longitude, and elevation