class FileManager
  def extract(location, zip_path, env)
    UnZip.unzip(zip_path, location)
    swap_configs(location, env)
  end
  
  def get_latest_version(location, site_name)
    dirs = Dir.glob("#{location}/**").grep(/#{site_name}/)
    
    new_version = find_next_release_version(dirs, site_name)
    
    File.join(location, site_name + "-" + "%02d" % new_version)
  end
  
  def find_next_release_version(dirs, site_name)
    release_numbers = [0]
    
    dirs.each do |dir|
      s = /#{site_name}-(\d+)/.match(dir)
      release_numbers << s[1].to_i unless s.nil?
    end
    
    new_version = release_numbers.max + 1
  end
  
  def swap_configs(location, env)    
    FileUtils.cp File.join(location, 'web.config'), File.join(location, 'web.original.config')
    FileUtils.mv File.join(location, "web.#{env.to_s}.config"), File.join(location, 'web.config')
  end
end