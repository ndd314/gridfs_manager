Given(/^Doctor Who is a user with a home folder$/) do
  doctor_who
end

Given(/^Dr\. Who's home folder is empty$/) do
end

And(/^a GET request to "([^"]*)" returns an empty "([^"]*)"/) do |url, datatype|
  get url
  payload[datatype.pluralize].should be_empty
end

When(/^I POST this "([^"]*)" JSON to "([^"]*)":$/) do |datatype, url, json|
  post_json(url, json)
end

Then(/^a GET request to "([^"]*)" should include the following "([^"]*)":$/) do |url, datatype, json|
  get url
  puts payload
  puts "sub_folders = #{current_user.home_folder.sub_folders.count}"
  payload[datatype.pluralize].first.should include JSON.parse(json)
end

And(/^Doctor Who sign\-in to the gridfs navigator$/) do
  authenticate email: 'dr_who@sjsu.edu'
end
