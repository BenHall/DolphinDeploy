class DirectoryCleanup
  def remove_last(directory_to_clean, keep_last=10)
    dir_to_remove = get_directories_to_remove(directory_to_clean, keep_last)
    dir_to_remove.each do |d|
      puts "Removing " + d
      FileUtils.rm_r d, :force => true
    end
  end
  
  def get_directories_to_remove(directory_to_clean, keep_last)
    Dir.chdir directory_to_clean   
    ordered = Dir.glob('**').sort_by {|d| File.mtime(d)}
    dir_to_keep = ordered[ordered.length-keep_last..ordered.length]
    ordered - dir_to_keep
  end
end