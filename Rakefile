require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'dotenv/tasks'

require File.join(File.dirname(__FILE__), 'environment')

task :default => :test
task :test => :spec

if !defined?(RSpec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = Dir['spec/**/*_spec.rb']
  end
end

task :environment => :dotenv do
  require File.join(File.dirname(__FILE__), 'environment')
end

task :console do
  ruby 'script/console'
end

# the tasks for background scheduler to store repos and orgs data before use.
namespace :repo do
  task :weekly do
    client = Githuber.new(:weekly)
    parser = RepoParser.new(client.query, client.repos, 'weekly', :contributors_count)

    parser.parse
  end

  task :monthly do
    client = Githuber.new(:monthly)
    parser = RepoParser.new(client.query, client.repos, 'monthly', :contributors_count)

    parser.parse
  end

  task :last_monthly do
    client = Githuber.new(:monthly)
    parser = RepoParser.new(client.query, client.repos, 'weekly', :contributors_count)

    parser.parse
  end
end

namespace :org do
  task :weekly do
    client = Githuber.new(:weekly)
    parser = OrgParser.new(client.query, client.orgs, 'weekly', :total_commits_count)

    parser.parse
  end

  task :monthly do
    client = Githuber.new(:monthly)
    parser = OrgParser.new(client.query, client.orgs, 'monthly', :total_commits_count)

    parser.parse
  end

  task :last_monthly do
    client = Githuber.new(:monthly)
    parser = OrgParser.new(client.query, client.orgs, 'weekly', :total_commits_count)

    parser.parse
  end
end
