module PhotoAttachment
  def self.included( model )
    model.has_attached_file :photo, { 
      :styles => { :thumb => "160x195#", :large => "640x480>" },
      :default_url => '/:attachment/:style/missing.jpg',
    }.merge(Boughtstuff::PAPERCLIP_CONFIG)
  end
end
