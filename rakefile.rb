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
    deployment = Deployment.load()    
    creator = DeployCommandCreator.new()
    mvc = creator.convert_from_config(config, :systest)
    require 'pp'
    pp deployment
    pp mvc
  end
end