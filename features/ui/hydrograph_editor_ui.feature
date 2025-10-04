@ui @hydrograph @visualization @BDMS-150
Feature: Visualize and interact with groundwater level data on hydrograph
  As a hydrogeologist and data manager
  I want to visualize, adjust, and verify groundwater level data in the UI
  So that I can accurately review and correct measurement data using the hydrograph interface

  Background:
    Given I am logged in as a user with the "HydrographEditor" permission
    And I have existing manual and continuous groundwater level data in the system

  @display @visual
  Scenario: Display existing data on hydrograph
    When I open the hydrograph view for a site
    Then I should see manual measurements displayed with manual markers
    And I should see continuous measurements displayed with continuous markers
    And both types should be visually distinguishable by color or shape

  @upload @visual
  Scenario: Display newly uploaded continuous data
    Given I have uploaded new continuous groundwater level data via the upload UI
    When I open the hydrograph view
    Then I should see the new data rendered on the hydrograph
    And the new data should be visually distinct from existing data
    And a legend should indicate each dataset type

  @interaction @alignment
  Scenario: Snap sections of continuous data to manual reference measurements
    Given I have selected a section of continuous data in the UI
    And I have corresponding manual measurements visible
    When I choose "Snap to Manual Reference" from the context menu
    Then the section should visually shift to align with manual measurements
    And a visual indicator should confirm that correction has been applied

  @interaction @manual-adjustment
  Scenario: Manually shift sections of continuous data
    Given I have selected a continuous data section on the hydrograph
    When I manually shift the section upward by X units using the adjustment handle
    Then the graph should update to show values increased by X units
    When I shift the section downward by Y units
    Then the graph should display values decreased by Y units
    And an on-screen note should indicate the applied offset
