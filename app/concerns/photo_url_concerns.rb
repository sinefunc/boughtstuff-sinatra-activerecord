module PhotoUrlConcerns
  def self.included( model )
    model.validates :photo_url,
                    :format => { :with => Format::WEBSITE, :allow_blank => true }

    model.validate  :availability_of_photo_url

    model.send :attr_accessor, :photo_url

    model.before_save :download_photo_from_url
  end

  private
    def photo_url?
      photo_url.present?
    end

    def download_photo_from_url
      if photo_url.present?
        self.photo = StreamedFile.new( photo_url )
      end
    end

    def availability_of_photo_url
      if photo_url.present?
        begin
          open(photo_url)
        rescue SocketError, OpenURI::HTTPError
          errors.add(:photo_url, I18n::t('errors.messages.invalid'))
        end
      end
    end
end
