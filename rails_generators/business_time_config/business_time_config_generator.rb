# This generator simply drops the its_business_time.rb and its_business_time.yml file
# into the appropate places in a rails app to configure and initialize the
# data.  Once generated, these files are yours to modify.
class ItsBusinessTimeConfigGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template('its_business_time.rb', "config/initializers/its_business_time.rb")
    end
  end
end
