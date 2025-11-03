@backend @BDMS-227 @production
Feature: Retrieve additional well information by well name
  As a hydrogeologist or data specialist
  I want to view additional well attributes with specific physical and operational characteristics
  So that I have all necessary well data to confidently complete fieldwork

  Background:
    Given a functioning api
    And the system has valid well and location data in the database

  Scenario: Retrieve additional well information for an existing well
    When the user retrieves the well by ID via path parameter

    # Permissions / Operational OK flags
    And I should see whether repeat measurement permission is granted for the well
    And I should see whether sampling permission is granted for the well
    And I should see whether datalogger installation permission is granted for the well

    # Well Construction Information
    And I should see the completion date of the well
    And I should see the source of the completion information
    And I should see the driller name
    And I should see the construction method
    And I should see the source of the construction information

    # Additional Well Physical Properties
    And I should see the casing diameter in feet
    And I should see the casing depth in feet below ground surface
    And I should see the casing description (previously casing notes field)
    And I should see the well pump type (previously well_type field)
    And I should see the well pump depth in feet
    And I should see whether the well is open and suitable for a datalogger

    # Aquifer / Geology Information
    And I should see the formation as the formation zone of well completion
    And I should see the aquifer class code to classify the aquifer into aquifer system.
    And I should see the aquifer type as the type of aquifers penetrated by the well

    # Well Screens
    And I should see any screen information/intervals associated with the well
