Feature: Posting an Item

As a user
I want to be able to post an item
So that I can brag about my bought stuff
  
  Scenario: Posting an item with just a name
    Given I am logged in as marco
    And   I am on my dashboard
    When  I fill in "item[name]" with "Macbook Pro"
    And   I press "Submit"
    Then  I should be on the fill up details page of "Macbook Pro"
