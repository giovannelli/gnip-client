require 'spec_helper'

describe Gnip do
  
  it 'has a version number' do
    expect(Gnip::VERSION).not_to be nil
  end
  
  it 'should format datetime' do
    datetime = DateTime.parse("2015-06-01 00:00")
    expect(Gnip.format_date(datetime)).to eq("201506010000")
  end
    
end
