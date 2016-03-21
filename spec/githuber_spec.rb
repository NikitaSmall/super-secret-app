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

  it 'prevents to make few requests and store repos in database' do
    VCR.use_cassette('few_requests_check') do
      first_result = Githuber.new.repos
      second_result = Githuber.new.repos

      expect(RepoRawResult.count).to eq(1)
      expect(first_result).to eq(second_result)
    end
  end

  it 'returns orgs as an array' do
    VCR.use_cassette('orgs_result') do
      expect(@client.orgs).to be_a(Array)
    end
  end

  it 'saves the orgs to database' do
    VCR.use_cassette('orgs_result') do
      @client.orgs # trigger client to retrieve and save information

      expect(OrgsRawResult.count).to_not be_zero
    end
  end

  it 'database orgs are equal to original OrgsRawResult' do
    VCR.use_cassette('orgs_result') do
      client_result = @client.orgs
      saved_result = OrgsRawResult.first

      expect(saved_result.result).to eq(client_result)
    end
  end

  it 'prevents to make few requests and store orgs in database' do
    VCR.use_cassette('few_requests_check') do
      first_result = Githuber.new.orgs
      second_result = Githuber.new.orgs

      expect(OrgsRawResult.count).to eq(1)
      expect(first_result).to eq(second_result)
    end
  end
end
