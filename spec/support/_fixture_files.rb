class FixtureFile < Tempfile
  attr_reader :original_filename

  def initialize( file )
    @original_filename = File.basename(file)
    super(@original_filename)

    write File.read(file)
  end
end

def fixture_file_upload( file, mimetype )
  FixtureFile.new( root_path('spec', 'fixtures', file) )
end
