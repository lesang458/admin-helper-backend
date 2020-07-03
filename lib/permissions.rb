module Permissions
  @config = {}

  def self.init
    @config = YAML.load_file('config/roles.yml')
  end

  def self.config
    @config
  end
end
