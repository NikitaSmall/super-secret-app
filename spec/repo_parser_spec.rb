require "#{File.dirname(__FILE__)}/spec_helper"

describe RepoParser do
  before(:each) do
    @client = Githuber.new
  end

  it 'keeps right mode of request' do
    VCR.use_cassette('parse_result') do
      client = Githuber.new(:monthly)
      parser = RepoParser.new(client.query, client.repos, 'monthly')

      expect(parser.mode).to eq('monthly')
    end
  end

  it 'fixs mode of request if needed' do
    VCR.use_cassette('parse_result') do
      parser = RepoParser.new(@client.query, @client.repos, 'monthly')
      # we can search for month-old data in a weekdays old repo, but it is useless
      expect(parser.mode).to eq('weekly')
    end
  end

  it 'returns array of hashes' do
    VCR.use_cassette('parse_result') do
      @parser = RepoParser.new(@client.query, @client.repos)
      repos = @parser.parse

      expect(repos).to be_a(Array)
      expect(repos.first).to be_a(Hash)
    end
  end

  it 'prevents to rerun parsing with same query' do
    VCR.use_cassette('parse_result') do
      @parser = RepoParser.new(@client.query, @client.repos)
      repos_one = @parser.parse
      repos_two = @parser.parse

      expect(repos_one).to eq(repos_two)
    end
  end

  it 'stores cached repos to database' do
    VCR.use_cassette('parse_result') do
      @parser = RepoParser.new(@client.query, @client.repos)
      repos_one = @parser.parse

      expect(Repo.count).to_not be_zero
    end
  end

  it 'prevents to double records to database' do
    VCR.use_cassette('parse_result') do
      parser_one = RepoParser.new(@client.query, @client.repos)
      parser_two = RepoParser.new(@client.query, @client.repos)

      parser_one.parse
      records_count = Repo.count
      parser_two.parse

      expect(records_count).to eq(Repo.count)
    end
  end

  it 'stores cached repos as array of hashes' do
    VCR.use_cassette('parse_result') do
      parser_one = RepoParser.new(@client.query, @client.repos)
      parser_two = RepoParser.new(@client.query, @client.repos)

      parser_one.parse
      repos = parser_two.parse

      expect(repos).to be_a(Array)
      expect(repos.first).to be_a(Hash)
    end
  end

  it 'returns result sorted by default (by stars)' do
    VCR.use_cassette('parse_result') do
      parser = RepoParser.new(@client.query, @client.repos)
      repos = parser.parse

      expect(repos.first['stargazers_count']).to be > repos.last['stargazers_count']
    end
  end

  it 'returns result sorted by commits' do
    VCR.use_cassette('parse_result') do
      parser = RepoParser.new(@client.query, @client.repos, 'weekly', :commits_count)
      repos = parser.parse

      expect(repos.first['commits_count']).to be > repos.last['commits_count']
    end
  end

  it 'returns result sorted by contributors' do
    VCR.use_cassette('parse_result') do
      parser = RepoParser.new(@client.query, @client.repos, 'weekly', :contributors_count)
      repos = parser.parse

      expect(repos.first['contributors_count']).to be > repos.last['contributors_count']
    end
  end
end
