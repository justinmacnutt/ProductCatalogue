using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using WebApplication.ValueObjects;
using BusinessSearchListItem = WebApplication.ValueObjects.ListItemVos.BusinessSearchListItem;

namespace WebApplication.Admin.Business
{
    public partial class Index : System.Web.UI.Page
    {
        private string[] letters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
                     "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                     "W", "X", "Y", "Z"};

        protected override void OnPreRender(EventArgs e)
        {
            lvBusinesses.DataSource = GenerateBusinessList();
            lvBusinesses.DataBind();
            base.OnPreRender(e);
        }

     //   private IQueryable<ProductCatalogue.DataAccess.Business> GenerateProductList()
        private List<BusinessSearchListItem> GenerateBusinessList()
        {
            BusinessBs businessBs = new BusinessBs();
            //IQueryable<ProductCatalogue.DataAccess.Product> productList = productBs.GetAllProducts();
            //IQueryable<ProductCatalogue.DataAccess.Product> productList = productBs.GetProducts(-1, "", "", "Aber", -1, -1, -1);
            int businessId = -1;
            if (tbBusinessId.Text != "")
            {
                businessId = Int32.Parse(tbBusinessId.Text);
            }

            //IQueryable<ProductCatalogue.DataAccess.Business> businessList = businessBs.GetBusinesses(businessId, tbBusinessName.Text);
            List<SearchBusinessesResult> businessList = businessBs.SearchBusinesses(businessId, tbBusinessName.Text, tbCommunityName.Text, hdnLetterFilter.Value );

            //if (hdnLetterFilter.Value != "")
            //{
            //    businessList = from b in businessList
            //                  where b.businessName.StartsWith(hdnLetterFilter.Value)
            //                  select b;
            //}

            List<BusinessSearchListItem> bl = new List<BusinessSearchListItem>();
            foreach (var b in businessList)
            {
                var bli = new BusinessSearchListItem();
                bli.businessId = b.businessId.ToString();
                bli.businessName = b.businessName;
                bli.primaryContactEmail = b.email;
                bli.primaryContactPhone = b.phoneNumber;
                bli.primaryContactName = String.Format("{0} {1}", b.contactFirstName, b.contactLastName);
                bl.Add(bli);
                
            }

            //return businessList;
            return bl;
        }

       protected void Page_Load(object sender, EventArgs e)
        {
            rptLetters.DataSource = letters.ToList();
            rptLetters.DataBind();
        }

        protected void lnkLetter_OnClick(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;

            hdnLetterFilter.Value = lb.CommandArgument;
            dpBusinessPager.SetPageProperties(0, 20, false);
        }

        protected void btnFilter_OnClick(object sender, EventArgs e)
        {
            hdnLetterFilter.Value = "";
            //ProductBs productBs = new ProductBs();
            //productBs.GetProducts(-1, "", "", "Aber", -1, -1, -1);
        }

    }
}