# i18n Multi-Tenant

This gem is a small utility that provides the basic configuration to perform
tenant-specific translations in multi-tenant apps.

## Setting the locale
```ruby
I18nMultitenant.set(locale: :en, tenant: 'Tenant Name')
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
