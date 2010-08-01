load_assembly 'System.DirectoryServices'
include System::DirectoryServices


site_name = "DD_Test".to_clr_string


app_pools = DirectoryEntry.new("IIS://localhost/w3svc/AppPools".to_clr_string)
pool = app_pools.Children.Add(site_name, "IISApplicationPool".to_clr_string)
pool.invoke_set("AppPoolId".to_clr_string, [site_name].ToArray)
pool.invoke_set("AppPoolIdentityType".to_clr_string, [0].ToArray)
pool.Properties["AppPoolQueueLength".to_clr_string].Value = 4000
pool.Invoke("SetInfo".to_clr_string, nil)

pool.commit_changes


iis = DirectoryEntry.new("IIS://localhost/w3svc".to_clr_string)
iis.Children.each do |i|
  puts i.properties["ServerComment"]
end
iis.invoke_set("CreateNewSite", [site_name, [":80:"].ToArray, 'D:\\SourceControl\\meerpush\\meerpush.tests\\test_site'])
iis.commit_changes	