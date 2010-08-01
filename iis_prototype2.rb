$: << 'external'
load_assembly 'DolphinDeploy.IIS.IIS6'
include System
include System::Diagnostics
include DolphinDeploy::IIS::IIS6

iis_version = FileVersionInfo.GetVersionInfo(Environment.SystemDirectory + "\\inetsrv\\inetinfo.exe")
puts iis_version.product_version
if(iis_version.product_version =~ /^7/)
  puts "You can running against IIS7"
else
  puts "You can running against IIS6"  
end

site_name = "DD_Test"
app_pool_name = "DD_TestPool"

app_pool = AppPoolController.new
app_pool.server = "localhost"
app_pool.name = app_pool_name
app_pool.create


website = WebsiteController.new
website.name = site_name
website.app_pool = app_pool_name
website.home_directory = 'C:\\inetpub\\wwwroot\\test_site'
website.port = 8888
website.server = "localhost"


website.create
website.start