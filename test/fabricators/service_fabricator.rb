require 'test_helper'

Fabricator(:service) do
  name { Faker::App.name + rand(10000).to_s }
  url { Faker::Internet.url }
  dns_name { Faker::Internet.domain_name + rand(10000).to_s }
  ip { Faker::Internet.ip_v4_address }
  port { Faker::Number.between(1, 65535) }
end