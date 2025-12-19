@legacy-db @chemistry_domain @business-rules
Feature: Chemistry sampling events provide the organizing context for field and laboratory results
  Chemistry data is organized around a sampling event.
  Each sampling event represents one collection occurrence and provides the context needed
  to interpret field measurements and laboratory analytical results.

  Background:
    Given a sampling location exists

  # ---------------------------------------------------------------------------
  # 1) Sampling event meaning (Chemistry SampleInfo)
  # ---------------------------------------------------------------------------

  @business-meaning
  Scenario: A sampling event is the authoritative parent record for chemistry results
    When a chemistry sampling event is recorded
    Then the event is assigned a system identifier used to link chemistry results
    And the event is assigned a required tracking identifier used by people to reference the sample
    And the event captures sampling context such as methods and tracking information

  @data-quality
  Scenario: A sampling event must include basic classification information
    When a chemistry sampling event is recorded without a sample type
    Then the sampling event is not considered valid for downstream use
    When a chemistry sampling event is recorded without a collection method
    Then the sampling event is not considered valid for downstream use

  @identity
  Scenario: The sample tracking identifier uniquely identifies a sampling event
    When a chemistry sampling event is recorded with tracking identifier "SAMP000001"
    Then the sampling event is accepted
    When another chemistry sampling event is recorded with tracking identifier "SAMP000001"
    Then the sampling event is not accepted because the tracking identifier must be unique

  @legacy-behavior
  Scenario: Legacy sampling events may exist without a location link
    When a chemistry sampling event is recorded without a location link
    Then the event is stored
    And the event is treated as incomplete for location-based reporting

  # ---------------------------------------------------------------------------
  # 2) Laboratory & Field Results
  # ---------------------------------------------------------------------------

  @business-meaning @relationships
  Scenario Outline: All analytical results must be attributable to a specific sampling event
    Given a chemistry sampling event exists
    When <result_type> results are recorded for the event
    Then the results are linked to that specific sampling event
    And multiple <result_type> records may exist for the same event

    Examples:
      | result_type                                |
      | Field Parameter                            |
      | Major Ion Chemistry                        |
      | Minor, Trace, Isotope, and Age-Related     |
      | Radionuclide                               |

  @data-quality @integrity
  Scenario Outline: Analytical results cannot exist without a parent sampling event
    When <result_type> results are submitted without a reference to a sampling event
    Then the system prevents the results from being stored
    And orphaned analytical data is not retained

    Examples:
      | result_type                                |
      | Field Parameter                            |
      | Major Ion Chemistry                        |
      | Minor, Trace, Isotope, and Age-Related     |
      | Radionuclide                               |

  # ---------------------------------------------------------------------------
  # 3) Interpreting repeated measurements (legacy looseness / real-world workflows)
  # ---------------------------------------------------------------------------

  @legacy-behavior
  Scenario Outline: Repeated measurements may exist for the same sample and measurement type
    Given a chemistry sampling event exists
    When a "<result_type>" result is recorded for "<measurement_identifier>"
    And another "<result_type>" result is recorded for the same "<measurement_identifier>" under the same event
    Then both results are retained
    And consumers treat them as multiple measurements (e.g., repeats, reruns, corrections, or parallel reporting)

    Examples:
      | result_type                                | measurement_identifier |
      | Major Ion Chemistry                        | Calcium                |
      | Minor, Trace, Isotope, and Age-Related     | Arsenic                |
      | Field Parameter                            | Temperature            |
      | Radionuclide                               | Uranium                |

  # ---------------------------------------------------------------------------
  # 4) Data stewardship expectations for removals (danger zone)
  # ---------------------------------------------------------------------------

  @stewardship @danger_zone
  Scenario: Removing a sampling event removes associated results to avoid stranded data
    Given a chemistry sampling event exists
    And analytical results exist under that event
    When the sampling event is removed
    Then associated field and laboratory results are also removed
    And the system does not retain unattached result records

  @stewardship @danger_zone
  Scenario: Removing a location can remove all chemistry collected at that location
    Given a location exists with one or more chemistry sampling events
    And analytical results exist under those sampling events
    When the location is removed
    Then the sampling events and their associated results are also removed
    And this behavior is treated as a high-impact data stewardship operation

  # ---------------------------------------------------------------------------
  # 5) Retrieval expectations (how the data is consumed)
  # ---------------------------------------------------------------------------

  @reporting
  Scenario: A complete chemistry record can be assembled for a sampling event
    Given a chemistry sampling event exists
    And any combination of field and laboratory results exist for the event
    When a user requests chemistry data for the sampling event
    Then the response includes the sampling event context
    And includes all available field measurements recorded under the event
    And includes all available laboratory results recorded under the event

  @reporting
  Scenario: Chemistry data can be retrieved for a location across sampling events
    Given a location has multiple chemistry sampling events
    When a user requests chemistry data for the location
    Then the response includes all sampling events linked to that location
    And each sampling event includes its associated field and laboratory results
