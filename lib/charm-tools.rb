
require 'erb'

module CharmTools

  def service_name
    ENV['JUJU_UNIT_NAME'].gsub(/\/.*/,"")
  end

  def running_in_unit?
    ENV.keys.any?{|key| key =~ /JUJU_AGENT/}
  end

  def log(msg)
    if running_in_unit?
      `juju-log #{msg}`
    else
      puts msg
    end
  end

  def relations
    `relation-list`.each do |service|
      hostname=`relation-get --format json #{service} hostname`
      port=`relation-get #{service} port`
    end
  end

  def relation_info
    <<-EOS
    #{ENV['ENSEMBLE_REMOTE_UNIT']} modified its settings...
    Relation settings:
      #{`relation-get --format json`}
    Relation members:
      #{`relation-list`}
    EOS
  end

  #`relation-list`.each do |service|
  #  hostname=`relation-get #{service} hostname`
  #  port=`relation-get #{service} port`
  #end

  def write_unit_config(file, config_hash)
  end
  def read_unit_config(file)
  end
  def unit_config
    {
      :backends => { 
        "one" => {:address => "192.168.122.1", :port => "80"},
        "two" => {:address => "192.168.122.2", :port => "80"}
      }
    }
  end

  def expand_template_to_file( template,  target )
    begin
      File.open(target,"w") do |file|
        file.write(expand_template(template))
      end
    rescue => e
      log "error writing template file #{e}"
      raise e
    end
  end

  def expand_template(filename)
    template_path = File.join(ENV['CHARM_DIR'],'templates',filename)
    ERB.new(File.read(template_path)).result(binding)
  end

  %w{ start stop restart }.each do |action|
    define_method "#{action}_service" do |service_name|
      log "#{action.capitalize}ing #{service_name}"
      #TODO make these more robust
      #and consistent across services!!
      `service #{service_name} #{action}`
    end
  end

end
include CharmTools
