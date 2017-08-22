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

class ServerLoadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
