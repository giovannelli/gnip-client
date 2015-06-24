module Gnip
  class PowerTrackClient
      
    attr_accessor :publisher, :label, :account,
                  :username, :password
      
    attr_reader :rules, :full_archive, :stream, :replay
      
    def initialize(options = {})
      @account        = options[:account]
      @publisher      = options[:publisher]||"twitter"
      @label          = options[:label]||"dev"
      @username       = options[:username]
      @password       = options[:password]
      @rules          = Gnip::GnipRules::Rules.new(self)
      @full_archive   = Gnip::GnipFullArchive::FullArchive.new(self)
      @stream         = Gnip::GnipStream::Stream.new(self)
      @replay         = Gnip::GnipStream::Replay.new(self, true)
    end
      
  end
end
