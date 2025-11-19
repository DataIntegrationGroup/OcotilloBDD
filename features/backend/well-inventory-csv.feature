@backend
@BDMS-??
@production
Feature: Bulk upload well inventory from CSV
  As a hydrogeologist or data specialist
  I want to upload a CSV file containing well inventory data for multiple wells
  So that well records can be created efficiently and accurately in the system

  Background:
    Given a functioning api
    And valid lexicon values exist for:
      | contact_role          |
      | contact_type          |
      | phone_type            |
      | email_type            |
      | address_type          |
      | elevation_method      |
      | well_pump_type        |
      | well_purpose          |
      | well_hole_status      |
      | monitoring_frequency  |

  @positive @happy_path @BDMS-??
  Scenario: Uploading a valid well inventory CSV containing required and optional fields
    Given a valid CSV file for bulk well inventory upload
    And my CSV file is encoded in UTF-8 and uses commas as separators
    And my CSV file contains multiple rows of well inventory data
    And the CSV includes required fields:
      | project                 |
      | well_name_point_id      |
      | site_name               |
      | date_time               |
      | field_staff             |
      | utm_easting             |
      | utm_northing            |
      | utm_zone                |
      | elevation_ft            |
      | elevation_method        |
      | measuring_point_height_ft |
    And each "well_name_point_id" value is unique per row
    And "date_time" values are valid ISO 8601 timestamps with timezone offsets (e.g. "2025-02-15T10:30:00-08:00")
    And the CSV includes optional fields when available:
      | field_staff_2                     |
      | field_staff_3                     |
      | contact_1_name                    |
      | contact_1_organization            |
      | contact_1_role                    |
      | contact_1_type                    |
      | contact_1_phone_1                 |
      | contact_1_phone_1_type            |
      | contact_1_phone_2                 |
      | contact_1_phone_2_type            |
      | contact_1_email_1                 |
      | contact_1_email_1_type            |
      | contact_1_email_2                 |
      | contact_1_email_2_type            |
      | contact_1_address_1_line_1        |
      | contact_1_address_1_line_2        |
      | contact_1_address_1_type          |
      | contact_1_address_1_state         |
      | contact_1_address_1_city          |
      | contact_1_address_1_postal_code   |
      | contact_1_address_2_line_1        |
      | contact_1_address_2_line_2        |
      | contact_1_address_2_type          |
      | contact_1_address_2_state         |
      | contact_1_address_2_city          |
      | contact_1_address_2_postal_code   |
      | contact_2_name                    |
      | contact_2_organization            |
      | contact_2_role                    |
      | contact_2_type                    |
      | contact_2_phone_1                 |
      | contact_2_phone_1_type            |
      | contact_2_phone_2                 |
      | contact_2_phone_2_type            |
      | contact_2_email_1                 |
      | contact_2_email_1_type            |
      | contact_2_email_2                 |
      | contact_2_email_2_type            |
      | contact_2_address_1_line_1        |
      | contact_2_address_1_line_2        |
      | contact_2_address_1_type          |
      | contact_2_address_1_state         |
      | contact_2_address_1_city          |
      | contact_2_address_1_postal_code   |
      | contact_2_address_2_line_1        |
      | contact_2_address_2_line_2        |
      | contact_2_address_2_type          |
      | contact_2_address_2_state         |
      | contact_2_address_2_city          |
      | contact_2_address_2_postal_code   |
      | directions_to_site                |
      | specific_location_of_well         |
      | repeat_measurement_permission     |
      | sampling_permission               |
      | datalogger_installation_permission |
      | public_availability_acknowledgement |
      | result_communication_preference   |
      | contact_special_requests_notes    |
      | ose_well_record_id                |
      | date_drilled                      |
      | completion_source                 |
      | total_well_depth_ft               |
      | historic_depth_to_water_ft        |
      | depth_source                      |
      | well_pump_type                    |
      | well_pump_depth_ft                |
      | is_open                           |
      | datalogger_possible               |
      | casing_diameter_ft                |
      | measuring_point_description       |
      | well_purpose                      |
      | well_hole_status                  |
      | monitoring_frequency              |
      | sampling_scenario_notes           |
      | well_measuring_notes              |
      | sample_possible                   |
#    And all optional lexicon fields contain valid lexicon values when provided
#    And all optional numeric fields contain valid numeric values when provided
#    And all optional date fields contain valid ISO 8601 timestamps when provided

    When I upload the file to the bulk upload endpoint
    Then the system returns a 201 Created status code
    And the system should return a response in JSON format
#    And null values in the response are represented as JSON null
    And the response includes a summary containing:
      | total_rows_processed       | 2 |
      | total_rows_imported        | 2 |
      | validation_errors_or_warnings | 0  |
    And the response includes an array of created well objects


  ###########################################################################
  # NEGATIVE VALIDATION SCENARIOS
  ###########################################################################

  @negative @validation @BDMS-??
  Scenario: Upload fails when required fields are missing
    Given my CSV file contains rows missing a required field "well_name_point_id"
    When I upload the file to the bulk upload endpoint
    Then the system returns a 422 Unprocessable Entity status code
    And the system should return a response in JSON format
    And the response includes validation errors for all rows missing required fields
    And the response identifies the row and field for each error
    And no wells are imported

  @negative @validation @BDMS-??
  Scenario: Upload fails when duplicate well_name_point_id values are present
    Given my CSV file contains one or more duplicate "well_name_point_id" values
    When I upload the file to the bulk upload endpoint
    Then the system returns a 422 Unprocessable Entity status code
    And the response includes validation errors indicating duplicated values
    And each error identifies the row and field
    And no wells are imported

  @negative @validation @BDMS-??
  Scenario: Upload fails due to invalid lexicon values
    Given my CSV file contains invalid lexicon values for "contact_role" or other lexicon fields
    When I upload the file to the bulk upload endpoint
    Then the system returns a 422 Unprocessable Entity status code
    And the response includes validation errors identifying the invalid field and row
    And no wells are imported

  @negative @validation @BDMS-??
  Scenario: Upload fails due to invalid date formats
    Given my CSV file contains invalid ISO 8601 date values in the "date_time" field
    When I upload the file to the bulk upload endpoint
    Then the system returns a 422 Unprocessable Entity status code
    And the response includes validation errors identifying the invalid field and row
    And no wells are imported

  @negative @validation @BDMS-??
  Scenario: Upload fails due to invalid numeric fields
    Given my CSV file contains values that cannot be parsed as numeric in numeric-required fields such as "utm_easting"
    When I upload the file to the bulk upload endpoint
    Then the system returns a 422 Unprocessable Entity status code
    And the response includes validation errors identifying the invalid field and row
    And no wells are imported
#
#  @negative @validation @BDMS-??
#  Scenario: Upload fails when conditional address fields are incomplete
#    Given my CSV file includes "contact_address_2_line_1" but omits required conditional fields such as "contact_address_2_city"
#    When I upload the file to the bulk upload endpoint
#    Then the system returns a 422 Unprocessable Entity status code
#    And the response lists conditional field validation errors per row
#    And no wells are imported
#
#
#  ###########################################################################
#  # FILE FORMAT SCENARIOS
#  ###########################################################################
#
  @negative @file_format @BDMS-??
  Scenario: Upload fails when file type is unsupported
    Given I have a non-CSV file
    When I upload the file to the bulk upload endpoint
    Then the system returns a 400 status code
    And the response includes an error message indicating unsupported file type
    And no wells are imported

  @negative @file_format @BDMS-??
  Scenario: Upload fails when the CSV file is empty
    Given my CSV file is empty
    When I upload the file to the bulk upload endpoint
    Then the system returns a 400 status code
    And the response includes an error message indicating an empty file
    And no wells are imported

  @negative @file_format @BDMS-??
  Scenario: Upload fails when CSV contains only headers
    Given my CSV file contains column headers but no data rows
    When I upload the file to the bulk upload endpoint
    Then the system returns a 400 status code
    And the response includes an error indicating that no data rows were found
    And no wells are imported
