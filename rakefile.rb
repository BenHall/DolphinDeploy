$: << 'lib'
require 'dolphindeploy'
   
namespace :specs do
  require 'spec/rake/spectask'

  @spec_opts = '--colour --format specdoc'

  desc "Run specs for Dolphin"
  Spec::Rake::SpecTask.new :all do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
  
end

namespace :example do
 desc "Example"
 task :run do
   @deployment = Deployment.load()    
   require 'pp'
   pp @deployment
 end
end