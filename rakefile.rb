$: << 'lib'
require 'dolphindeploy_rake'
   
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
    
    env = :local
    server = 'localhost'
    
    mvc = creator.convert_from_config(deployment, env)
    mvc.deploy server
  end
end


