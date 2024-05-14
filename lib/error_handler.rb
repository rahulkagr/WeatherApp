class ErrorHandler
  attr_reader :error, :code, :message
  def initialize(error = 'bad_request', code = 500, message = 'Something went wrong!')
    @error = error
    @code = code
    @message = message
  end
end