require 'rubygems'
require 'fileutils'
require 'pathname'
require 'rake'
require 'rspec/core/rake_task'
require 'yard'
require 'git'
$:.push File.expand_path("../lib", __FILE__)
require "orm_adapter-sequel/version"

RakeFileUtils.verbose_flag = true

GEM_NAME  = "orm_adapter-sequel"

task :default => :spec

directory 'tmp'

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb', 'README.rdoc']
end

RSpec::Core::RakeTask.new(:spec)

task :spec

desc "Update the orm_adapter specs used for testing"
task :update_orm_specs  => "tmp" do
  spec_files = FileList["orm_adapter/example_app_shared.rb"]
  orm = Pathname.new("tmp/orm_adapter")
  from = orm + "spec"
  to = Pathname.new("spec")
  gemfile = from.parent + "Gemfile"

  repo = if gemfile.exist?
    Git.open(orm)
  else
    # checkout orm_adapter
    Git.clone("https://github.com/ianwhite/orm_adapter.git", orm, :working_directory => orm)
  end
  # always pull to be sure
  stat = repo.pull
  # copy over the spec
  spec_files.each do |f|
    cp from.join(f), to.join(File.basename(f))
  end
end

desc "Build the gem"
task :build do
  system "gem build #{GEM_NAME}.gemspec"
end

namespace :release do
  task :rubygems => :pre do
    system "gem push #{GEM_NAME}-#{OrmAdapterSequel::VERSION}.gem"
  end

  task :github => :pre do
    tag = "v#{OrmAdapterSequel::VERSION}"
    git = Git.open('.')

    if (git.tag(tag) rescue nil)
      raise "** repo is already tagged with: #{tag}"
    end

    git.add_tag(tag)
    git.push('origin', tag)
  end

  task :pre => [:spec, :build] do
    git = Git.open('.')

    if (git.status.changed + git.status.added + git.status.deleted).any?
      raise "** repo is not clean, try committing some files"
    end

    if git.object('HEAD').sha != git.object('origin/master').sha
      raise "** origin does not match HEAD, have you pushed?"
    end
  end

  task :all => ['release:github', 'release:rubygems']
end