using System;
using System.DirectoryServices;

namespace DolphinDeploy.IIS.IIS6
{
    public class WebsiteController : IIS6Manager
    {
        public string AppPool { get; set; }
        public string HostHeader { get; set; }
        public string IpAddress { get; set; }
        public int Port { get; set; }

        public int Create()
        {
            try
            {
                int websiteId = CreateWebsite(GetIISSiteEntryName());

                var website = GetWebsite();
                
                SetProperties(website);

                return websiteId;
            }
            catch (Exception)
            {
                return -1;
            }
        }

        public void Start()
        {
            DirectoryEntry website = GetWebsite();
            website.Invoke("Start", null);
        }

        public bool Exists()
        {
            var website = GetWebsite();
            return website != null;
        }

        public void Delete()
        {
            if (Exists())
            {
                var website = GetWebsite();
                website.DeleteTree();
            }
        }

        private void SetProperties(DirectoryEntry website)
        {
            SetSecurity(website);
            SetFriendlyName(website);
            SetASPnetVersion(website);
        }

        private int CreateWebsite(object[] newsite)
        {
            DirectoryEntry admin = GetIISAdmin();
            int websiteId = (int)admin.Invoke("CreateNewSite", newsite);
            admin.CommitChanges();
            return websiteId;
        }

        private void SetSecurity(DirectoryEntry website)
        {
            website.Properties["AppPoolId"][0] = AppPool;
            website.Properties["AccessFlags"][0] = 512;
            website.Properties["AccessRead"][0] = true;
            website.Properties["AuthFlags"][0] = 5;
            website.CommitChanges();
        }

        private void SetFriendlyName(DirectoryEntry website)
        {
            website.Properties["AppFriendlyName"][0] = website.Name;
            website.CommitChanges();
        }

        private void SetASPnetVersion(DirectoryEntry website)
        {
            // upgrade Scriptmap to 2.0.50272 (ASP.NET version)
            for (int prop = 0; prop < website.Properties["ScriptMaps"].Count; prop++)
            {
                website.Properties["ScriptMaps"][prop] = website.Properties["ScriptMaps"][prop].ToString().Replace("v1.1.4322", "v2.0.50727");
            }

            website.CommitChanges();
        }

        private object[] GetIISSiteEntryName()
        {
            return new object[] { Name, new object[] { string.Format("{0}:{1}:{2}", IpAddress, Port, HostHeader) }, HomeDirectory };
        }
    }
}
