module PermissionConfig
  @config = {}

  def self.init
    @config = YAML.load_file('config/roles_and_rights.yml')
  end

  def self.config
    @config
  end
end
