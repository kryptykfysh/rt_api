Given(/^a valid RTApi::Connection object$/) do
  @rt = RTApi::Connection.new(
    username:       'test_user',
    password:       'test_password',
    base_url:       'http://my.rt/'
  )
end

Given(/^a valid ticket id "(.*?)"$/) do |ticket_id|
  @ticket_id = ticket_id
end

Given(/^a ticket comment "(.*?)"$/) do |comment|
  @comment = comment
end

When(/^I call the comment method on the connection with ticket_id and comment arguments$/) do
  @rt.update(ticket_id: @ticket_id, comment: @comment)
end
