using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using AjaxControlToolkit;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;

namespace WebApplication.WebServices
{
    /// <summary>
    /// Summary description for Services
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Services : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public string[] GetBusinessNameList(string prefixText, int count)
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
                //suggestions.Add(i.businessName);
                suggestions.Add(AutoCompleteExtender.CreateAutoCompleteItem(i.businessName,i.id.ToString()));
                c++;
            }

            return suggestions.ToArray();
        }

        [WebMethod]
        public string[] GetLicenseNumberList(string prefixText, int count)
        {
            ProductBs productBs = new ProductBs();

            //List<GetBusinessNamesResult> l = db.GetBusinessNames(prefixText).ToList();

            Dictionary<string, int> lnl = productBs.GetLicenseNumbers(prefixText);
            
            List<string> suggestions = new List<string>();

            int c = 1;
            foreach (var ln in lnl)
            {
                if (c > count)
                {
                    break;
                }
                //suggestions.Add(i.businessName);
                suggestions.Add(AutoCompleteExtender.CreateAutoCompleteItem(ln.Key, ln.Value.ToString()));
                c++;
            }

            return suggestions.ToArray();
        }
    }
}
