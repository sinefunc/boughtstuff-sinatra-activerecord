Feature: Homepage
  In order to see what boughtstuff is about
  Any user
  Should be able to go to the homepage and see the content

  Scenario: I go to the homepage
    Given I am an anonymous user
    When  I am on /
    Then  I should see "Welcome"
    And   I should see "Login to Twitter"


