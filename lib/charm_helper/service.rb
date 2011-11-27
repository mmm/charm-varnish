
module CharmHelper
  class Service

    %w{ start stop restart }.each do |action|
      define_method "#{action}" do |service_name|
        log "#{action.capitalize}ing #{service_name}"
        #TODO make these more robust
        #  and consistent across services with different
        #  return-values from startup scripts
        `service #{service_name} #{action}`
      end
    end

  end
end
