class Main
  helpers do
    def truncate( str, options = {} )
      length   = options[:length]
      omission = options[:omission] || '...'

      if str and str.length > length
        sprintf("%.#{length}s#{omission}", str)
      else
        str
      end
    end
  end
end
