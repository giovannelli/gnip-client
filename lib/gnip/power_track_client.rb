module Gnip
  class PowerTrackClient
      
    attr_accessor :publisher, :label, :account,
                  :username, :password,
                  :backfill_client, :replay_label
      
    attr_reader :rules, :replay_rules, :full_archive, :stream, :replay, :power_track_version
      
    def initialize(options = {})
      @account             = options[:account]
      @publisher           = options[:publisher]||"twitter"
      @label               = options[:label]||"dev"
      @replay_label        = options[:replay_label]||@label
      @username            = options[:username]
      @password            = options[:password]
      @backfill_client     = options[:backfill_client]||nil
      @power_track_version = options[:power_track_version]||'2.0'
      @rules               = Gnip::GnipRules::Rules.new(self)
      @replay_rules        = Gnip::GnipRules::Rules.new(self, true)
      @full_archive        = Gnip::GnipFullArchive::FullArchive.new(self)
      @stream              = Gnip::GnipStream::Stream.new(self)
      @replay              = Gnip::GnipStream::Replay.new(self)
    end
      
  end
end
