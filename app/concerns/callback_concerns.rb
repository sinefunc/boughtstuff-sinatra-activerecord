module CallbackConcerns
  def self.included( base )
    base.extend ClassMethods
  end

  module ClassMethods
    [ :before_save, :after_save, :before_delete, :after_delete ].each do |method|
      define_method method do |callbacks|
        Array(callbacks).each do |callback|
          defined_callbacks[method] << callback
        end
      end
    end

    def defined_callbacks
      @defined_callbacks ||= Hash.new { |h, k| h[k] = [] }
    end
  end

  def save
    run_callbacks( :before_save )
    ret = super
    run_callbacks( :after_save )
    ret
  end

  def delete
    run_callbacks( :before_delete )
    ret = super
    run_callbacks( :after_delete )
    ret
  end
  
  protected
    def before_save;   end
    def after_save;    end
    def before_delete; end
    def after_delete;  end

  private
    def run_callbacks( callback )
      self.class.defined_callbacks[callback].each { |method| __send__(method) }
    end
end
