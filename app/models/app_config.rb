class AppConfig
  def self.s3
    OpenStruct.new(
      :bucket => (Rails.env == 'development' ? 'boughtstuff-development' : 'boughtstuff')
    )
  end
end
