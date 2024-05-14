module Interfaces
  # No doc
  class ExternalApi
    def self.call(host, endpoint, method_type, headers = {}, params = {})
      resp = {}
      begin
        headers['Content-Type'] = 'application/json' if headers['Content-Type'].nil?
        url = host + endpoint
        request_hash = { method: method_type, sslversion: :tlsv1_2,
                         headers: headers }.merge!(method_hash(method_type, params))
        request = Typhoeus::Request.new(url, request_hash)
        type = method_type.upcase
        request.on_complete do |response|
          if response.success?
            resp[:body] = begin
                            JSON.parse(response.body)
                          rescue StandardError
                            response.body || {}
                          end
            resp[:code] = 200 if resp.is_a?(Hash)
          elsif response.code.in?([409, 400, 401, 422, 404])
            resp = begin
                     JSON.parse(response.body)
                   rescue StandardError
                     response.body
                   end
            message = resp['message'] || resp['errors'] || resp['metadata'] || resp['msg']
            resp = { status: 'error', code: response.code, msg: message }
          elsif response.timed_out? || response.code.zero? || response.code == 502
            resp = { status: 'error', code: 0, msg: 'Request timed out' }
          else
            parsed_response = JSON.parse(response.body)
            message = parsed_response['message'] || parsed_response['errors']
            resp = { status: 'error', code: response.code, msg: message }
          end
        end
        request.run
      rescue StandardError => e
        resp = { status: 'error', msg: e.message.to_s, code: 500 }
      end
      resp
    end

    def self.method_hash(method_type, params = {})
      data = params.except(:request_body)
      method_type == 'get' && !params[:request_body] ? { params: data } : { body: data.to_json }
    end
  end
end
