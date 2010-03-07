class Main
  helpers do
    def default_account_subdomain
      @account.username if @account && @account.respond_to?(:username)
    end
  
    def account_url(account_subdomain = default_account_subdomain, use_ssl = request_secure?)
      (use_ssl ? "https://" : "http://") + account_host(account_subdomain)
    end
  
    def account_host(account_subdomain = default_account_subdomain)
      account_host = ""
      account_host << account_subdomain + "."
      account_host << account_domain
    end

    def account_domain
      account_domain = ""
      account_domain << subdomains[1..-1].join(".") + "." if subdomains.size > 1
      account_domain << domain + ':' + request.port.to_s
    end
    
    def account_subdomain
      subdomains.first
    end

    private 
      def request_secure?
        request.scheme == 'https' || request.port == 443  
      end

      def domain
        (request.host.split('.') - subdomains).join('.')
      end

      def subdomains(tld_len=1)
        host = request.host

        @subdomains ||= 
          if (host.nil? || /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
            []
          else
            host.split('.')[0...(1 - tld_len - 2)]
          end
      end
  end
end
