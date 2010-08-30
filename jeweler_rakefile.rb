namespace :jeweler do
 begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "dolphindeploy"
    gemspec.summary = "Dolphin Deploy - Automated deployment for ASP.net websites"
    gemspec.description = "Dolphin Deploy - Automated deployment for ASP.net websites."
    gemspec.email = "ben@benhall.me.uk"
    gemspec.homepage = "http://github.com/BenHall/dolphindeploy"
    gemspec.authors = ["Ben Hall"]
    gemspec.files =  FileList["README*", "{external,lib}/**/*"]
    gemspec.has_rdoc = false  
    gemspec.platform = Gem::Platform.new(["universal", "dotnet"])
    # IronRuby Platform
    
    gemspec.add_dependency('caesars', '>= 0.7.4')

    gemspec.add_development_dependency('rspec', '>= 1.2.8')
    gemspec.add_development_dependency('jeweler', '>= 1.4.0')
    gemspec.add_development_dependency('mocha', '>= 0.9.8')
    
  end

  Jeweler::GemcutterTasks.new
  
  Jeweler::RubyforgeTasks.new do |t|
    t.doc_task = :yardoc
  end
 rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
 end
end

