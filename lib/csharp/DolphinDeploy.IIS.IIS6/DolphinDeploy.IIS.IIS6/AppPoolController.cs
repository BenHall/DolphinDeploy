using System;
using System.DirectoryServices;

namespace DolphinDeploy.IIS.IIS6
{
    public class AppPoolController : IIS6Manager
    {
        public void Create()
        {
            DirectoryEntry appPools = GetAppPoolAdmin();
            DirectoryEntry appPool = appPools.Children.Add(Name, "IISApplicationPool");
            appPool.CommitChanges();

            SetProperties(appPool);
            appPool.CommitChanges();

        }

        private void SetProperties(DirectoryEntry appPool)
        {
            try
            {
                appPool.InvokeSet("AppPoolId", new Object[] { Name });
                appPool.InvokeSet("AppPoolIdentityType", new Object[] { 0 });

            }
            catch (Exception)
            {
                //problems when executing against IIS7
            }
            appPool.Properties["AppPoolQueueLength"].Value = 4000;
            appPool.Invoke("SetInfo", null);
        }

        public bool Exists()
        {
            var appPool = GetAppPool();

            return appPool != null;
        }

        public void Delete()
        {
            if (Exists())
            {
                var appPool = GetAppPool();
                appPool.DeleteTree();
            }
        }
    }
}
