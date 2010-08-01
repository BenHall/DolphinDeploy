$: << 'external'
load_assembly 'DolphinDeploy.IIS.IIS6'
include DolphinDeploy::IIS::IIS6


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