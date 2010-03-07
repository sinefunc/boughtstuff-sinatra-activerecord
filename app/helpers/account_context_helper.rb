class Main
  helpers do
    def viewing_an_account
      yield if User === @account 
    end
    
    def viewing_no_account
      yield if not User === @account
    end

    def viewing_own_account
      yield if logged_in? and @account == current_user
    end

    def viewing_other_account
      yield if @account and @account != current_user and User === @account
    end

    def not_viewing_own_account
      yield if @account != current_user
    end
  end
end
