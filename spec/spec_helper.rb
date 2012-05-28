require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda/matchers/integrations/rspec'
  require 'rspec/autorun'
  require 'capybara/rspec'
  
  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
  
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
  
    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
    
    #config.treat_symbols_as_metadata_keys_with_true_values = true
    #config.filter_run :focus => true
    #config.run_all_when_everything_filtered = true
    
    config.before(:suite) do  
      DatabaseCleaner.strategy = :transaction
    end
    
    config.after(:each) do  
      DatabaseCleaner.clean
    end
    
    config.after(:suite) do
      DatabaseCleaner.clean_with :truncation
    end
    
    config.before :type => :routing do
      Rails.application.reload_routes!
    end
    
    # Machinist forgets its blueprints after request specs for some reason; reload them
    # See https://github.com/notahat/machinist/issues/64
    config.after :type => :request do
      load Rails.root.join("spec/support/blueprints.rb")
    end
  end
  
  ActiveSupport::Dependencies.clear
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  Rails.application.reload_routes!
  I18n.backend.reload!
end