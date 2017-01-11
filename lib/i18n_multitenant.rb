require 'i18n'

# frozen_string_literal: true
module I18nMultitenant

  # Public: Sets the internal locale to consider the current tenant and base locale.
  #
  # locale: The base locale to be set (optional: uses the default locale).
  # tenant: Name of the current tenant (optional: does not scope to the tenant).
  #
  # Returns the key that should be used for all translations specific to that
  # locale and tenant configuration.
  #
  # Example:
  #   I18nMultitenant.set(locale: :en, tenant: 'Veridian Dynamics')
  #   => "en-VERIDIAN_DYNAMICS"
  #
  #   I18nMultitenant.set(locale: 'en-GB', tenant: :'strange.tenant-name')
  #   => "en-GB-STRANGE_TENANT_NAME"
  #
  #   I18nMultitenant.set(locale: :es)
  #   => :es
  def self.set(locale: I18n.default_locale, tenant: nil)
    unless tenant.nil? || tenant.empty?
      locale = "#{ locale }-#{ tenant.to_s.upcase.tr(' .-', '_') }"
    end

    I18n.locale = locale
  end

  # Public: Configures an instance of I18n::Config to ensure fallbacks are setup.
  def self.configure(config, enforce_available_locales: false)
    config.enforce_available_locales = enforce_available_locales
    config.backend.class.send(:include, I18n::Backend::Fallbacks)
    config.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end

require 'i18n_multitenant/railtie' if defined?(Rails::Railtie)
