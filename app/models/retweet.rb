class Retweet
  include StatusUpdateConcerns

  template "RT @:username: %.54s :url #boughtstuff"
end
