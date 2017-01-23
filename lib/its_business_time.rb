require 'thread'
require 'active_support'
require 'active_support/time'
require 'time'
require 'yaml'

require 'its_business_time/version'
require 'its_business_time/parsed_time'
require 'its_business_time/config'

require 'its_business_time/time_extensions'
require 'its_business_time/core_ext/date'
require 'its_business_time/core_ext/time'
require 'its_business_time/core_ext/active_support/time_with_zone'

module ItsBusinessTime
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= ItsBusinessTime::Config.new
    yield(configuration)
  end
end
