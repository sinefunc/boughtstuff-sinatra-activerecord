class Reply
  include StatusUpdateConcerns

  template "@:username "

  validate :body_has_other_content

  private
    def body_has_other_content
      if item and body.strip == render(:username => item.user.login).strip
        errors.add(:body, I18n::t("you_must_write_something"))
      end
    end
end
