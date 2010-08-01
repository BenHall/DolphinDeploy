using System;
using System.IO;
using System.Net;

namespace DolphinDeploy.IIS.IIS6.Tests
{
    public static class Helper
    {
        public static string GetSite(string uri)
        {
            var request = WebRequest.Create(new Uri(uri));
            var response = (HttpWebResponse)request.GetResponse();
            StreamReader reader = new StreamReader(response.GetResponseStream());

            return reader.ReadToEnd();
        }
    }
}