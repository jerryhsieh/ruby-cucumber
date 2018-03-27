
##
## Given 
##
Given("I am on the home page") do
  visit "/"
end


Given("I am on {string}") do |string|
  visit string
end


##
## When
##

When("I fill in {string} with {string}") do |element, text|
  fill_in element, with: text  
end

When("I click {string}") do |string|
  click_on string
end

##
## Then
##

Then("I should see {string}") do |string|
  page.should have_content string
end

Then("I should see {string} in the selector {string}") do |text, selector|
  page.should have_selector selector,  text: text
end

Then("I should see {string} in a link") do |string|
  page.should have_link string
end

