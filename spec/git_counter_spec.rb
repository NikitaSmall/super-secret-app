require "#{File.dirname(__FILE__)}/spec_helper"

describe GitCounter do
  before(:each) do
    @counter = GitCounter.new('jeffball55/rop_compiler', 'weekly')
  end

  it 'counts stars properly' do
    VCR.use_cassette('stargazers_request') do
      stars = @counter.count_stargazers

      expect(stars).to be_a(Integer)
      expect(stars).to_not be_zero
    end
  end

  it 'counts commits properly' do
    VCR.use_cassette('commits_request') do
      commits = @counter.count_commits

      expect(commits).to be_a(Integer)
      expect(commits).to_not be_zero
    end
  end

  it 'counts contributors properly' do
    # yes, it uses same result for contributors and commits. See in a code.
    VCR.use_cassette('commits_request') do
      contributors = @counter.count_contributors

      expect(contributors).to be_a(Integer)
      expect(contributors).to_not be_zero
    end
  end
end
