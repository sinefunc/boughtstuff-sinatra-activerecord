class User < Ohm::Model
  attribute :login
  attribute :name
  attribute :twitter_id

  index     :login

  def validate
    assert_present :login
    assert_present :twitter_id
    assert_present :name

    assert_unique  :login
    assert_unique  :twitter_id
  end
end
