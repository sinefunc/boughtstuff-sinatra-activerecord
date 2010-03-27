class Retweet
  include StatusUpdateConcerns
  include QueuingConcerns

  template "RT @:username: %.55s :url #boughtstuff"

  @queue = :twitter

end
