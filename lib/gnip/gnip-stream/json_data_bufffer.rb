# frozen_string_literal: true

module Gnip
  module GnipStream
    class JsonDataBuffer
      attr_accessor :split_pattern, :check_pattern

      def initialize(split_pattern, check_pattern)
        @split_pattern = split_pattern
        @check_pattern = check_pattern
        @buffer = ''
      end

      def process(chunk)
        @buffer.concat(chunk)
      end

      def complete_entries
        entries = []
        while @buffer =~ check_pattern
          new_line = @buffer[@buffer.size - 2..@buffer.size - 1] == "\r\n"
          activities = @buffer.split(split_pattern)
          entries << activities.shift
          @buffer = activities.join(split_pattern)
          @buffer += "\r\n" if !@buffer.empty? && new_line
        end
        entries.reject(&:empty?)
      end
    end
  end
end
