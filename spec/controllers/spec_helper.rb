require 'spec_helper'

RSpec.configure do |config|
  config.before :type => :controller do
    I18n.stub(:translate) { |sym| sym }
  end
end