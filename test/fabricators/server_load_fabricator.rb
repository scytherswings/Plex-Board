# == Schema Information
#
# Table name: server_loads
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  service_host_id :integer
#

require 'test_helper'
Fabricator(:server_load) do
  name  "MyString"
  order 1
end
