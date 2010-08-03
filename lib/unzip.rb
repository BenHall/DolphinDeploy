$: << 'external'
require 'TinySharpZip'
include System::IO

class UnZip  
  def self.unzip (file, destination)
    FileUtils.mkdir_p destination
    puts file + " to >> " + destination
    TinySharpZip::ZipArchive.Extract(FileStream.new(file, FileMode.Open), destination)
  end
end