using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;

namespace WebApplication
{
    public partial class _Default : System.Web.UI.Page
    {
         private void GenerateSocialMediaString(string s)
         {
            string fb = @"/(?:https?:\/\/)?(?:www\.)?facebook\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*([\w\-\.]*)/";
            Regex f = new Regex(fb,RegexOptions.IgnoreCase);

            var xl = f.Matches(s);

            foreach (var x in xl)
            {
                Response.Write(String.Format("{0}<br/>",x));
            }

            Response.Write("<hr/>");
        }

         private void GenerateSocialMediaString2(string s)
         {
            if (!s.StartsWith("http"))
             {
                 s = String.Format("http://{0}", s);
             }

             Uri u = new Uri(s);

             var sa = u.AbsolutePath.Split('/');

             double myNum;

             //var oij = double.TryParse("146897575380523", out myNum);

             //Response.Write(myNum);

             foreach (var a in sa)
             {
                 if (String.IsNullOrEmpty(a) || a == "pages" || a == "#!" || double.TryParse(a,out myNum))
                 {
                     //ignore
                 }
                 else
                 {
                     Response.Write(String.Format("{0}<br/>", a));
                 }
             }

            // Response.Write(String.Format("{0}<br/>", u.AbsolutePath));
             
             Response.Write("<hr/>");
         }

        protected void Page_Load(object sender, EventArgs e)
        {
            GenerateSocialMediaString2("https://www.facebook.com/pages/Bluenose-Sidecar-Tours-Inc/146897575380523");
            GenerateSocialMediaString2("http://www.facebook.com/WhitePointBeachResort");
            GenerateSocialMediaString2("www.facebook.com/WhitePointBeachResort");
            //GenerateSocialMediaString2("");
            
        }
    }
}