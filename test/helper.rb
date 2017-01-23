require 'minitest/autorun'

require 'active_support'
require 'active_support/core_ext'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'its_business_time'

MiniTest::Spec.class_eval do
  before do
    ItsBusinessTime.configuration = nil
    ItsBusinessTime.configure {}
    Time.zone = nil
  end
end
