i18n Multi-Tenant
====================

[![Gem Version](https://badge.fury.io/rb/i18n_multitenant.svg)](http://badge.fury.io/rb/i18n_multitenant)
[![Build Status](https://travis-ci.org/ElMassimo/i18n_multitenant.svg)](https://travis-ci.org/ElMassimo/i18n_multitenant)
[![Test Coverage](https://codeclimate.com/github/ElMassimo/i18n_multitenant/badges/coverage.svg)](https://codeclimate.com/github/ElMassimo/i18n_multitenant/coverage)
[![Code Climate](https://codeclimate.com/github/ElMassimo/i18n_multitenant/badges/gpa.svg)](https://codeclimate.com/github/ElMassimo/i18n_multitenant)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ElMassimo/i18n_multitenant/blob/master/LICENSE.txt)

This gem is a small utility that provides the basic configuration to perform
tenant-specific translations in multi-tenant apps.

## Setting the locale
```ruby
I18nMultitenant.set(locale: :en, tenant: 'Tenant Name')

# Or:
I18nMultitenant.with_locale(locale: :en, tenant: 'Tenant Name') do
...
end
```

## Locale files

The library leverages the use of fallbacks, using the tenant name as a locale variant.

You can organize the files in nested folders as you find suitable, the only
requirement is that the root of a translation file uses the following convention:

```yaml
lang-TENANT_NAME:
  ...
```

For a few different examples, check out the [locale files used in tests](https://github.com/ElMassimo/i18n_multitenant/tree/master/spec/support/config), but here are few valid roots:

```yaml
en:
en-US:
en-US-TENANT_NAME:
```

Any name can be passed through the `:tenant` option, and it will be normalized
to be uppercase and not contain any hyphens, dots, or spaces.

If you need to use names that are not be valid yml keys even after this process,
you will need to sanitize the names yourself before handing them over to `set`.


## Installation

Add this line to your application's Gemfile and run `bundle install`:

```ruby
gem 'i18n_multitenant'
```

Or install it yourself running:

```sh
gem install i18n_multitenant
```

## Configuration

In Rails everything should be configured out of the box, but you can perform
the configuration yourself in other applications by calling:

```ruby
I18nMultitenant.configure(I18n) # or pass I18n.config
```

## Front-end Translations
If you also need to perform translations in the front-end, you can use a library
like [`i18n-js`](https://github.com/fnando/i18n-js). You can easily configure
`i18n-js` to support multi-tenant translations by leveraging `i18n` itself:

```erb
I18n.locale = <%= I18n.locale.to_json.html_safe %>;
I18n.locales[I18n.locale] = <%= I18n.fallbacks[I18n.locale].to_json.html_safe %>
```

