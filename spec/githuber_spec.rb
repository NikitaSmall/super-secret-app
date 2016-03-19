require "#{File.dirname(__FILE__)}/spec_helper"

describe Githuber do
  before(:each) do
    @client = Githuber.new
  end

  it 'has default mode as :weekly' do
    expect(@client.mode).to eq(:weekly)
  end

  it 'returns repos as an array' do
    VCR.use_cassette('basic_result') do
      expect(@client.repos).to be_a(Array)
    end
  end

  it 'saves the repos to database' do
    VCR.use_cassette('basic_result') do
      @client.repos # trigger client to retrieve and save information

      expect(RepoRawResult.count).to_not be_zero
    end
  end

  it 'database repos are equal to original RepoRawResult' do
    VCR.use_cassette('basic_result') do
      client_result = @client.repos
      saved_result = RepoRawResult.first

      expect(saved_result.result).to eq(client_result)
    end
  end
end
