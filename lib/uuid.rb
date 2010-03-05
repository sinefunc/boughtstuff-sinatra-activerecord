require 'digest/sha1'

class UUID
  def self.generate
    begin
      `uuidgen`.strip
    rescue Errno::ENOENT
      raise "You must install the uuidgen tool"
    end
  end

  def self.sha1
    Digest::SHA1.hexdigest(generate)
  end
end
