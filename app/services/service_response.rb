module ServiceResponse
  ResponseStruct = Struct.new(:value) do
    def success?
      !error?
    end

    def error?
      value.is_a?(Symbol)
    end

    def error_id
      value
    end

    def data
      value
    end
  end

  def service_success(data)
    ResponseStruct.new(data)
  end

  def service_error(sym)
    ResponseStruct.new(sym)
  end
end

