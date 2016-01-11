# require ApiException
module ApiHelper
  def api_request(method:, url:, headers:, payload: nil, user: nil, verify_ssl: true)
    raise TypeError unless method.is_a? Symbol
    if url.nil? || url.blank?
      raise ArgumentError, 'api_request was called with a nil/blank url'
    end

    if user.nil?
      api_call(method, url, headers, payload, verify_ssl)
    else
      basic_auth(user, method, url, headers, payload, verify_ssl)
    end
  rescue RestClient::Exception => error
    logger.error("Unable to connect to #{url}")
    logger.error("The error returned was: #{error.message}")
    # logger.debug("Backtrace:\n#{error.backtrace.join("\n")}")
    raise error
  end

  def api_call(method, url, headers, payload, verify_ssl)
    RestClient::Request.execute method: method, url: url,
                                headers: headers, payload: payload, verify_ssl: verify_ssl  do |resp, request|
      handle_response(resp, request, url)
    end
  end

  def basic_auth(user, method, url, headers, payload, verify_ssl)
    RestClient::Request.execute method: method, url: url,
                                user: user.username, password: user.password,
                                headers: headers, payload: payload, verify_ssl: verify_ssl  do |resp, request|
      handle_response(resp, request, url)
    end
  end

  def handle_response(resp, request, url)
    case resp.code
      when 200..202
        logger.info("#{resp.code} from #{url}.")
        parsed = (JSON.parse(resp))
        logger.debug("The response body has a length of: #{parsed.length}")
        return parsed
      when 400
        logger.warn("Got 400 Bad Request back from #{url}")
        log_request_data(request: request, response: resp, log_level: Logger::ERROR)
        raise ApiException.new '400 Bad Request', resp
      when 401
        logger.warn("Got 401 Unauthorized from #{url}")
        log_request_data(request: request, response: resp, log_level: Logger::ERROR)
        raise ApiException.new '401 Unauthorized', resp
      when 403
        logger.warn("Got 403 Forbidden from #{url}")
        log_request_data(request: request, response: resp, log_level: Logger::ERROR)
        raise ApiException.new '403 Forbidden', resp
      when 404
        logger.warn("Got 404 Not Found from #{url}")
        log_request_data(request: request, response: resp, log_level: Logger::ERROR)
        raise ApiException.new '404 Bad Request', resp
      when 500
        logger.error("Got 500 Internal Server Error from #{url}")
        log_request_data(request: request, response: resp, log_level: Logger::ERROR)
        raise ApiException.new '500 Internal Server Error', resp
      else
        log_request_data(request: request, response: resp, log_level: Logger::FATAL)
        raise ApiException.new "#{resp.code} was unexpected, cannot continue", resp
    end
  end

  def log_request_data(request:, response:, log_level: Logger::WARN)
    logger.add(log_level){'Request and response data below...'}
    logger.add(log_level){"Request method: #{request.method.upcase}"}

    #logging the payload isn't possible currently because of 
    # https://github.com/rest-client/rest-client/issues/357
    unless request.payload.nil?
      # logger.add(log_level){"Request Payload: #{request.payload}"}
      logger.add(log_level){"Request Payload: #{request.args[:payload].inspect}"}
    end

    logger.add(log_level){"Headers: #{request.headers}"}

    unless request.cookies.empty?
      logger.add(log_level){"Cookies: #{request.cookies}"}
    end
    logger.add(log_level){"URL: #{request.url}"}

    if log_level == Logger::DEBUG || log_level > Logger::WARN
      logger.add(log_level){"Response: #{response}"}
    end

    unless response.cookies.empty?
      logger.add(log_level){"Response cookies: #{response.cookies}"}
    end
  end
end