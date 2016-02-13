require 'test_helper'

Fabricator(:service) do
  name { Faker::App.name }
  url { Faker::Internet.url }
  port { Faker::Number.between(1, 65535) }
end