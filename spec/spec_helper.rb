require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.dirname(__FILE__)
require "rspec"
require "money"

require "r18n-core"

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |c|
  c.order = :random
  c.filter_run :focus
  c.run_all_when_everything_filtered = true
  c.filter_run_excluding :i18n if ENV['I18N'] == 'false'
end

RSpec.shared_context 'with i18n locale backend', :i18n do
  around do |example|
    require 'i18n'
    I18n.enforce_available_locales = false
    Money.locale_backend = :i18n

    example.run

    Money.locale_backend = Money::LocaleBackend::DEFAULT
    I18n.backend = I18n::Backend::Simple.new
    I18n.locale = :en
  end
end

class Money
  module Warning
    def warn(message); end
  end
end

class Money
  include Warning
  extend Warning
end

class Money::LocaleBackend::Base
  include Money::Warning
end

class Money::FormattingRules
  include Money::Warning
end

RSpec.shared_context 'with infinite precision', :infinite_precision do
  before { Money.infinite_precision = true }
  after { Money.infinite_precision = false }
end

RSpec.shared_context 'with default currency', :default_currency do
  before { Money.default_currency = :usd }
  after { Money.default_currency = nil }
end
