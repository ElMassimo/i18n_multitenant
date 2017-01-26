# frozen_string_literal: true
require 'spec_helper'

def t(*args)
  I18n.translate(*args)
end

RSpec.describe I18nMultitenant do
  Given {
    I18nMultitenant.configure(I18n, enforce_available_locales: true)
  }

  describe 'set' do
    context 'passing an incorrect option' do
      When(:result) { I18nMultitenant.set(locales: [:en, :es]) }
      Then { expect(result).to have_failed(ArgumentError, /unknown keyword: locales/) }
    end

    context 'setting only the locale' do
      When(:result) { I18nMultitenant.set(locale: locale) }

      context 'regular locale' do
        Given(:locale) { :es }
        Then { result == :es }
        And  { I18n.locale == result }
      end

      context 'specific locale' do
        Given(:locale) { 'en-GB' }
        Then { result == 'en-GB' }
        And  { I18n.locale == result.to_sym }
      end

      context 'non existing locale' do
        Given(:locale) { 'en-US' }
        Then { expect(result).to have_failed(I18n::InvalidLocale, /not a valid locale/) }
      end
    end

    context 'setting only the tenant' do
      When(:result) { I18nMultitenant.set(tenant: tenant) }
      Invariant { I18n.locale == result.to_sym }

      context 'regular tenant' do
        Given(:tenant) { 'Free' }
        Then { result == 'en-FREE' }
      end

      context 'weird casing tenant' do
        Given(:tenant) { 'eNtErPrIsE' }
        Then { result == 'en-ENTERPRISE' }
      end

      context 'non existing tenant' do
        Given { I18n.enforce_available_locales = false }
        Given(:tenant) { :'Strange.teNant-namE' }
        Then { result == 'en-STRANGE_TENANT_NAME' }
      end
    end

    context 'setting both' do
      When(:result) { I18nMultitenant.set(locale: locale, tenant: tenant) }

      context 'regular tenant and locale' do
        Given(:locale) { :es }
        Given(:tenant) { 'eNtErPrIsE' }
        Then { result == 'es-ENTERPRISE' }
        And { I18n.locale == result.to_sym }
      end

      context 'regular tenant and specific locale' do
        Given(:locale) { 'en-US' }
        Given(:tenant) { :free }
        Then { result == 'en-US-FREE' }
        And { I18n.locale == result.to_sym }
      end

      context 'non existing tenant/locale combination' do
        Given(:locale) { 'en-US' }
        Given(:tenant) { 'Enterprise' }
        Then { expect(result).to have_failed(I18n::InvalidLocale, /"en-US-ENTERPRISE" is not a valid locale/) }
      end
    end
  end

  describe 'with_locale' do
    context 'is restored afterwards' do
      Given {
        I18n.locale = :en
      }
      When(:result) {
        I18nMultitenant.with_locale(locale: :es, tenant: 'Free') {
          t(:app_name)
        }
      }
      Then { result == 'I18n (versión gratuita)' }
      And  { I18n.locale == :en }
      And  { t(:app_name) == 'I18n' }
    end
  end

  describe 'translation' do
    context 'setting the locale directly' do
      context 'english' do
        When { I18n.locale = :en }
        Then { t(:app_name) == 'I18n' }
        And  { t(:greeting) == 'Welcome!' }
        And  { t('simple_form.labels.user.name') == 'Name' }
        And  { t('devise.failure.already_authenticated') == 'You are already signed in.' }
      end

      context 'spanish' do
        When { I18n.locale = :es }
        Then { t('app_name') == 'I18n' }
        And  { t('greeting') == 'Bienvenido!' }
        And  { t('simple_form.labels.user.name') == 'Nombre' }
        And  { t('devise.failure.already_authenticated') == 'Ya has iniciado sesión.' }
      end

      context 'non-existing locale' do
        When(:locale) { I18n.locale = 'en-US' }
        Then { expect(locale).to have_failed(I18n::InvalidLocale, /not a valid locale/) }
      end

      context 'locale and tenant (internal representation)' do
        When { I18n.locale = 'en-FREE' }
        Then { t(:greeting) == 'Welcome!' }
      end
    end

    context 'setting the locale and tenant' do
      Given {
        I18nMultitenant.set(tenant: tenant, locale: locale)
      }

      context 'english' do
        Given(:locale) { :en }

        context 'Free Tenant' do
          Given(:tenant) { 'Free' }
          Then { t(:app_name) == 'I18n (community edition)' }
          And  { t(:greeting) == 'Welcome!' }
          And  { t('simple_form.labels.user.name') == 'Name' }
          And  { t('devise.failure.already_authenticated') == 'You are already signed in.' }
        end

        context 'Enterprise Tenant' do
          Given(:tenant) { 'eNterPrise' }
          Then { t(:app_name) == 'I18n Enterprise' }
          And  { t(:greeting) == 'Welcome!' }
          And  { t('simple_form.labels.user.name') == 'Name' }
          And  { t('devise.failure.already_authenticated') == 'You are already signed in.' }
        end
      end

      context 'spanish' do
        Given(:locale) { :es }

        context 'Free Tenant' do
          Given(:tenant) { :free }
          Then { t('app_name') == 'I18n (versión gratuita)' }
          And  { t('greeting') == 'Bienvenido!' }
          And  { t('simple_form.labels.user.name') == 'Nombre' }
          And  { t('devise.failure.already_authenticated') == 'Ya iniciaste sesión.' }
        end

        context 'Enterprise Tenant' do
          Given(:tenant) { :enterprise }
          Then { t('app_name') == 'I18n PRO' }
          And  { t('greeting') == 'Bienvenido!' }
          And  { t('simple_form.labels.user.name') == 'Nombre y Apellido' }
          And  { t('devise.failure.already_authenticated') == 'Ya has iniciado sesión.' }
        end
      end

      context 'specific locale with tenant' do
        Given(:locale) { 'en-US' }
        Given(:tenant) { 'Free' }
        Then { t(:app_name) == 'I18n (community edition)' }
      end

      context 'nil tenant' do
        Given(:locale) { :en }
        Given(:tenant) { nil }
        Then { t(:greeting) == 'Welcome!' }
      end

      context 'empty tenant' do
        Given(:locale) { :es }
        Given(:tenant) { '' }
        Then { t(:greeting) == 'Bienvenido!' }
      end
    end
  end
end
