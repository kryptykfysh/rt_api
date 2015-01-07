Feature: Creating a new RTApi:Connection object

  Scenario: Getting a new API object with required enviroment variables.
    Given the environment variable rt_api_user is "gerald"
    And the environment variable rt_api_pass is "wibble"
    And the environment variable rt_api_url is "http://my.test.url/rt/"
    And the environment variable rt_api_path is "/wombles/1.0/"
    When a new RTApi::Connection object is created without arguments
    Then a connection object should be returned
    And the connections username attribute should be "gerald"
    And the connections password attribute should be "wibble"
    And the connections base_url attribute should be "http://my.test.url/rt"
    And the connections path attribute should be "/wombles/1.0/"
    And the connections full_path method should return "http://my.test.url/rt/wombles/1.0/"

  Scenario: Getting a new API Connection object using an options hash.
    Given the options hash with the keys and values
      | key       | value             |
      | username  | test_user         |
      | password  | test_password     |
      | base_url  | http://test_url   |
      | path      | /test/path/       |
    When a new RT::Connection object is created with this hash.
    Then a connection object should be returned
    And the connections username attribute should be "test_user"
    And the connections password attribute should be "test_password"
    And the connections base_url attribute should be "http://test_url"
    And the connections path attribute should be "/test/path/"
    And the connections full_path method should return "http://test_url/test/path/"
