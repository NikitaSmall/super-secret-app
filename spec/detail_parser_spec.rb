require "#{File.dirname(__FILE__)}/spec_helper"

describe GitCounter do
  before(:each) do
    @parser = DetailParser.new('jeffball55/rop_compiler', '2016-03-14', '2016-03-21')
  end

  it 'counts stars properly' do
    VCR.use_cassette('stargazers_statistics_request') do
      stars = @parser.stargazers_statistics

      expect(stars).to be_a(Hash)
      expect(stars['2016-03-15']).to be_a(Integer)
    end
  end

  it 'caches stars if needed' do
    VCR.use_cassette('stargazers_statistics_request') do
      @parser.stargazers_statistics

      another_parser = DetailParser.new('jeffball55/rop_compiler', '2016-03-14', '2016-03-21')
      stars = another_parser.stargazers_statistics

      expect(stars).to be_a(Hash)
      expect(stars['2016-03-15']).to be_a(Integer)
    end
  end

  it 'counts commits properly' do
    VCR.use_cassette('commits_statistics_request') do
      commits = @parser.commits_statistics

      expect(commits).to be_a(Hash)
      expect(commits['2016-03-15']).to be_a(Integer)
    end
  end

  it 'caches commits if needed' do
    VCR.use_cassette('commits_statistics_request') do
      @parser.commits_statistics

      another_parser = DetailParser.new('jeffball55/rop_compiler', '2016-03-14', '2016-03-21')
      commits = another_parser.commits_statistics

      expect(commits).to be_a(Hash)
      expect(commits['2016-03-15']).to be_a(Integer)
    end
  end

  it 'counts contributors properly' do
    VCR.use_cassette('commits_statistics_request') do
      contributors = @parser.contributors_statistics

      expect(contributors).to be_a(Hash)
      expect(contributors['2016-03-15']).to be_a(Integer)
    end
  end

  it 'caches contributors if needed' do
    VCR.use_cassette('commits_statistics_request') do
      @parser.contributors_statistics

      another_parser = DetailParser.new('jeffball55/rop_compiler', '2016-03-14', '2016-03-21')
      contributors = another_parser.contributors_statistics

      expect(contributors).to be_a(Hash)
      expect(contributors['2016-03-15']).to be_a(Integer)
    end
  end

end
