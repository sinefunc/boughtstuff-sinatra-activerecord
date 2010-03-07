require 'factory_girl'
require 'faker'

Factory.sequence :twitter_id do |n|
  "1000#{n}"
end

Factory.sequence :login do |n|
  "login#{n}"
end

Factory.define :user do |f|
  f.login      { Factory.next(:login) }
  f.twitter_id { Factory.next(:twitter_id) }

  f.name 'John Doe'
end

Factory.define :item do |f|
  f.association :user
  f.name "Macbook Pro 15"
  f.price_in_dollars 1500
  f.photo fixture_file_upload('/files/avatar.jpg', 'image/jpg')
end

Factory.define :tempitem do |f|
  f.association :user
  f.photo fixture_file_upload('/files/avatar.jpg', 'image/jpg')
end
