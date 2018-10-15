using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(SolutionsWebSite2.Startup))]
namespace SolutionsWebSite2
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
