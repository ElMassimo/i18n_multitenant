# frozen_string_literal: true
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'rspec/given'
require 'pry'
require 'i18n_multitenant'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.expose_dsl_globally = false
end

# Load Support files
Dir['./spec/support/**/*.rb'].each do |f|
  require f
end
