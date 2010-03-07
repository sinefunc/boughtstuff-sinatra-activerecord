# encoding: utf-8

module Tests
  module Api
    module Lookup
      def setup
        super
        store_translations(:foo => { :bar => 'bar', :baz => 'baz' }, :bla => false, :ble => %(a b c))
      end

      define_method "test lookup: given a nested key it looks up the nested hash value" do
        assert_equal 'bar', I18n.t(:'foo.bar')
      end

      define_method "test make sure we can store a native false value as well" do
        assert_equal false, I18n.t(:bla)
      end

      define_method "test lookup: given a missing key, no default and no raise option it returns an error message" do
        assert_equal "translation missing: en, missing", I18n.t(:missing)
      end

      define_method "test lookup: given a missing key, no default and the raise option it raises MissingTranslationData" do
        assert_raise(I18n::MissingTranslationData) { I18n.t(:missing, :raise => true) }
      end

      define_method "test lookup: does not raise an exception if no translation data is present for the given locale" do
        assert_nothing_raised { I18n.t(:foo, :locale => :xx) }
      end

      define_method "test lookup: given an array of keys it translates all of them" do
        assert_equal %w(bar baz), I18n.t([:bar, :baz], :scope => [:foo])
      end

      define_method "test lookup: using a custom scope separator" do
        # data must have been stored using the custom separator when using the ActiveRecord backend
        I18n.backend.store_translations(:en, { :foo => { :bar => 'bar' } }, { :separator => '|' })
        assert_equal 'bar', I18n.t('foo|bar', :separator => '|')
      end

      # In fact it probably *should* fail but Rails currently relies on using the default locale instead.
      # So we'll stick to this for now until we get it fixed in Rails.
      define_method "test lookup: given nil as a locale it does not raise but use the default locale" do
        # assert_raise(I18n::InvalidLocale) { I18n.t(:bar, :locale => nil) }
        assert_nothing_raised { I18n.t(:bar, :locale => nil) }
      end

      define_method "test lookup: a resulting String is not frozen" do
        I18n.t(:'foo.bar')
        assert !I18n.t(:'foo.bar').frozen?
      end

      define_method "test lookup: a resulting Array is not frozen" do
        assert !I18n.t(:'foo.bar').frozen?
      end

      define_method "test lookup: a resulting Hash is not frozen" do
        assert !I18n.t(:'foo').frozen?
      end
    end
  end
end
