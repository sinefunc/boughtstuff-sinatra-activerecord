require 'spec_helper'

describe Tempitem do
  subject { Tempitem.new }

  it { should validate_attachment_presence(:photo) }
  it { should belong_to(:user) }
end
