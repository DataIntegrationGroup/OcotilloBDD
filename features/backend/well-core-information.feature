@backend @production
Feature: Retrieve core well information by well name
  As a hydrogeologist or data specialist
  I want to retrieve core well information for a given well in the Ocotillo system
  So that I can view the well details and associated information

  Background:
    Given Ocotillo is running
    And I am an authenticated user

  Scenario: Retrieve core well information for an existing well
    When I retrieve the core well information for a given well
    Then I should see the well name (point ID)

    # CurrentLocation Information
    And I should see the latitude and longitude in decimal degrees with datum WGS84
    And I should see the elevation in feet with vertical datum NAVD88
    And I should see the elevation method (e.g., interpolated from digital elevation model)
    And I should see the UTM coordinates with datum NAD83
    And I should see a way to download the Location Info data

    # Contacts Information (i.e. Owners)
    And I should see the current owner and primary contact information including the name, role, organization, phone number, and email address

    # Alternate Identifiers
    And I should see any alternate IDs for the well like the USGS site number or the OSE well ID and OSE well tag ID

    # Well Notes (general & status/location/measurement)
    And I should see any notes associated with the well, whether they are location notes, construction notes, casing notes, or general well notes

    # Well Construction Information
    And I should see the completion date of the well
    And I should see the source of the completion information
    And I should see the driller name
    And I should see the construction method
    And I should see the source of the construction information

    # Well Depth and Dimensions
    And I should see the well depth in feet
    And I should see the source of the well depth information
    And I should see the hole depth in feet
    And I should see the casing diameter in feet
    And I should see the casing depth in feet below ground surface
    And I should see the well pump type
    And I should see the well pump depth

    # Measuring Point Information
    And I should see the description of the measuring point
    And I should see the measuring point height

    # Aquifer / Geology Information
    And I should see the formation
    And I should see the formation / lithology description
    And I should see the source of the aquifer and geology information

    # Well Purpose and Status
    And I should see the purpose of the well
    And I should see the well status of the well as the status of the hole in the ground

    # Monitoring Information
    And I should see the monitoring frequency
    And I should see whether the well is currently being monitored with status text if applicable

    # Permissions / Operational OK flags
    And I should see whether installation is allowed at this well
    And I should see whether monitoring permission has been granted
    And I should see whether sampling is allowed at this well
    And I should see whether the well is open and suitable for a logger

    # Screened Intervals
    And I should see any screen information/intervals associated with the well

    # Well Observations
    And I should see water level observations associated with the well including the observed property and value

