class ApplicationController < ActionController::Base
  around_action :exception_handling

  def exception_handling
    begin
      yield
    rescue StandardError => e
      render_error(request, e, :bad_request)
    rescue ArgumentError => e
      render_error(request, e, :unprocessable_entity)
    rescue ActiveRecord::RecordNotFound => e
      render_error(request, e, :not_found)
    rescue => e
      render_error(request, e, :internal_server_error)
    end
  end

  def render_error(request, e, status)
    status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    render json: ErrorHandler.new(status, status_code, e.message).to_json, status: status_code and return
  end
end
