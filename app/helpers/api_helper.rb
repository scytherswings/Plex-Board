# require ApiException
module ApiHelper
  def api_request(method:, url:, headers:, payload: nil, user: nil, verify_ssl: true)
    raise TypeError unless method.is_a? Symbol
    if url.nil? || url.blank?
      raise ArgumentError, 'api_request was called with a nil/blank url'
    end
    # if method == :post && payload.nil?
    #   raise ArgumentError, 'api_request POST method was called for without a payload'
    # end

    begin
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
  end

  def api_call(method, url, headers, payload, verify_ssl)
    RestClient::Request.execute method: method, url: url,
                                headers: headers, payload: payload, verify_ssl: verify_ssl  do |resp, request|
      case resp.code
        when 200..202
          logger.info("#{resp.code} from #{url}.")
          parsed = (JSON.parse(resp))
          logger.debug("The response body has a length of: #{parsed.length}")
          return parsed
        when 401
          logger.warn("Got 401 Unauthorized from #{url}")
          log_request_data(request: request, response: resp, log_level: Logger::ERROR)
          raise ApiException.new '401 Unauthorized', resp
        when 403
          logger.warn("Got 403 Forbidden from #{url}")
          log_request_data(request: request, response: resp, log_level: Logger::ERROR)
          raise ApiException.new '403 Forbidden', resp
        when 400
          logger.warn("Got 400 Bad Request back from #{url}")
          log_request_data(request: request, response: resp, log_level: Logger::ERROR)
          raise ApiException.new '400 Bad Request', resp
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
  end

  def basic_auth(user, method, url, headers, payload, verify_ssl)
    RestClient::Request.execute method: method, url: url,
                                user: user.username, password: user.password,
                                headers: headers, payload: payload, verify_ssl: verify_ssl  do |resp, request|
      case resp.code
        when 200..202
          logger.info("#{resp.code} from #{url}.")
          return (JSON.parse(resp))
        when 401
          logger.warn("Got 401 Unauthorized from #{url}")
          log_request_data(request: request, response: resp, log_level: Logger::ERROR)
          raise ApiException.new '401 Unauthorized', resp
        when 403
          logger.warn("Got 403 Forbidden from #{url}")
          log_request_data(request: request, response: resp, log_level: Logger::ERROR)
          # raise RestClient::Exception
          raise ApiException.new '403 Forbidden', resp
        when 400
          logger.warn("Got 400 Bad Request back from #{url}")
          log_request_data(request: request, response: resp, log_level: Logger::ERROR)
          raise ApiException.new '400 Bad Request', resp
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
  end

  # def cookie_auth(user, method, url, headers, payload, executed = false)
  #
  #   if user.cookie.nil?
  #     return basic_auth(user, method, url, headers, payload)
  #   end
  #   head = headers.dup
  #   logger.info('Using Cookie Auth')
  #   logger.debug("Cookie looks like: #{user.cookie}")
  #   cookie = JSON.parse(user.cookie)
  #   RestClient::Request.execute method: method, url: url,
  #                               headers: headers, payload: payload,
  #                               cookies: cookie do |resp, request, result, &block|
  #
  #     case resp.code
  #       when 200..202
  #         logger.info("#{resp.code} from #{url}.")
  #         log_request_data(user: user, request: request, response: resp, log_level: Logger::INFO, clear_cookie: false)
  #         parsed = (JSON.parse(resp))
  #         if parsed.length > 0
  #           logger.debug("The response body has a length of: #{parsed.length}")
  #           logger.debug("The response is: #{resp}")
  #           return parsed
  #         else
  #           logger.warn("Got empty response from #{url}, clearing cookie just in case")
  #           user.update!(:cookie => nil)
  #           return parsed
  #         end
  #       when 401
  #         logger.warn("Got 401 Unauthorized from #{url}")
  #         logger.warn('Cookie was bad, authenticating')
  #         logger.warn('Resetting headers to remove bad cookie')
  #         log_request_data(user: user, request: request, response: resp)
  #         return basic_auth(user, method, url, head, payload)
  #       when 400
  #         logger.warn("Got 400 Bad Request from #{url}")
  #         log_request_data(user: user, request: request, response: resp)
  #         logger.warn('Going to be optimistic and try normal auth')
  #         return basic_auth(user, method, url, head, payload)
  #       when 404
  #         logger.warn("Got 404 Not Found from #{url}")
  #         log_request_data(user: user, request: request, response: resp)
  #         if !executed
  #           logger.warn('Sleeping for 500ms and trying again')
  #           sleep(0.5)
  #           cookie_auth(user, method, url, headers, payload, true)
  #         else
  #           logger.warn('API query-retry failed after waiting 500ms.')
  #         end
  #         raise ApiException.new '404 Bad Request', resp
  #       when 500
  #         logger.warn("Got 500 Internal Server Error from #{url}")
  #         log_request_data(user: user, request: request, response: resp)
  #         logger.warn('Going to be optimistic and try normal auth')
  #         return basic_auth(user, method, url, head, payload)
  #     end
  #   end
  # end


  def log_request_data(request:, response:, log_level: Logger::WARN)
    raise TypeError unless request.is_a? RestClient::Request

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