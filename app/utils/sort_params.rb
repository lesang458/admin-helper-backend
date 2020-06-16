class SortParams
  attr_reader :sort_query

  SORT_ORDERS = %w[asc desc].freeze
  def initialize(sort_params, class_name)
    @sort_query = sort_params.tr(':', ' ')
    @class_name = class_name
    validate_sort_params
  end

  def validate_sort_params
    @sort_query.split(',') do |query|
      column, sort_type = query.split(' ')
      raise(ExceptionHandler::BadRequest, 'should have sort type') unless @class_name.column_names.include?(column) && SORT_ORDERS.include?(sort_type.downcase)
    end
  end
end
