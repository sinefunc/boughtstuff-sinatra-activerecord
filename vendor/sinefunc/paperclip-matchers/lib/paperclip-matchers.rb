require 'rspec'
require 'rspec/matchers'

module PaperclipMatchers
  include Rspec::Matchers

  def validate_attachment_presence( attribute )
    Matcher.new :validate_attachment_presence, attribute do |_attribute_|
      match do |_model_|
        _model_.send("#{_attribute_}=", nil)
        !_model_.valid? && _model_.errors["#{_attribute_}_file_name".to_sym].any?
      end
    end
  end
end

Rspec.configure do |c|
  c.include PaperclipMatchers
end
