class Ping < ActiveRecord::Base
  belongs_to :service, dependent: :destroy, autosave: true
  
  require 'timeout'
  require 'socket'

  def ping(host)
    begin
      Timeout.timeout(5) do 
        s = TCPSocket.new(host, 'echo')
        s.close
        return true
      end
    rescue Errno::ECONNREFUSED 
      return true
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH
      return false
    end
  end
end
