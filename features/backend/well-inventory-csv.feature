@backend @BDMS-?? @production
Feature: Upload a well inventory spreadsheet (CSV)
  As a hydrogeologist or data specialist
  I want to upload a CSV file containing well inventory data for multiple wells
  So that many wells can be imported quickly and accurately into the system

 Background:
    Given a functioning api
    And my CSV file is encoded in UTF-8 and uses commas as separators

  @positive @happy_path
  Scenario: Upload a well inventory CSV with all required and optional fields correctly filled out
    # is provided means the field is required and must be filled out
    # is included if available means the field is optional and may be filled out

    # FIELD NAMES ARE CSV FIELD NAMES, NOT API/DB FIELD NAMES

    # Field Visit Event fields
    And the field "project" is provided
    And the field "well_name_point_id" is provided and unique per row
    And the field "site_name" is provided
    And the field "date_time" is provided as a valid timestamp in ISO 8601 format with timezone offset (UTC-8) such as "2025-02-15T10:30:00Z-08:00"
    And the field "field_staff" is provided and contains the first and last name of the primary person who measured or logged the data
    And the field "field_staff_2" is included if available
    And the field "field_staff_3" is included if available

    # Well Contact (Owner) fields
    And the field "contact_1_name" is provided
    And the field "contact_1_organization" is included if available
    And the field "contact_1_role" is provided and one of the contact_role lexicon values
    And the field "contact_1_type" is provided and one of the contact_type lexicon values

    # Phone and Email fields are optional
    And the field "contact_1_phone_1" is included if available
    And the field "contact_1_phone__1_type" is included if contact_1_phone_1 is provided and is one of the phone_type lexicon values
    And the field "contact_1_phone_2" is included if available
    And the field "contact_1_phone_2_type" is included if contact_1_phone_2 is provided and is one of the phone_type lexicon values
    And the field "contact_1_email_1" is included if available
    And the field "contact_1_email_1_type" is included if contact_1_email_1 is provided and is one of the email_type lexicon values
    And the field "contact_1_email_2" is included if available
    And the field "contact_1_email_2_type" is included if contact_1_email_2 is provided and is one of the email_type lexicon values

    # Address fields are optional
    And the field "contact_1_address_1_line_1" is provided
    And the field "contact_1_address_1_line_2" is included if available
    And the field "contact_1_address_1_type" is provided and one of the address_type lexicon values
    And the field "contact_1_address_1_state" is provided
    And the field "contact_1_address_1_city" is provided
    And the field "contact_1_address_1_postal_code" is provided
    And the field "contact_1_address_2_line_1" is included if available
    And the field "contact_1_address_2_line_2" is included if available
    And the field "contact_1_address_2_type" is included if contact_1_address_2_line_1 is provided and is one of the address_type lexicon values
    And the field "contact_1_address_2_state" is included if contact_1_address_2_line_1 is provided
    And the field "contact_1_address_2_city" is included if contact_1_address_2_line_1 is provided
    And the field "contact_1_address_2_postal_code" is included if contact_1_address_2_line_1 is provided

    # Location notes
    And the field "directions_to_site" is included if available
    And the field "specific_location_of_well" is included if available

    # Permissions
    And the field "repeat_measurement_permission" is included if available as true or false
    And the field "sampling_permission" is included if available as true or false
    And the field "datalogger_installation_permission" is included if available as true or false
    And the field "public_availability_acknowledgement" is included if available as true or false

    # Special requests
    And the field "special_requests" is included if available

    # Location fields
    And the field "utm_easting" is provided as a numeric value in NAD83 UTM Zone 13
    And the field "utm_northing" is provided as a numeric value in NAD83 UTM Zone 13
    And the field "elevation_ft" is provided as a numeric value in NAVD88
    And the field "elevation_method" is provided and one of the elevation_method lexicon values

    # Well attributes
    And the field "ose_well_record_id" is included if available
    And the field "date_drilled" is included if available as a valid date in ISO 8601 format with timezone offset (UTC-8) such as "2025-02-15T10:30:00Z-08:00"
    And the field "completion_source" is included if available
    And the field "total_well_depth_ft" is included if available as a numeric value in feet
    And the field "static_water_depth_ft" is included if available as a numeric value
    And the field "depth_source" is included if available
    And the field "well_pump_type" is included if available and one of the well_pump_type lexicon values
    And the field "well_pump_depth_ft" is included if available as a numeric value in feet
    And the field "is_open" is included if available as true or false
    And the field "datalogger_possible" is included if available as true or false
    And the field "casing_diameter_ft" is included if available as a numeric value in feet
    And the field "measuring_point_height_ft" is provided as a numeric value in feet
    And the field "measuring_point_description" is included if available
    And the field "well_use_purpose" is included if available and one of the well_use_purpose lexicon values
    And the field "well_hole_status" is included if available and one of the well_hole_status lexicon values
    And the field "monitoring_frequency" is included if available and one of the monitoring_frequency lexicon values

    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 201 Created status code
    And the system should return a response in JSON format
    And null values in the response should be represented as JSON null (not placeholder strings)
    
    # Upload Summary
    And the response should include a summary with total rows processed
    And the response should include a summary with total rows successfully imported
    And the response should include a summary with any validation errors or warnings
    
    # Created Well Objects
    And the response should include an array of created water well objects

  @negative @validation
  Scenario: Upload fails due to missing required field in one or more rows
    Given my CSV file contains one or more rows with missing values in the required field "well_name_point_id"
    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 422 Unprocessable Entity status code
    And the system should return a response in JSON format
    And the response should include validation errors for all rows with missing required fields
    And the response should indicate which row and field contains each error
    And no wells should be imported

  @negative @validation
  Scenario: Upload fails due to duplicate well names in one or more rows
    Given my CSV file contains one or more rows with duplicate values in the "well_name_point_id" field
    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 422 Unprocessable Entity status code
    And the system should return a response in JSON format
    And the response should include validation errors for all rows with duplicate well names
    And the response should indicate which row and field contains each error
    And no wells should be imported

  @negative @validation
  Scenario: Upload fails due to invalid lexicon value in one or more rows
    Given my CSV file contains one or more rows with an invalid value in the "contact_1_role" field that is not in the contact_role lexicon
    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 422 Unprocessable Entity status code
    And the system should return a response in JSON format
    And the response should include validation errors for all rows with invalid lexicon values
    And the response should indicate which row and field contains each error
    And no wells should be imported

  @negative @validation
  Scenario: Upload fails due to invalid date format in one or more rows
    Given my CSV file contains one or more rows with an invalid date format in the "date_time" field
    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 422 Unprocessable Entity status code
    And the system should return a response in JSON format
    And the response should include validation errors for all rows with invalid date formats
    And the response should indicate which row and field contains each error
    And no wells should be imported

  @negative @validation
  Scenario: Upload fails due to invalid numeric value in one or more rows
    Given my CSV file contains one or more rows with a value that cannot be parsed as a numeric value in the "utm_easting" field
    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 422 Unprocessable Entity status code
    And the system should return a response in JSON format
    And the response should include validation errors for all rows with invalid numeric values
    And the response should indicate which row and field contains each error
    And no wells should be imported

  @negative @validation
  Scenario: Upload fails due to missing conditional field in one or more rows
    Given my CSV file contains one or more rows that include "contact_1_address_2_line_1" but are missing the required conditional field "contact_1_address_2_city"
    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 422 Unprocessable Entity status code
    And the system should return a response in JSON format
    And the response should include validation errors for all rows with missing conditional fields
    And the response should indicate which row and field contains each error
    And no wells should be imported

@negative @file_format
Scenario: Upload fails due to unsupported file type
    Given I upload a file that is not a CSV file
    When I upload the file to the bulk upload endpoint
    Then the system should return a 400 Bad Request status code
    And the system should return a response in JSON format
    And the response should include an error message indicating the file type is not supported
    And no wells should be imported

@negative @file_format
Scenario: Upload fails due to empty file
    Given my CSV file is empty
    When I upload the file to the bulk upload endpoint
    Then the system should return a 400 Bad Request status code
    And the system should return a response in JSON format
    And the response should include an error message indicating the file is empty
    And no wells should be imported

@negative @file_format
  Scenario: Upload fails due to CSV with only headers and no data rows
    Given my CSV file contains only column headers with no data rows
    When I upload the CSV file to the bulk upload endpoint
    Then the system should return a 400 Bad Request status code
    And the system should return a response in JSON format
    And the response should include an error indicating no data rows found
    And no wells should be imported