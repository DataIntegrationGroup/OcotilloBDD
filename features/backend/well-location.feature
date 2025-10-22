# Created by jakeross at 10/17/25
@backend
Feature: Retrieve a location
  As a user
  I want to retrieve the location information for a given well
  So that I can verify the well's geographical details

  Background:
    Given a functioning api
    And the system has valid well and location data in the database

  @positive @happy_path
  Scenario: Request a location by well name
    When the user requests the location for the well "WL-0001"
    Then the system should return a 200 status code
    And the system should return a response in JSON format
    And the response should include latitude, longitude, and elevation

  @positive @happy_path
  Scenario: Request a location by location id
    When the user requests the location with id 1
    Then the system should return a 200 status code
    And the system should return a response in JSON format
    And the response should include latitude, longitude, and elevation

  @negative @sad_path
  Scenario: Request a location by invalid well name
    When the user requests the location for the well "WL-9999"
    Then the system should return a 404 status code
    And the response should include an error message indicating the well was not found

  @negative @sad_path
  Scenario: Request a location by invalid location_id
    When the user requests the location for id 9999
    Then the system should return a 404 status code
    And the response should include an error message indicating the well was not found
