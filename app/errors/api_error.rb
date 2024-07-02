class ApiError < StandardError
  def initialize(message)
    super(message)
  end
end
