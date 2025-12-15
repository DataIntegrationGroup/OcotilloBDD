@legacy-db @field_PublicRelease
Feature: PublicRelease controls public visibility of sites
  PublicRelease is a legacy BIT field used to determine whether a site is ready for release
  to the public via reports and web maps.
  Interpretation: 0 = false (not released to public), 1 = true (released to public).
  Default: No / false (not released to public).

  Background:
    # Target field: PublicRelease


  # ---------------------------------------------------------------------------
  # Storage-layer / data integrity behavior
  # These scenarios validate accepted inputs and default behavior for the legacy field.
  # ---------------------------------------------------------------------------

  @schema @storage
  Scenario Outline: Accept valid bit values for PublicRelease
    When I insert a site record with PublicRelease set to <input_value>
    Then the record is accepted
    And PublicRelease is interpreted as <boolean_value>
    And the site is <release_state>

    Examples:
      | input_value | boolean_value | release_state         |
      | 0           | false         | not publicly released |
      | 1           | true          | publicly released     |

  @schema @storage
  Scenario: Apply default value when PublicRelease is not provided
    When I insert a new site record without specifying PublicRelease
    Then the record is accepted
    And PublicRelease defaults to false

  @schema @storage @characterization
  Scenario: Define behavior when PublicRelease is explicitly NULL
    When I attempt to insert a site record with PublicRelease set to NULL
    Then the record is rejected

  @schema @storage @characterization
  Scenario Outline: Reject non-bit values for PublicRelease
    When I attempt to insert a site record with PublicRelease set to <invalid_input>
    Then the record is rejected
    And an error indicates PublicRelease must be 0 or 1

    Examples:
        | invalid_input |
        | 2             |
        | -1            |
        | "Yes"         |
        | "True"        |


  # ---------------------------------------------------------------------------
  # Business-level / public-facing behavior
  # These scenarios validate what a public user can observe in reports and web maps.
  # ---------------------------------------------------------------------------

  @business @public @reports @webmaps
  Scenario Outline: PublicRelease determines whether a site is visible to the public
    Given a site exists with PublicRelease set to <input_value>
    When a public user views sites in public reports
    Then the site is <report_visibility>
    When a public user views sites in public web maps
    Then the site is <map_visibility>

    Examples:
      | input_value | report_visibility | map_visibility |
      | 0           | not shown         | not shown      |
      | 1           | shown             | shown          |

  @business @public @reports @webmaps
  Scenario: Sites are not publicly visible by default
    Given a site exists with PublicRelease not set
    When a public user views sites in public reports
    Then the site is not shown
    When a public user views sites in public web maps
    Then the site is not shown

  @business @public @reports @webmaps
  Scenario: Updating PublicRelease to true makes a site publicly visible
    Given a site exists with PublicRelease set to 0
    When the site's PublicRelease is updated to 1
    Then PublicRelease is interpreted as true
    When a public user views sites in public reports
    Then the site is shown
    When a public user views sites in public web maps
    Then the site is shown

  @business @public @reports @webmaps
  Scenario: Updating PublicRelease to false removes a site from public visibility
    Given a site exists with PublicRelease set to 1
    When the site's PublicRelease is updated to 0
    Then PublicRelease is interpreted as false
    When a public user views sites in public reports
    Then the site is not shown
    When a public user views sites in public web maps
    Then the site is not shown