Feature: Creating a new RTApi:Connection object

  Scenario: Getting a new API object with required enviroment variables.
    Given the environment variable rt_api_user is "gerald"
    And the environment variable rt_api_pass is "wibble"
    And the environment variable rt_api_url is "http://my.test.url/rt/"
    When a new RTApi::Connection object is created without arguments
    Then the connections username attribute should be "gerald"
    And the connections password attribute should be "wibble"
    And the connections base_url attribute should be "http://my.test.url/rt"
