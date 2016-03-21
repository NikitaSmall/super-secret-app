require "#{File.dirname(__FILE__)}/spec_helper"

describe OrgParser do
  before(:each) do
    @client = Githuber.new
  end

  it 'keeps right mode of request' do
    VCR.use_cassette('orgs_parse_result') do
      client = Githuber.new(:monthly)
      parser = OrgParser.new(client.query, client.orgs, 'monthly')

      expect(parser.mode).to eq('monthly')
    end
  end

  it 'fixs mode of request if needed' do
    VCR.use_cassette('orgs_parse_result') do
      parser = OrgParser.new(@client.query, @client.orgs, 'monthly')
      # we can search for month-old data in a weekdays old repo, but it is useless
      expect(parser.mode).to eq('weekly')
    end
  end

  it 'returns array of hashes' do
    VCR.use_cassette('orgs_parse_result') do
      @parser = OrgParser.new(@client.query, @client.orgs)
      orgs = @parser.parse

      expect(orgs).to be_a(Array)
      expect(orgs.first).to be_a(Hash)
    end
  end

  it 'prevents to rerun parsing with same query' do
    VCR.use_cassette('orgs_parse_result') do
      @parser = OrgParser.new(@client.query, @client.orgs)
      orgs_one = @parser.parse
      orgs_two = @parser.parse

      expect(orgs_one).to eq(orgs_two)
    end
  end

  it 'stores cached orgs to database' do
    VCR.use_cassette('orgs_parse_result') do
      @parser = OrgParser.new(@client.query, @client.orgs)
      orgs_one = @parser.parse

      expect(Org.count).to_not be_zero
    end
  end

  it 'prevents to double records to database' do
    VCR.use_cassette('orgs_parse_result') do
      parser_one = OrgParser.new(@client.query, @client.orgs)
      parser_two = OrgParser.new(@client.query, @client.orgs)

      parser_one.parse
      records_count = Org.count
      parser_two.parse

      expect(records_count).to eq(Org.count)
    end
  end

  it 'stores cached orgs as array of hashes' do
    VCR.use_cassette('orgs_parse_result') do
      parser_one = OrgParser.new(@client.query, @client.orgs)
      parser_two = OrgParser.new(@client.query, @client.orgs)

      parser_one.parse
      orgs = parser_two.parse

      expect(orgs).to be_a(Array)
      expect(orgs.first).to be_a(Hash)
    end
  end

  it 'returns result sorted by average commits count' do
    VCR.use_cassette('orgs_parse_result') do
      parser = OrgParser.new(@client.query, @client.orgs)
      orgs = parser.parse

      expect(orgs.first['average_commits_count']).to be > orgs.last['average_commits_count']
    end
  end

  it 'returns result sorted by total commits count' do
    VCR.use_cassette('orgs_parse_result') do
      parser = OrgParser.new(@client.query, @client.orgs, 'weekly', :contributors_count)
      orgs = parser.parse

      expect(orgs.first['total_commits_count']).to be > orgs.last['total_commits_count']
    end
  end
end
