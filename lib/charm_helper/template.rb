
require 'erb'

module CharmHelper
  class Template

    def Template.expand_to_file( template,  target )
      begin
        File.open(target,"w") do |file|
          file.write(Template.expand(template))
        end
      rescue => e
        log "error writing template file #{e}"
        raise e
      end
    end

    def Template.expand(filename)
      template_path = File.join(ENV['CHARM_DIR'],'templates',filename)
      ERB.new(File.read(template_path)).result(binding)
    end

  end
end
