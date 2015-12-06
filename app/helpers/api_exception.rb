class APIException < RestClient::Exception
  def initialize(message, response)

    self.message = message
    self.response = response
  end
end