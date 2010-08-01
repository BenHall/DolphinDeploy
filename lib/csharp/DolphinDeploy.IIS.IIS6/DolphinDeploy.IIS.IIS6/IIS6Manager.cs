using System;
using System.DirectoryServices;

namespace DolphinDeploy.IIS.IIS6
{
    public class IIS6Manager
    {
        public string Server { get; set; }
        public string Name { get; set; }
        public int Port { get; set; }
        public string HomeDirectory { get; set; }

        public DirectoryEntry GetWebsite()
        {
            DirectoryEntry admin = GetIISAdmin();

            foreach (DirectoryEntry site in admin.Children)
            {
                PropertyValueCollection serverComment = site.Properties["ServerComment"];
                if (serverComment == null)
                    continue;

                if (serverComment.Value == null || string.IsNullOrEmpty(serverComment.Value.ToString()))
                    continue;

                if (string.Compare(serverComment.Value.ToString(), Name, false) == 0)
                {
                    return site;
                }
            }

            return null;
        }

        public DirectoryEntry GetAppPool()
        {
            DirectoryEntry appPools = GetAppPoolAdmin();
            foreach (DirectoryEntry appPool in appPools.Children)
            {
                if (Name.Equals(appPool.Name, StringComparison.OrdinalIgnoreCase))
                {
                    return appPool;
                }
            }

            return null;
        }

        public DirectoryEntry GetIISAdmin()
        {
            return new DirectoryEntry(string.Format("IIS://{0}/w3svc", Server));
        }

        public DirectoryEntry GetAppPoolAdmin()
        {
            return new DirectoryEntry(string.Format("IIS://{0}/w3svc/AppPools", Server));
        }

        public void DumpIISInfo(DirectoryEntry entry)
        {
            if (entry == null) entry = new DirectoryEntry("IIS://localhost/w3svc");

            foreach (DirectoryEntry childEntry in entry.Children)
            {
                using (childEntry)
                {
                    Console.WriteLine(string.Format("Child name [{0}]", childEntry.Name));
                    foreach (PropertyValueCollection property in childEntry.Properties)
                    {
                        Console.WriteLine(string.Format("[{0}] [{1}] [{2}]", childEntry.Name, property.PropertyName, property.Value));
                    }
                    
                    DumpIISInfo(childEntry);
                }
            }
        }
    }
}