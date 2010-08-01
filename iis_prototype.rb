load_assembly 'System.DirectoryServices'
include System
include System::Diagnostics
include System::DirectoryServices

iis_version = FileVersionInfo.GetVersionInfo(Environment.SystemDirectory + "\\inetsrv\\inetinfo.exe")
puts iis_version.product_version
if(iis_version.product_version =~ /^7/)
  puts "You can running against IIS7+"
else
  puts "You can running against IIS6"  
end

site_name = "DD_Test".to_clr_string


app_pools = DirectoryEntry.new("IIS://localhost/w3svc/AppPools".to_clr_string)
pool = app_pools.Children.Add(site_name, "IISApplicationPool".to_clr_string)
pool.Properties["AppPoolQueueLength".to_clr_string].Value = 4000
pool.Invoke("SetInfo".to_clr_string, nil)

pool.commit_changes


iis = DirectoryEntry.new("IIS://localhost/w3svc".to_clr_string)
iis.Children.each do |i|
  puts i.properties["ServerComment"]
end
iis.invoke_set("CreateNewSite", [site_name, [":80:"].ToArray, 'D:\\SourceControl\\meerpush\\meerpush.tests\\test_site'])
iis.commit_changes	