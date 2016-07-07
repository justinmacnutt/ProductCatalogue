using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using WebApplication.Utilities;

namespace WebApplication.Admin.Report
{
    public partial class PrintGuideForms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                ProductBs productBs = new ProductBs();

                var regions = productBs.GetAllRegions();

                ddlRegion.DataSource = regions;
                ddlRegion.DataTextField = "regionName";
                ddlRegion.DataValueField = "id";
                ddlRegion.DataBind();

                ddlProofRegion.DataSource = regions;
                ddlProofRegion.DataTextField = "regionName";
                ddlProofRegion.DataValueField = "id";
                ddlProofRegion.DataBind();
        
            }

        }

        protected void btnGenerateForm_OnClick(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }
    }
}