@backend @BDMS-221 @production
Feature: Retrieve core well information by well name
  As a hydrogeologist or data specialist
  I want to view clearly labeled core physical attributes and identifiers for the well in a well information page section
  so that I can assess key well characteristics at a glance

  Background:
    Given Ocotillo is running
    And I am an authenticated user

  Scenario: Retrieve core well information for an existing well
    When I retrieve the well record for a given well
    Then I should see the well name (point ID) (i.e. NM-1234)
    And I should see the site name(s) for the well (i.e. John Smith House Well)

    # Well Purpose and Status and Monitoring Status
    And I should see the purpose of the well (current use)
    And I should see the well status of the well as the status of the hole in the ground
    And I should see the monitoring frequency
    And I should see whether the well is currently being monitored with status text if applicable

    # Data Lifecycle and Public Visibility
    # NEEDS USER RESEARCH - keep both under release_status for now?
    And I should see the data lifecycle status of the well record
    # Previously PublicRelease
    And I should see the public visibility/availability status of the well record

    # Well Physical Properties
    And I should see the hole depth in feet
    And I should see the well depth in feet
    And I should see the source of the well depth information

    # Location Information
    And I should see the latitude and longitude in decimal degrees with datum WGS84
    And I should see the UTM coordinates with datum NAD83
    And I should see the elevation in feet with vertical datum NAVD88
    And I should see the elevation method (e.g., interpolated from digital elevation model)

    # Alternate Identifiers
    And I should see any alternate IDs for the well like the USGS site number or the OSE well ID and OSE well tag ID

