require 'spec_helper'

describe ItemUrl, "with a username of marco-palinar and an id of 1001" do
  subject { ItemUrl.new('marco-palinar', '1001') }

  its(:to_s) { should == "http://marco-palinar.boughtstuff.com/#1001" }
end
