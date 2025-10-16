@backend @hydrograph @data-correction @BDMS-150
Feature: Process and correct groundwater level datasets
  As a system data processor
  I want to apply reference alignment and correction logic to continuous groundwater data
  So that corrected datasets are accurate, auditable, and traceable

  Background:
    Given the system has continuous and manual groundwater level data loaded
    And the user performing corrections has the "HydrographEditor" permission

  @data-merge
  Scenario: Integrate new continuous data into existing dataset
    Given the user uploads new continuous groundwater level data for Site A
    When the data import job processes the upload
    Then the new records should be stored with timestamps and metadata
    And data lineage should record the source file and upload user

  @data-alignment
  Scenario: Apply snapping correction to continuous data
    Given a continuous dataset and corresponding manual reference points exist
    When the system receives a "snap to manual reference" instruction
    Then the continuous data values within the selected range should be adjusted
    And the offset applied should be recorded in the correction log

  @data-adjustment
  Scenario: Apply manual vertical shifts to continuous data
    Given a continuous dataset segment is selected for adjustment
    When a vertical shift of +X units is requested
    Then the stored data values in that range should increase by X
    And correction metadata should store the offset and operator ID

  @auto-detection
  Scenario: Automatically detect systematic measurement offsets
    Given the system contains continuous acoustic sensor data
    When an automated offset analysis job runs
    Then the algorithm should identify sections with consistent bias exceeding threshold
    And flagged offsets should be written to the correction queue
    And a notification should be raised for review or automatic correction
