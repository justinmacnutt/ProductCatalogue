using System;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using WebApplication.Utilities;

namespace WebApplication.Admin.Research
{
    public partial class CampOccupancyByGeography : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ProductBs productBs = new ProductBs();

                ddlArea.DataSource = productBs.GetAllSubRegions();
                ddlArea.DataTextField = "subRegionName";
                ddlArea.DataValueField = "id";
                ddlArea.DataBind();

                ddlCounty.DataSource = productBs.GetAllCounties();
                ddlCounty.DataTextField = "countyName";
                ddlCounty.DataValueField = "id";
                ddlCounty.DataBind();

                for (double i = 1.0;i <= 5.0 ; i += 0.5)
                {
                    ddlStarClass.Items.Add(new ListItem(String.Format("{0:0.0}", i), (i * 2).ToString()));
                }

                for (var i = DateTime.Now.Year; i > 1992; i--)
                {
                    ddlYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
             
            }

        }

        protected void btnGenerateCsv_OnClick(object sender, EventArgs e)
        {
            

        }
    }
}