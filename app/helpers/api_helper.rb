module ApiHelper
  def api_request(method:, url:, headers:, payload: nil, user: nil, verify_ssl: true)
    if url.nil? || url.blank?
      raise ArgumentError, 'api_request was called with a nil/blank url'
    end
    if user.nil?
      api_call(method, url, headers, payload, verify_ssl)
    else
      basic_auth(user, method, url, headers, payload, verify_ssl)
    end
  end

  def api_call(method, url, headers, payload, verify_ssl)
    response = RestClient::Request.execute method: method,
                                           url: url,
                                           headers: headers,
                                           payload: payload,
                                           verify_ssl: verify_ssl,
                                           timeout: 1
    JSON.parse(response)
  rescue JSON::ParserError
    logger.error 'There was an error parsing an API response. See debug logs for details.'
    # log_request_data(request: request, response: response)
    logger.debug "The error was caused by: #{response.to_s}"
    nil
  end

  def basic_auth(user, method, url, headers, payload, verify_ssl)
    response = RestClient::Request.execute method: method,
                                           url: url,
                                           user: user.username,
                                           password: user.password,
                                           headers: headers,
                                           payload: payload,
                                           verify_ssl: verify_ssl,
                                           timeout: 1
    JSON.parse(response)
  rescue JSON::ParserError
    logger.error 'There was an error parsing an API response. See debug logs for details.'
    # log_request_data(request: request, response: response)
    logger.debug "The error was caused by: #{response.to_s}"
    nil
  end

  # def log_request_data(request:, response:, log_level: Logger::DEBUG)
  #   logger.add(log_level){'Request and response data below...'}
  #   logger.add(log_level){"Request method: #{request.method.upcase}"}
  #
  #   #logging the payload isn't possible currently because of
  #   # https://github.com/rest-client/rest-client/issues/357
  #   unless request.payload.nil?
  #     # logger.add(log_level){"Request Payload: #{request.payload}"}
  #     logger.add(log_level){"Request Payload: #{request.args[:payload].inspect}"}
  #   end
  #
  #   logger.add(log_level){"Headers: #{request.headers}"}
  #
  #   unless request.cookies.empty?
  #     logger.add(log_level){"Cookies: #{request.cookies}"}
  #   end
  #   logger.add(log_level){"URL: #{request.url}"}
  #
  #   if log_level == Logger::DEBUG || log_level > Logger::WARN
  #     logger.add(log_level){"Response: #{response}"}
  #   end
  #
  #   unless response.cookies.empty?
  #     logger.add(log_level){"Response cookies: #{response.cookies}"}
  #   end
  # end
end