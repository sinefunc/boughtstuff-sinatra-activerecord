require File.dirname(__FILE__) + '/helper'

class OptionsTest < Test::Unit::TestCase
  setup do
    @base    = Sinatra.new(Sinatra::Base)
    @application = Sinatra.new(Sinatra::Application)
    @base.set    :environment, :development
    @application.set :environment, :development
  end

  it 'sets options to literal values' do
    @base.set(:foo, 'bar')
    assert @base.respond_to?(:foo)
    assert_equal 'bar', @base.foo
  end

  it 'sets options to Procs' do
    @base.set(:foo, Proc.new { 'baz' })
    assert @base.respond_to?(:foo)
    assert_equal 'baz', @base.foo
  end

  it "sets multiple options with a Hash" do
    @base.set :foo => 1234,
        :bar => 'Hello World',
        :baz => Proc.new { 'bizzle' }
    assert_equal 1234, @base.foo
    assert_equal 'Hello World', @base.bar
    assert_equal 'bizzle', @base.baz
  end

  it 'inherits option methods when subclassed' do
    @base.set :foo, 'bar'
    @base.set :biz, Proc.new { 'baz' }

    sub = Class.new(@base)
    assert sub.respond_to?(:foo)
    assert_equal 'bar', sub.foo
    assert sub.respond_to?(:biz)
    assert_equal 'baz', sub.biz
  end

  it 'overrides options in subclass' do
    @base.set :foo, 'bar'
    @base.set :biz, Proc.new { 'baz' }
    sub = Class.new(@base)
    sub.set :foo, 'bling'
    assert_equal 'bling', sub.foo
    assert_equal 'bar', @base.foo
  end

  it 'creates setter methods when first defined' do
    @base.set :foo, 'bar'
    assert @base.respond_to?('foo=')
    @base.foo = 'biz'
    assert_equal 'biz', @base.foo
  end

  it 'creates predicate methods when first defined' do
    @base.set :foo, 'hello world'
    assert @base.respond_to?(:foo?)
    assert @base.foo?
    @base.set :foo, nil
    assert !@base.foo?
  end

  it 'uses existing setter methods if detected' do
    class << @base
      def foo
        @foo
      end
      def foo=(value)
        @foo = 'oops'
      end
    end

    @base.set :foo, 'bam'
    assert_equal 'oops', @base.foo
  end

  it "sets multiple options to true with #enable" do
    @base.enable :sessions, :foo, :bar
    assert @base.sessions
    assert @base.foo
    assert @base.bar
  end

  it "sets multiple options to false with #disable" do
    @base.disable :sessions, :foo, :bar
    assert !@base.sessions
    assert !@base.foo
    assert !@base.bar
  end

  it 'enables MethodOverride middleware when :methodoverride is enabled' do
    @base.set :methodoverride, true
    @base.put('/') { 'okay' }
    @app = @base
    post '/', {'_method'=>'PUT'}, {}
    assert_equal 200, status
    assert_equal 'okay', body
  end

  describe 'clean_trace' do
    def clean_backtrace(trace)
      Sinatra::Base.new.send(:clean_backtrace, trace)
    end

    it 'is enabled on Base' do
      assert @base.clean_trace?
    end

    it 'is enabled on Application' do
      assert @application.clean_trace?
    end

    it 'does nothing when disabled' do
      backtrace = [
        "./lib/sinatra/base.rb",
        "./myapp:42",
        ("#{Gem.dir}/some/lib.rb" if defined?(Gem))
      ].compact

      klass = Class.new(Sinatra::Base)
      klass.disable :clean_trace

      assert_equal backtrace, klass.new.send(:clean_backtrace, backtrace)
    end

    it 'removes sinatra lib paths from backtrace when enabled' do
      backtrace = [
        "./lib/sinatra/base.rb",
        "./lib/sinatra/compat.rb:42",
        "./lib/sinatra/main.rb:55 in `foo'"
      ]
      assert clean_backtrace(backtrace).empty?
    end

    it 'removes ./ prefix from backtrace paths when enabled' do
      assert_equal ['myapp.rb:42'], clean_backtrace(['./myapp.rb:42'])
    end

    if defined?(Gem)
      it 'removes gem lib paths from backtrace when enabled' do
        assert clean_backtrace(["#{Gem.dir}/some/lib"]).empty?
      end
    end
  end

  describe 'run' do
    it 'is disabled on Base' do
      assert ! @base.run?
    end

    it 'is enabled on Application when not in test environment' do
      @application.set :environment, :development
      assert @application.development?
      assert @application.run?

      @application.set :environment, :development
      assert @application.run?
    end

    # TODO: it 'is enabled when $0 == app_file'
  end

  describe 'raise_errors' do
    it 'is enabled on Base except under development' do
      @base.environment = :test
      assert @base.raise_errors?
      @base.environment = :development
      assert !@base.raise_errors?
    end

    it 'is enabled on Application only in test' do
      @application.set(:environment, :development)
      assert @application.development?
      assert ! @application.raise_errors?

      @application.set(:environment, :production)
      assert ! @application.raise_errors?

      @application.set(:environment, :test)
      assert @application.raise_errors?
    end
  end

  describe 'show_exceptions' do
    it 'is disabled on Base except under development' do
      @base.environment = :test
      assert ! @base.show_exceptions?
      @base.environment = :development
      assert @base.show_exceptions?
    end

    it 'is enabled on Application only in development' do
      @base.set(:environment, :development)
      assert @application.development?
      assert @application.show_exceptions?

      @application.set(:environment, :test)
      assert ! @application.show_exceptions?

      @base.set(:environment, :production)
      assert ! @base.show_exceptions?
    end

    it 'returns a friendly 500' do
      klass = Sinatra.new(Sinatra::Application)
      mock_app(klass) {
        enable :show_exceptions

        get '/' do
          raise StandardError
        end
      }

      get '/'
      assert_equal 500, status
      assert body.include?("StandardError")
      assert body.include?("<code>show_exceptions</code> setting")
    end
  end

  describe 'dump_errors' do
    it 'is disabled on Base except in development' do
      @base.environment = :test
      assert ! @base.dump_errors?
      @base.environment = :development
      assert @base.dump_errors?
    end

    it 'is enabled on Application' do
      assert @application.dump_errors?
    end

    it 'dumps exception with backtrace to rack.errors' do
      klass = Sinatra.new(Sinatra::Application)

      mock_app(klass) {
        disable :raise_errors

        error do
          error = @env['rack.errors'].instance_variable_get(:@error)
          error.rewind

          error.read
        end

        get '/' do
          raise
        end
      }

      get '/'
      assert body.include?("RuntimeError") && body.include?("options_test.rb")
    end
  end

  describe 'sessions' do
    it 'is disabled on Base' do
      assert ! @base.sessions?
    end

    it 'is disabled on Application' do
      assert ! @application.sessions?
    end

    # TODO: it 'uses Rack::Session::Cookie when enabled' do
  end

  describe 'logging' do
    it 'is disabled on Base' do
      assert ! @base.logging?
    end

    it 'is enabled on Application when not in test environment' do
      assert @application.logging?

      @application.set :environment, :test
      assert ! @application.logging
    end

    # TODO: it 'uses Rack::CommonLogger when enabled' do
  end

  describe 'static' do
    it 'is disabled on Base by Application' do
      assert ! @base.static?
    end

    it 'is enabled on Base when public is set and exists' do
      @base.set :environment, :development
      @base.set :public, File.dirname(__FILE__)
      assert @base.static?
    end

    it 'is enabled on Base when root is set and root/public exists' do
      @base.set :environment, :development
      @base.set :root, File.dirname(__FILE__)
      assert @base.static?
    end

    it 'is enabled on Application' do
      assert @application.static?
    end
  end

  describe 'host' do
    it 'defaults to 0.0.0.0' do
      assert_equal '0.0.0.0', @base.host
      assert_equal '0.0.0.0', @application.host
    end
  end

  describe 'port' do
    it 'defaults to 4567' do
      assert_equal 4567, @base.port
      assert_equal 4567, @application.port
    end
  end

  describe 'server' do
    it 'is one of thin, mongrel, webrick' do
      assert_equal %w[thin mongrel webrick], @base.server
      assert_equal %w[thin mongrel webrick], @application.server
    end
  end

  describe 'app_file' do
    it 'is nil' do
      assert @base.app_file.nil?
      assert @application.app_file.nil?
    end
  end

  describe 'root' do
    it 'is nil if app_file is not set' do
      assert @base.root.nil?
      assert @application.root.nil?
    end

    it 'is equal to the expanded basename of app_file' do
      @base.app_file = __FILE__
      assert_equal File.expand_path(File.dirname(__FILE__)), @base.root

      @application.app_file = __FILE__
      assert_equal File.expand_path(File.dirname(__FILE__)), @application.root
    end
  end

  describe 'views' do
    it 'is nil if root is not set' do
      assert @base.views.nil?
      assert @application.views.nil?
    end

    it 'is set to root joined with views/' do
      @base.root = File.dirname(__FILE__)
      assert_equal File.dirname(__FILE__) + "/views", @base.views

      @application.root = File.dirname(__FILE__)
      assert_equal File.dirname(__FILE__) + "/views", @application.views
    end
  end

  describe 'public' do
    it 'is nil if root is not set' do
      assert @base.public.nil?
      assert @application.public.nil?
    end

    it 'is set to root joined with public/' do
      @base.root = File.dirname(__FILE__)
      assert_equal File.dirname(__FILE__) + "/public", @base.public

      @application.root = File.dirname(__FILE__)
      assert_equal File.dirname(__FILE__) + "/public", @application.public
    end
  end

  describe 'lock' do
    it 'is disabled by default' do
      assert ! @base.lock?
    end
  end
end
