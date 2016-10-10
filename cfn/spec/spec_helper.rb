require 'awspec'
require 'base64'
require 'rspec/expectations'
require 'cfndsl'

RSpec::Matchers.define :be_partial_match_of_base64_decoding do |expected|
  match do |actual|
    Base64.decode64(actual).match expected
  end
end


unless ENV['INVENTORY_FILE'].nil?
  env = YAML.load_file(ENV['INVENTORY_FILE'])
  env.each do |key, value|
    ENV[key] = value.to_s
    puts "INJECTING: #{key} = #{value}"
  end
end
