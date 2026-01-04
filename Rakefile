=begin

    This file is part of the slotz project and may be subject to
    redistribution and commercial restrictions. Please see the slotz
    web site for more information on licensing and terms of use.

=end

require 'rubygems'
require File.expand_path( File.dirname( __FILE__ ) ) + '/lib/slotz/version'

begin
    require 'rspec'
    require 'rspec/core/rake_task'

    RSpec::Core::RakeTask.new
rescue
end

task default: [ :build, :spec ]

desc 'Generate docs'
task :docs do
    outdir = "../slotz"
    sh "rm -rf #{outdir}"
    sh "mkdir -p #{outdir}"

    sh "yardoc -o #{outdir}"

    sh "rm -rf .yardoc"
end

desc 'Clean up'
task :clean do
    sh 'rm *.gem || true'
end

desc 'Build the slotz gem.'
task build: [ :clean ] do
    sh 'gem build slotz.gemspec'
end

desc 'Build and install the slotz gem.'
task install: [ :build ] do
    sh "gem install slotz-#{Slotz::VERSION}.gem"
end

desc 'Push a new version to Rubygems'
task publish: [ :build ] do
    sh "git tag -a v#{Slotz::VERSION} -m 'Version #{Slotz::VERSION}'"
    sh "gem push slotz-#{Slotz::VERSION}.gem"
end
task release: [ :publish ]
