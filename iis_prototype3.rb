$: << 'external'
load_assembly 'Microsoft.Web.Administration'
include Microsoft::Web::Administration

site_name = "DD_Test"
app_pool_name = "DD_TestPool"

iis = ServerManager.new

iis.application_pools.Add(app_pool_name);
iis.commit_changes


iis.sites.add(site_name, 'C:\\inetpub\\wwwroot\\test_site', 8889)
iis.commit_changes