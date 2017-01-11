class I18nMultitenant::Railtie < ::Rails::Railtie
  config.before_initialize do |app|
    I18nMultitenant.configure(I18n)
  end
end
