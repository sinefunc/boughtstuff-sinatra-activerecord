A collection of matchers for paperclip related Rspec'in
=======================================================

Examples:

    describe User do
      subject { User.new }

      it { should validate_attachment_presence(:photo) }
      it { should validate_attachment_size(:photo, :in => 0..(2.megabytes)) }
      it { should validate_attachment_content_type(:photo, :content_type => %w(image/jpg image/png)) }

    end

IMPORTANT NOTE
--------------
This will only work with Rails 3 or above and RSpec 2.0 or above.

TODO 
----
Most of this is still a work in progress. 
