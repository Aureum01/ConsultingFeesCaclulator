using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CIS325CFC.Startup))]
namespace CIS325CFC
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
