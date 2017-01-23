module ItsBusinessTime
  module Generators
    class ConfigGenerator < Rails::Generators::Base # :nodoc:

      def self.gem_root
        File.expand_path("../../../..", __FILE__)
      end

      def self.source_root
        # Use the templates from the 2.3.x generator
        File.join(gem_root, 'rails_generators', 'its_business_time_config', 'templates')
      end

      def generate
        template 'its_business_time.rb', File.join('config', 'initializers', 'its_business_time.rb')
      end

    end
  end
end
