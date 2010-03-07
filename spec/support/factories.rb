require 'factory_girl'
require 'faker'

Factory.sequence :login do |n|
  "login#{n}"
end

Factory.sequence :twitter_id do |n|
  "1000#{n}"
end

Factory.define :user do |f|
  f.login       { Factory.next(:login) }
  f.twitter_id  { Factory.next(:twitter_id) } 
  f.name        { Faker::Name.name }
end

Factory.define :item do |f|
  f.association :user
  f.name "Macbook Pro 15"
  f.price_in_dollars 1500
  f.photo { File.open('spec/fixtures/files/avatar.jpg') }
end
