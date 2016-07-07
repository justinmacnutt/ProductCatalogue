using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;

namespace WebApplication.Admin.Research
{
    public partial class CampConfidential : System.Web.UI.Page
    {
        public class ProductVo
        {
            public string licenseNumber { get; set; }
            public string productName { get; set; }
            public int productId { get; set; }
        } 

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                for (var i = DateTime.Now.Year; i > 1992; i--)
                {
                    ddlYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
            }
        }

        [WebMethod]
        public static List<ProductVo> GetProducts(string productName)
        {
            var researchBs = new ResearchBs();
            return researchBs.GetCampgrounds(productName).Select(p => new ProductVo {licenseNumber = p.licenseNumber, productId = p.id, productName = p.productName}).ToList();
        }

        [WebMethod]
        public static void ValidateForm(string productName, string licenseNumber)
        {
            var researchBs = new ResearchBs();
            
            if (!String.IsNullOrEmpty(licenseNumber))
            {
                var pl = researchBs.GetProductsByLicenseNumber(new List<string> { licenseNumber }, ProductType.Campground);
                if (pl.Count() != 1)
                {
                    throw new Exception("dvErrorNoLicenseNumber");
                }
                
            }
            else if (!String.IsNullOrEmpty(productName))
            {
                var p = researchBs.GetAccommodationByName(productName);
                if (p == null)
                {
                    throw new Exception("dvErrorNoProductName");
                }
                
            }
            return;
        }
    }
}