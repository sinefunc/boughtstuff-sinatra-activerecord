module Sinefunc
  module SpecHelpers
    module Its
      def its(attribute, &block)
        describe("its #{attribute}") do
          define_method(:subject) { super().send(attribute) }
          it(&block)
        end
      end
    end

    module Matchers
      def have_an_invalid( attribute )
        Rspec::Matchers::Matcher.new :have_an_invalid, attribute do |_attr_|
          match do |model|
            model.invalid? && model.errors[_attr_].any?
          end
        end
      end
    end
  end
end

Rspec.configure { |c| c.extend Sinefunc::SpecHelpers::Its }
Rspec.configure { |c| c.include Sinefunc::SpecHelpers::Matchers }
