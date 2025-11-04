@backend @BDMS-221 @production
Feature: Retrieve core well information by well ID
  As a hydrogeologist or data specialist
  I want to view clearly labeled core physical attributes and identifiers for the well in a well information page section
  so that I can assess key well characteristics at a glance

  Background:
    Given a functioning api
    And the system has valid well and location data in the database

  Scenario: Retrieve core well information for an existing well
    When the user retrieves the well by ID via path parameter
    Then the system should return a 200 status code
    And the system should return a response in JSON format
    And null values in the response should be represented as JSON null (not placeholder strings)

    # Well names and projects
    And the response should include the well name (point ID) (i.e. NM-1234)
    And the response should include the project(s) or group(s) associated with the well
    And the response should include the site name(s) for the well (i.e. John Smith House Well)

    # Well Purpose and Status and Monitoring Status
    And the response should include the purpose of the well (current use)
    And the response should include the well status of the well as the status of the hole in the ground
    And the response should include the monitoring frequency (new field)
    And the response should include whether the well is currently being monitored with status text if applicable (from previous status field)

    # Data Lifecycle and Public Visibility
    # NEEDS USER RESEARCH - keep both under release_status for now? (previously PublicRelease)
    And the response should include the release status of the well record

    # Well Physical Properties
    And the response should include the hole depth in feet
    And the response should include the well depth in feet
    And the response should include the source of the well depth information

    # Measuring Point Information
    And the response should include the description of the measuring point
    And the response should include the measuring point height

    # Location Information
    And the response should include the latitude and longitude in decimal degrees with datum WGS84
    And the response should include the UTM coordinates with datum NAD83
    And the response should include the elevation in feet with vertical datum NAVD88
    And the response should include the elevation method (i.e. interpolated from digital elevation model)

    # Alternate Identifiers
    And the response should include any alternate IDs for the well like the USGS site number or the OSE well ID and OSE well tag ID

