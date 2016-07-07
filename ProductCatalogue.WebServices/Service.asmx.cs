using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using ProductCatalogue.DataAccess;


namespace ProductCatalogue.WebServices
{
    /// <summary>
    /// Summary description for Service1
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class Service1 : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public string[] GetLastNameList(string prefixText, int count)
        {
            TourismDataContext db = new TourismDataContext(ConfigurationManager.ConnectionStrings["Tourism2ConnectionString"].ConnectionString);

            List<GetBusinessNamesResult> l = db.GetBusinessNames(prefixText).ToList();
            List<string> suggestions = new List<string>();

            int c = 1;
            foreach (GetBusinessNamesResult i in l)
            {
                if (c > count)
                {
                    break;
                }
                suggestions.Add(i.businessName);
                c++;
            }

            return suggestions.ToArray();
        }
    }
}