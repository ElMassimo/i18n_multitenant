lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'i18n_multitenant/version'

Gem::Specification.new do |s|
  s.name = 'i18n_multitenant'
  s.version = I18nMultitenant::VERSION
  s.licenses = ['MIT']
  s.summary = 'Translation for multi-tenant applications.'
  s.description = 'I18nMultitenant allows you to specify translations that are tenant-specific, falling back to the base locale.'
  s.authors = ['Máximo Mussini']

  s.email = ['maximomussini@gmail.com']
  s.homepage = %q{https://github.com/ElMassimo/i18n_multitenant}

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=2.0'
  s.rdoc_options = ['--charset=UTF-8']

  s.require_path = 'lib'
  s.files        = Dir.glob('lib/**/*') + %w(CHANGELOG.md LICENSE.txt README.md Rakefile)
  s.test_files   = Dir.glob('spec/**/*')

  s.add_dependency 'i18n', '>=0.7'
end
