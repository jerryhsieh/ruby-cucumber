require_relative '../../myapp'
require 'Capybara'
require 'Capybara/cucumber'
require 'rspec'

Capybara.app = MyApp


class SomeWorld
  include Capybara::DSL

  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  SomeWorld.new
end
