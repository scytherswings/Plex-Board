require 'test_helper'

Fabricator(:weather) do
  api_key { Proc.new { rand(36**32).to_s(36) }.call }
  latitude { Proc.new { rand(-90.0..90.0).to_s }.call }
  longitude { Proc.new { rand(-180.0..180.0).to_s }.call }
  # transient :address, :latitude, :longitude, :api_key
  # api_key { |attrs| attrs[:api_key] ? attrs[:api_key] : Proc.new { rand(36**32).to_s(36) }.call }
  # latitude { |attrs| attrs[:latitude] ? attrs[:latitude] : Proc.new { rand(-90.0..90.0).to_s }.call }
  # longitude { |attrs| attrs[:longitude] ? attrs[:longitude] : Proc.new { rand(-180.0..180.0).to_s }.call }
  # address { |attrs| attrs[:address] ? attrs[:address] : nil }
  # address { "bob" }
end


