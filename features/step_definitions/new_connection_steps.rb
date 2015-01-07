Given(/^the environment variable (\S+) is "(\S+)"$/) do |variable, value|
  ENV[variable] = value
end

Given(/^the options hash with the keys and values$/) do |table|
  @options_hash = table.rows_hash.inject({}) { |opts, (key, value)| opts[key.to_sym] = value; opts }
end

When(/^a new RTApi::Connection object is created without arguments$/) do
  @rt = RTApi::Connection.new
end

When(/^a new RT::Connection object is created with this hash\.$/) do
  @rt = RTApi::Connection.new @options_hash
end

Then(/^a connection object should be returned$/) do
  expect(@rt).to be_an_instance_of(RTApi::Connection)
end

Then(/^the connections (\S+) attribute should be "(.*?)"$/) do |attribute, value|
  expect(@rt.instance_variable_get("@#{attribute}")).to eq(value)
end

Then(/^the connections (\S+) method should return "(.*?)"$/) do |method, result|
  expect(@rt.send(method.to_sym)).to eq(result)
end
