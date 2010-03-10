Dir[ 'lib/thor/*.thor' ].each do |thorfile|
  begin
    load thorfile
  rescue LoadError
    puts "Unable to load #{thorfile}"
  end
end
