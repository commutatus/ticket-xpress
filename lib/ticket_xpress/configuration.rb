module TicketXpress
  class Configuration
    attr_accessor :client_id, :client_secret, :base_url

    def initialize
      @base_url = nil
      @client_id = nil
      @client_secret = nil
    end
  end
end
