class StreamedFile < Tempfile
  def initialize( url )
    @url = url 

    super(original_filename)

    write( Kernel.open(@url).read )
  end

  def original_filename
    File.basename(@url) 
  end
end
