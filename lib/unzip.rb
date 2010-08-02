require 'zip/zip'

class UnZip  
  def self.unzip (file, destination)
    Zip::ZipFile.open(file) do |zip_file|
    zip_file.each do |f|
      file_path = File.join(destination, f.name)
      FileUtils.mkdir_p(File.dirname(file_path))
      zip_file.extract(f, file_path) unless File.exist?(file_path)
    end
  end
end