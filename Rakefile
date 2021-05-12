# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'ndr_dev_support/tasks'
require 'ndr_support/safe_path'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
  t.warning = false
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[test rubocop]

SafePath.configure! 'filesystem_paths.yml'
