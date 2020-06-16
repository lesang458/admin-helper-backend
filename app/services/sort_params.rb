class SortParams
  attr_reader :sort_query

  SORT_ORDERS = %w[asc desc].freeze
  def initialize(sort_params, class_name)
    @sort_query = sort_params.tr(':', ' ')
    @class_name = class_name
    validate_sort_params
  end

  def validate_sort_params
    @sort_query.tr(':', ' ').split(',') do |query|
      raise(ExceptionHandler::BadRequest, 'should have sort type') unless check_params_sort_type query.split(' ')[0].downcase, query.split(' ')[1].downcase
    end
  end

  private

  def check_params_sort_type(column, sort_type)
    (@class_name.column_names.include? column) && (SORT_ORDERS.include? sort_type)
  end
end
