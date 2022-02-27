# frozen_string_literal: true
require 'rspec/given'
require 'pry-byebug'
require 'pathname'
require 'i18n_multitenant'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.expose_dsl_globally = false
end

# Load Support files
Dir['./spec/support/**/*.rb'].each do |f|
  require f
end

module Rails
  def self.root
    Pathname.new('spec/support')
  end
end
