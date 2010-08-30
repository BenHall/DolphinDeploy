$: << 'lib'
namespace :specs do
  require 'spec/rake/spectask'

  @spec_opts = '--colour --format specdoc'

  desc "Run specs for Dolphin"
  Spec::Rake::SpecTask.new :all do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
end
