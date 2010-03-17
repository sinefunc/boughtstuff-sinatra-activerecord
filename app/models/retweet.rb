class Retweet
  include StatusUpdateConcerns

  template "RT @:username: %.55s :url #boughtstuff"
end
