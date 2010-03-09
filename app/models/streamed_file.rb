require 'digest/sha1'

class StreamedFile < Tempfile
  def initialize( url )
    @url = url 
    
    super(original_filename)

    write( Kernel.open(@url).read )
  end

  def original_filename
    "#{Digest::SHA1.hexdigest(@url)}.#{extension}"
  end

  private
    def extension
      @url.index('.') ? @url.split('.').last : nil
    end
end
