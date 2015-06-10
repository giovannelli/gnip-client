require 'spec_helper'
require 'gnip/gnip-stream/json_data_bufffer'

describe Gnip::GnipStream::JsonDataBuffer do
  subject { Gnip::GnipStream::JsonDataBuffer.new("\r\n", Regexp.new(/^.*\r\n/)) }
  
  describe "#initialize" do
    it "accepts a regex pattern that will be used to match entries" do
      split_pattern = "\n"
      check_pattern = Regexp.new(/hello/)
      expect(Gnip::GnipStream::JsonDataBuffer.new(split_pattern, check_pattern).check_pattern).to eq(check_pattern)
      expect(Gnip::GnipStream::JsonDataBuffer.new(split_pattern, check_pattern).split_pattern).to eq(split_pattern)
    end
  end

  describe "#process" do
    it "appends the data to the buffer" do
      subject.process("foo\r\nbar")
      expect(subject.instance_variable_get(:@buffer)).to eq("foo\r\nbar")
    end
  end

  describe "#complete_entries" do
    it "returns the list of entries" do
      subject.process("hello\r\nother")
      expect(subject.complete_entries).to eq(["hello"])
      expect(subject.instance_variable_get(:@buffer)).to eq("other")
    end
  end

  describe "#multiple complete_entries" do
    it "returns a list of complete entries" do
      subject.process("hello\r\nhello2\r\nhello3\r\nhel")
      expect(subject.complete_entries).to eq(["hello","hello2","hello3"])
      expect(subject.instance_variable_get(:@buffer)).to eq("hel")
    end
  end
end
