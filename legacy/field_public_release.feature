@legacy-db @field_PublicRelease @cross_functional
Feature: PublicRelease global field behavior
  The PublicRelease bit field exists across multiple legacy tables.
  Data type is consistent (BIT), but constraints (nullability, defaults) vary by table.

  Background:
    Given the target field is "PublicRelease"

  # ---------------------------------------------------------------------------
  # 1. CORE DATA TYPE CHECK (Applies to ALL tables)
  # ---------------------------------------------------------------------------

  @schema @storage
  Scenario Outline: All tables accept valid bit values (0 and 1)
    Given I am targeting the "<table>" table
    When I insert a record with PublicRelease set to <input_value>
    Then the record is accepted
    And the stored value is <input_value>

    Examples:
      | table                          | input_value |
      | Location                       | 0           |
      | Location                       | 1           |
      | WaterLevels                    | 0           |
      | WaterLevels                    | 1           |
      | WaterLevelsContinuous_Acoustic | 0           |
      | WaterLevelsContinuous_Acoustic | 1           |
      | ChemistrySampleInfo            | 0           |
      | ChemistrySampleInfo            | 1           |

  # ---------------------------------------------------------------------------
  # 2. NULLABILITY CHECK (Varies by table)
  #   - Strict: NOT NULL (Location)
  #   - Hybrid: NULL allowed (WaterLevels, WaterLevelsContinuous_Acoustic)
  #   - Loose:  NULL allowed (ChemistrySampleInfo)
  # ---------------------------------------------------------------------------

  @schema @storage @edge_case
  Scenario Outline: Verify NULL acceptance policy per table
    Given I am targeting the "<table>" table
    When I attempt to insert a record with PublicRelease set to NULL
    Then the system should <outcome> the record

    Examples: Strict constraints (NOT NULL)
      | table    | outcome |
      | Location | reject  |

    Examples: Hybrid constraints (NULL allowed, default exists)
      | table                          | outcome |
      | WaterLevels                    | accept  |
      | WaterLevelsContinuous_Acoustic | accept  |

    Examples: Loose constraints (NULL allowed, no default)
      | table               | outcome |
      | ChemistrySampleInfo | accept  |

  # ---------------------------------------------------------------------------
  # 3. DEFAULT VALUE CHECK (Varies by table)
  #   - Default 0: Location, WaterLevels, WaterLevelsContinuous_Acoustic
  #   - No default: ChemistrySampleInfo (remains NULL)
  # ---------------------------------------------------------------------------

  @schema @storage @defaults
  Scenario Outline: Verify default value when field is omitted
    Given I am targeting the "<table>" table
    When I insert a record without specifying PublicRelease
    Then the record is accepted
    And the PublicRelease field should be set to <expected_default>

    Examples: Tables with default ((0))
      | table                          | expected_default |
      | Location                       | 0                |
      | WaterLevels                    | 0                |
      | WaterLevelsContinuous_Acoustic | 0                |

    Examples: Tables with no default (NULL)
      | table               | expected_default |
      | ChemistrySampleInfo | NULL             |

  # ---------------------------------------------------------------------------
  # 4. BUSINESS LOGIC (Public visibility by data type)
  #   PublicRelease indicates whether the data from the table is visible to the public.
  # ---------------------------------------------------------------------------

  @business @public @reports @webmaps
  Scenario Outline: PublicRelease = 1 makes data visible to the public
    Given I am targeting the "<table>" table
    And I have a record with PublicRelease set to 1
    When a public user views the <data_description> in public reports
    Then the <data_description> is visible
    When a public user views the <data_description> in public web maps
    Then the <data_description> is visible

    Examples:
      | table                          | data_description                    |
      | Location                       | location information                |
      | WaterLevels                    | water level measurement information |
      | WaterLevelsContinuous_Acoustic | water level measurement information |
      | ChemistrySampleInfo            | chemistry data                      |

  @business @public @reports @webmaps
  Scenario Outline: PublicRelease = 0 makes data not visible to the public
    Given I am targeting the "<table>" table
    And I have a record with PublicRelease set to 0
    When a public user views the <data_description> in public reports
    Then the <data_description> is not visible
    When a public user views the <data_description> in public web maps
    Then the <data_description> is not visible

    Examples:
      | table                          | data_description                    |
      | Location                       | location information                |
      | WaterLevels                    | water level measurement information |
      | WaterLevelsContinuous_Acoustic | water level measurement information |
      | ChemistrySampleInfo            | chemistry data                      |

  @business @public @reports @webmaps @edge_case
  Scenario Outline: PublicRelease = NULL makes data not visible to the public
    Given I am targeting the "<table>" table
    And I have a record with PublicRelease set to NULL
    When a public user views the <data_description> in public reports
    Then the <data_description> is not visible
    When a public user views the <data_description> in public web maps
    Then the <data_description> is not visible

    Examples:
      | table               | data_description |
      | ChemistrySampleInfo | chemistry data   |
