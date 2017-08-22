# == Schema Information
#
# Table name: services
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  dns_name            :string
#  ip                  :string
#  url                 :string           not null
#  port                :integer          not null
#  service_flavor_id   :integer
#  service_flavor_type :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

Fabricator(:service) do
  transient :s_name, :s_url, :s_dns_name, :s_ip, :s_port
  name { |attrs| attrs[:s_name] ? attrs[:s_name] : Faker::App.name + rand(10000).to_s }
  url { |attrs| attrs[:s_url] ? attrs[:s_url] : Faker::Internet.url }
  dns_name { |attrs| attrs[:s_dns_name] ? attrs[:s_dns_name] : Faker::Internet.domain_name + rand(10000).to_s }
  ip { |attrs| attrs[:s_ip] ? attrs[:s_ip] : Faker::Internet.ip_v4_address }
  port { |attrs| attrs[:s_port] ? attrs[:s_port] : Faker::Number.between(1, 65535) }
end
