require 'pathname'

RAILS_ROOT = ROOT_DIR

module Rails
  def self.root
    Pathname.new(ROOT_DIR)
  end

  def self.env
    RACK_ENV
  end
end
