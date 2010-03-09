module PhotoAttachment
  def self.included( item )
    item.validate    :photo_is_attached
    item.send        :attr_accessor, :temp_photo_file_name
    item.before_save :store_temp_photo
  end

  def photo_is_attached
    if photo_url.blank? and temp_photo.blank? and photo_file_name.blank?
      errors.add(:photo, I18n::t('errors.messages.blank'))
    end
  end

  def photo
    uploader = PhotoUploader.new( self, :photo )
    uploader.retrieve_from_store!(photo_file_name) if photo_file_name.present?
    uploader
  end

  def photo=( file )
    uploader = PhotoUploader.new( self, :photo )
    uploader.store!( file )
    self.photo_file_name = uploader.filename
  end

  private
    def temp_photo
      return if temp_photo_file_name.blank?

      begin
        uploader = PhotoUploader.new
        uploader.retrieve_from_cache!( temp_photo_file_name )
      rescue Exception => e
        logger.warn "Was trying to retrieve #{temp_photo_file_name}, failed"
      else
        uploader
      end
    end

    def store_temp_photo
      if temp_photo_file_name.present?
        uploader = PhotoUploader.new( self, :photo )
        uploader.retrieve_from_cache!( temp_photo_file_name )
        uploader.store!

        self.photo_file_name = uploader.filename
      end
    end
end
