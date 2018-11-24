module Committee
  class SchemaValidator::OpenAPI3::ParameterObjectCoercer
    def initialize(query_hash, path_object_hash, operation_object, validator_option)
      @query_hash = query_hash
      @operation_object = operation_object
      @path_object_hash = path_object_hash
      @coerce_recursive = validator_option.coerce_recursive
    end

    def call!
      return {} unless @query_hash

      coerce_path_parameters(@query_hash, @operation_object)
    end

    private

    def coerce_path_parameters(query_hash, operation_object)
      query_hash.each do |key,value|
        next if value.nil?

        path_parameter_object = @path_object_hash[key]
        next unless path_parameter_object

        new_value, is_change = operation_object.coerce_parameter_value(value, path_parameter_object)

        query_hash[key] = new_value if is_change
      end
      query_hash
    end
  end
end
