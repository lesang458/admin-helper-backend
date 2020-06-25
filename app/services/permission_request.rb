class PermissionRequest
  def initialize(current_user, name_controller, action_params)
    @current_user = current_user
    @name_controller = name_controller
    @action_params = action_params
    @actions = []
    validate_action
  end

  def set_permission
    @current_user.roles.each do |role|
      @actions.push(*Permissions.dig(role.downcase, @name_controller))
    end
  end

  def validate_action
    set_permission
    raise(ExceptionHandler::Forbidden, 'You do not have permission') unless @actions.include? @action_params
  end
end
