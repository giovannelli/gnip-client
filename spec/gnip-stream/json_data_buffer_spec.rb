# frozen_string_literal: true

require 'spec_helper'
require 'gnip/gnip-stream/json_data_bufffer'

describe Gnip::GnipStream::JsonDataBuffer do
  subject { Gnip::GnipStream::JsonDataBuffer.new("\r\n", Regexp.new(/^\{.*\}\r\n/)) }

  describe '#initialize' do
    it 'accepts a regex pattern that will be used to match entries' do
      split_pattern = "\n"
      check_pattern = Regexp.new(/hello/)
      expect(Gnip::GnipStream::JsonDataBuffer.new(split_pattern, check_pattern).check_pattern).to eq(check_pattern)
      expect(Gnip::GnipStream::JsonDataBuffer.new(split_pattern, check_pattern).split_pattern).to eq(split_pattern)
    end
  end

  describe '#process' do
    it 'appends the data to the buffer' do
      subject.process("{foo}\r\n{bar}")
      expect(subject.instance_variable_get(:@buffer)).to eq("{foo}\r\n{bar}")
    end
  end

  describe 'Entries' do
    it 'all with \\r\\n: should return all entries and leave the buffer empty' do
      subject.process("{hello}\r\n{other}\r\n")
      expect(subject.complete_entries).to eq(['{hello}', '{other}'])
      expect(subject.instance_variable_get(:@buffer)).to eq('')
    end

    it 'last not with \\r\\n: leave the incomplete in the buffer' do
      subject.process("{hello}\r\n{hello2}\r\n{hello3}\r\n{hel")
      expect(subject.complete_entries).to eq(['{hello}', '{hello2}', '{hello3}'])
      expect(subject.instance_variable_get(:@buffer)).to eq('{hel')
    end

    it 'not complete in the first step and complete in the second step' do
      subject.process("{hello}\r\n{hello2}\r\n{hello3}\r\n{hel")
      expect(subject.complete_entries).to eq(['{hello}', '{hello2}', '{hello3}'])
      expect(subject.instance_variable_get(:@buffer)).to eq('{hel')
      subject.process("lo}\r\n")
      expect(subject.complete_entries).to eq(['{hello}'])
      expect(subject.instance_variable_get(:@buffer)).to eq('')
    end
  end
end
