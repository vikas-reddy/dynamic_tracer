require 'yaml'

class WsConfiguration

  DEFAULT_KEY = "default"

  attr_reader :environments

  # loads web service configuration from file
  def self.load(file_name, environment_name)
    all_configs = YAML.load(File.open(file_name))
    env_config = all_configs[environment_name] || {}
    new(env_config, all_configs[DEFAULT_KEY], all_configs)
  end

  def initialize(env_config, default_config, all_configs)
    @env_config = env_config
    @default_config = default_config || {}
    @all_configs = all_configs
  end

  def environments
    @environments ||= @all_configs.keys - [DEFAULT_KEY]
  end

  def services
    @services ||= @all_configs[DEFAULT_KEY].keys - [DEFAULT_KEY]
  end

  # returns the value of variable_name for service_name
  # e.g. get("search", "port") # => 8220
  def get(service_name, variable_name)
    # Note that this block currently assumes that no configuration has a nil value.
    # fully specified setting for this environment and service
    read_value(@env_config, service_name, variable_name) ||
      # default setting for this environment
      read_value(@env_config, DEFAULT_KEY, variable_name) ||
      # global service-level default
      read_value(@default_config, service_name, variable_name) ||
      # global default
      read_value(@default_config, DEFAULT_KEY, variable_name) ||
      raise("No web service configuration defined for #{service_name.inspect} #{variable_name.inspect}.
             Env config: #{@env_config.inspect}. Default: #{@default_config.inspect}")
  end

  private

  # attemps to traverse multi level hashes, returning nil either if they key sequence does not exist or if the value
  # specified at the key sequence is nil
  def read_value(config, *keys)
    keys.inject(config) do |elt, key|
      return nil unless elt.respond_to?(:key?) && elt.key?(key)
      elt[key]
    end
  end      

end
