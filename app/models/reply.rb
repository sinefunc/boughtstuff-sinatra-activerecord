class Reply
  include StatusUpdateConcerns

  template "@:username "

  validate :body_has_other_content

  private
    def body_has_other_content
      if item and body.strip == render(:username => item.user.login).strip
        errors.add(:body, "You must write something.")
      end
    end
end
