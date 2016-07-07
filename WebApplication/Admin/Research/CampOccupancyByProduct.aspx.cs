using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;

namespace WebApplication.Admin.Research
{
    public partial class CampOccupancyByProduct : System.Web.UI.Page
    {
        public class ProductListVo
        {
            public string licenseNumber { get; set; }
            public string productName { get; set; }
            public string accommodationType { get; set; }
            public string region { get; set; }
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
             
                hdnYears.Value = DateTime.Now.Year.ToString();
            }
        }

        [WebMethod]
        public static string AddProduct(string newLicenseNumber, string currentValues)
        {
          //  return "1,2,4";
            //Exception e = new Exception("THIS BROKE");
            //throw e;

            var researchBs = new ResearchBs();

            List<int> idList = new List<int>();

            List<ProductListVo> plvl = new List<ProductListVo>();

            if (!String.IsNullOrEmpty(currentValues))
            {
                idList.AddRange(currentValues.Split(',').Select(Int32.Parse).ToList());
            }

            var pq = researchBs.GetProductsByLicenseNumber(new List<string>{newLicenseNumber}, ProductType.Campground).FirstOrDefault();

            if (pq != null && !idList.Contains(pq.id))
            {
                idList.Add(pq.id);
            }
            else if (pq == null)
            {
                throw new Exception("License Number does not exist.");  
            }
            else if (idList.Contains(pq.id))
            {
                throw new Exception("License Number has already been added.");
            }

            return string.Join(",", idList.Select(z => z.ToString()).ToArray()); 
        }

        [WebMethod]
        public static List<ProductListVo> GetProductList(string idList)
        {
            List<string> lnl = new List<string>();
            List<ProductListVo> plvl = new List<ProductListVo>();

            //no products
            if (String.IsNullOrEmpty(idList))
            {
                return plvl;
            }

            var researchBs = new ResearchBs();
            lnl.AddRange(idList.Split(',').ToList());

            //var pq = researchBs.GetProductsForResearch(lnl.Select(Int32.Parse).ToList()).OrderBy(p => (!String.IsNullOrEmpty(p.licenseNumber)) ? Int32.Parse(p.licenseNumber) : 0);
            var pq = researchBs.GetProductsForResearch(lnl.Select(Int32.Parse).ToList(), ProductType.Campground);

            foreach (var p in pq)
            {
                plvl.Add(new ProductListVo
                {
                    licenseNumber = p.licenseNumber,
                    productId = p.id,
                    productName = p.productName,
                    region = (p.communityId != null) ? ResourceUtils.GetRegionLabel((Region)p.refCommunity.regionId) : "",
                    //accommodationType = ResourceUtils.GetAccommodationTypeLabel((AccommodationType)(p.ProductAttributes.Where(pa => pa.attributeGroupId == (int)AttributeGroup.AccommodationType).First()).attributeId)
                });
            }

            return plvl;


        }


        [WebMethod]
        public static void ValidateOneThird(string productIds)
        {
            List<string> lnl = new List<string>();
            
            lnl.AddRange(productIds.Split(',').ToList());

            var researchBs = new ResearchBs();

            //no products
            if (lnl.Count == 0)
            {
                return;
            }

            var pl = researchBs.GetProductsExceedOneThirdTotalUnits(lnl.Select(Int32.Parse).ToList());

            if (pl.Count > 0)
            {
                throw new Exception("This report cannot be run because at least one third of the units are coming from one property.");   
            }
        }



        protected void btnGenerateCsv_OnClick(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }
    }

    
}