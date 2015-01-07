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
    And the connections :full_path method should return "http://my.test.usr/rt/wombles/1.0/"
