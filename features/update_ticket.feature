Feature: Updating an existing ticket

  Scenario: Adding a comment
    Given a valid RTApi::Connection object
    And a valid ticket id "12345"
    And a ticket comment "This is a new ticket comment"
    When I call the update method on the connection with ticket_id and comment arguments
    Then the ticket should have the new comment
