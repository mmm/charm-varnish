
require 'charm_helper/local_config'
require 'charm_helper/service'
require 'charm_helper/template'

module CharmHelper

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
  alias :log :juju-log

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

end
include CharmHelper
