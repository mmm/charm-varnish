
require 'yaml'

module CharmHelper
  class LocalConfig

    LOCAL_CONFIG_FILE = "/var/lib/juju/local_config.yaml"
    #TODO make this relative to CHARM_DIR?
    
    def LocalConfig.get(key)
      local_config[key] 
    end

    def LocalConfig.set(hash)
      local_config.update(hash)
      write_local_config_to_file
    end

  private
    def local_config
      #@local_config ||= read_from_file
      @local_config ||= {
        :active_backends => {
          "one" => { :address => "192.168.122.1", :port => "80"},
          "two" => { :address => "192.168.122.2", :port => "80"}
        }
      }
    end

    def read_from_file
      YAML.load(File.read(LOCAL_CONFIG_FILE))
    end

    def write_to_file
      File.open(LOCAL_CONFIG_FILE,"w") do |file|
        file.write(local_config.to_yaml)
      end
    end

  end
end
