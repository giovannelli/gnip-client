module Gnip
  class PowerTrackClient
      
    attr_accessor :publisher, :label, :account,
                  :username, :password
                  :backfill_client
      
    attr_reader :rules, :replay_rules, :full_archive, :stream, :replay
      
    def initialize(options = {})
      @account         = options[:account]
      @publisher       = options[:publisher]||"twitter"
      @label           = options[:label]||"dev"
      @username        = options[:username]
      @password        = options[:password]
      @backfill_client = options[:backfill_client]        
      @rules           = Gnip::GnipRules::Rules.new(self)
      @replay_rules    = Gnip::GnipRules::Rules.new(self, true)
      @full_archive    = Gnip::GnipFullArchive::FullArchive.new(self)
      @stream          = Gnip::GnipStream::Stream.new(self)
      @replay          = Gnip::GnipStream::Replay.new(self)
    end
      
  end
end
