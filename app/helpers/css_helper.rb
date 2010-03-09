class Main
  helpers do
    def show_if( condition )
      condition ? {} : { :class => 'hide' } 
    end

    def hide_if( condition )
      show_if( !condition )
    end
  end
end
