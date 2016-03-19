require "#{File.dirname(__FILE__)}/spec_helper"

describe Githuber do
  before(:each) do
    @client = Githuber.new
  end

  it 'has default mode as :weekly' do
    expect(@client.mode).to eq(:weekly)
  end

  it 'returns result as a json string' do
    VCR.use_cassette('basic result') do
      expect(@client.result).to be_a(Hash)
    end
  end
end
