class SoaConfiguration
  attr_reader :config

  def self.build(yaml_file)
    new(yaml_file)
  end

  def initialize(yaml_file)
    @config = YAML.load_file(yaml_file)
  end

  def host
    @config['host']
  end

  def services
    @config['services'].map do |service, properties|
      {name: service, port: properties['port']}
    end
  end

  def ops
    @config['ops'].keys
  end
end
