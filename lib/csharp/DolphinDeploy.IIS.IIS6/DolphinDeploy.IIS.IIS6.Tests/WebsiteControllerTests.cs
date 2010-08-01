using Xunit;

namespace DolphinDeploy.IIS.IIS6.Tests
{
    public class WebsiteControllerTests
    {
        private string test_site = "C:\\inetpub\\wwwroot\\test_site";

        [Fact]
        public void Can_get_if_website_exists()
        {
            WebsiteController websiteController = CreateController();

            bool exist = websiteController.Exists();
            Assert.False(exist);
        }

        [Fact]
        public void Can_create_iis_website_given_name()
        {
            WebsiteController websiteController = CreateController();
            int websiteId = websiteController.Create();
            Assert.True(websiteId > 0);
        }

        [Fact]
        public void Can_start_site()
        {
            WebsiteController websiteController = CreateController();
            websiteController.Create();
            websiteController.Start();
            string html = Helper.GetSite("http://localhost:8888/");

            Assert.Contains("Hello World", html);
        }

        [Fact]
        public void Can_delete_website()
        {
            WebsiteController websiteController = CreateController();
            websiteController.Delete();
            Assert.False(websiteController.Exists());
        }

        private WebsiteController CreateController()
        {
            var websiteController = new WebsiteController();
            websiteController.Server = "localhost";
            websiteController.Name = "test_site";
            websiteController.HomeDirectory = test_site;
            websiteController.Port = 8888;
            websiteController.AppPool = "DefaultAppPool";
            return websiteController;
        }
    }
}