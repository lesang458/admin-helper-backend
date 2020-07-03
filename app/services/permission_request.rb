class PermissionRequest
  def initialize(current_user, controller_name, action_params)
    @current_user = current_user
    @controller_name = controller_name
    @action_params = action_params
    @actions = []
    validate_action
  end

  def set_permission
    @current_user.roles.each do |role|
      @actions.push(*PermissionConfig.config.dig(role.downcase, @controller_name))
    end
  end

  def validate_action
    set_permission
    raise(ExceptionHandler::Forbidden, 'You do not have permission') unless @actions.include? @action_params
  end
end
