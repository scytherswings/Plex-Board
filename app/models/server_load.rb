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

class ServerLoad < ActiveRecord::Base
  belongs_to :service
  
end
