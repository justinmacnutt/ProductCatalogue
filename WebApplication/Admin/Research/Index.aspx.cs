using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;

namespace WebApplication.Admin.Research
{
    public partial class Index : System.Web.UI.Page
    {
        private void lvProducts_PagePropertiesChanged(object sender, EventArgs e)
        {
            RefreshProductList();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            lvProducts.PagePropertiesChanged += new EventHandler(lvProducts_PagePropertiesChanged);

            if (!IsPostBack)
            {
                if (MySessionVariables.ResearchSearchParameters.HasValue)
                {
                    PopulateSearchForm();
                }
                //ddlAccommodationType.DataSource = EnumerationUtils.GetAccommodationTypeListItems();
                //ddlAccommodationType.DataTextField = "Text";
                //ddlAccommodationType.DataValueField = "Value";
                //ddlAccommodationType.DataBind();

                //for (var i = DateTime.Now.Year; i > 1992; i--)
                //{
                //    ddlYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                //}

            }

        }

        private void PopulateSearchForm()
        {
            ResearchSearchParameters mySearchParams = MySessionVariables.ResearchSearchParameters.Value;

            tbLicenseNumber.Text = mySearchParams.LicenseNumber;
            tbProductName.Text = mySearchParams.ProductName;

            if (mySearchParams.ProductTypeId != "")
            {
                rblProductType.SelectedValue = mySearchParams.ProductTypeId;
            }
        }

        protected void RefreshProductList()
        {
            MySessionVariables.ResearchSearchParameters.Clear();

            ResearchSearchParameters mySearchParams = new ResearchSearchParameters();

            string licenseNumber = tbLicenseNumber.Text;
            string productName = tbProductName.Text;

            ProductType? productType = (rblProductType.SelectedValue != "") ? (ProductType)(byte.Parse(rblProductType.SelectedValue)) : (ProductType?)null;

            mySearchParams.LicenseNumber = licenseNumber;
            mySearchParams.ProductName = productName;
            mySearchParams.ProductTypeId = (productType != null) ? productType.Value.ToString() : "";

            MySessionVariables.ResearchSearchParameters.Value = mySearchParams;

            ResearchBs researchBs = new ResearchBs();

            var productList = (!String.IsNullOrEmpty(licenseNumber) ? researchBs.GetProductsByLicenseNumber(new List<string> { licenseNumber }, productType) : researchBs.SearchProducts(productName, productType));

            if (productList.Count() == 1)
            {
                //need to fix this to deal with campgrounds
                Response.Redirect(String.Format("Edit{0}.aspx?productId={1}", (productList.First().productTypeId == (int)ProductType.Campground) ? "Campground" : "", productList.First().id));
                //forward to edit page
            }
            else
            {
                var results = productList.OrderBy(x=>x.licenseNumber).Select(p => FillListItem(p)).ToList();

                lvProducts.DataSource = results;
                lvProducts.DataBind();
                //show result list
            }
        }
        
        protected void btnSearch_OnClick(object sender, EventArgs e)
        {
            RefreshProductList();
        }

        private ResultListItem FillListItem(ProductCatalogue.DataAccess.Product p)
        {
            ResultListItem rli = new ResultListItem();

            rli.productId = p.id.ToString();
            rli.productName = p.productName.ToString();
            rli.productType = ResourceUtils.GetProductTypeLabel((ProductType)p.productTypeId);
            rli.productTypeId = p.productTypeId.ToString();
            rli.licenseNumber = p.licenseNumber;
            rli.regionName = (p.communityId != null) ? p.refCommunity.refRegion.regionName : "";
            rli.totalUnits = p.ProductUnitNumbers.Sum(x => x.units).ToString();
            
            return rli;
        }

        private class ResultListItem
        {
            public string productId { get; set; }
            public string licenseNumber { get; set; }
            public string productName { get; set; }
            public string productType { get; set; }
            public string regionName { get; set; }
            public string productTypeId { get; set; }
            public string totalUnits { get; set; }
        }
    }
}