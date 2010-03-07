class Tempitem < ActiveRecord::Base
  include PhotoUrlConcerns
  include PhotoAttachment

  validates_attachment_presence :photo, :unless => :photo_url?

  belongs_to :user
end
