require_relative 'spec_helper'

$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'roxy'

# Load a test class
def uses_fixture(fixture_name)
  require_relative "fixtures/#{fixture_name}"
end
