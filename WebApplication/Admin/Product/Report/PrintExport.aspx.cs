using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;

namespace WebApplication.Admin.Report
{
    public partial class PrintExport : System.Web.UI.Page
    {
        private const string ExportFilePath = "/Templates/PrintExport.template";

        protected void Page_Load(object sender, EventArgs e)
        {
            ProductBs productBs = new ProductBs();
            //    lvProducts.DataBind();

            if (!IsPostBack)
            {
                ddlProductType.DataSource = EnumerationUtils.GetProductTypeListItems();
                ddlProductType.DataTextField = "Text";
                ddlProductType.DataValueField = "Value";
                ddlProductType.DataBind();

                //ddlProductType.Items.Remove(((int)ProductType.Transportation).ToString()); 
                //ddlProductType.Items.Remove("Transportation");
                ddlProductType.Items.Remove(ddlProductType.Items.FindByValue(((int)ProductType.Transportation).ToString())); 
                //ddlProductType.Items.FindByValue(((int)ProductType.Transportation).ToString())

                ddlRegion.DataSource = productBs.GetAllRegions();
                ddlRegion.DataTextField = "regionName";
                ddlRegion.DataValueField = "id";
                ddlRegion.DataBind();
            }

        }


        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
            ExportBs exportBs = new ExportBs();

            StringBuilder sb = new StringBuilder(File.ReadAllText(Server.MapPath(ExportFilePath)));
            string exportBody = "";

            byte productTypeId = byte.Parse(ddlProductType.SelectedValue);

            ProductType pt = (ProductType)productTypeId;

            var r = (ddlRegion.SelectedValue != "" && pt != ProductType.TourOps) ? (Region)Int16.Parse(ddlRegion.SelectedValue) : (Region?)null;
            string regionLabel = "";
            string productLabel = ResourceUtils.GetProductTypeLabel((ProductType)productTypeId);

            productLabel = productLabel.Replace(" ", "_");

            string fileName = String.Format("{0}{1}_{2}_{3}.xlsx", productLabel, (r.HasValue) ? String.Format("_{0}", ResourceUtils.GetRegionLabel(r.Value).Replace(" ", "_")) : "", ddlLanguage.SelectedValue, DateTime.Now.ToShortDateString().Replace(" ", "_"));

            var a = exportBs.ExportListingsNew(r, pt, ddlLanguage.SelectedValue);
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", String.Format("attachment;  filename={0}", fileName));
            Response.BinaryWrite(a.GetAsByteArray());
            Response.End();
           
            Response.Flush();
            Response.Close();
        }


        protected void btnSubmit_OnClickOld(object sender, EventArgs e)
        {
            ExportBs exportBs = new ExportBs();

            StringBuilder sb = new StringBuilder(File.ReadAllText(Server.MapPath(ExportFilePath)));
            string exportBody = "";

            byte productTypeId = byte.Parse(ddlProductType.SelectedValue);
           
            ProductType pt = (ProductType)productTypeId;

            Region r = (Region) 0;
            string regionLabel = "";

            switch (pt)
            {
                case ProductType.Accommodation:
                    r = (Region) Int16.Parse(ddlRegion.SelectedValue);
                    exportBody = exportBs.ExportAccommodations(r, ddlLanguage.SelectedValue);
                    break;
                case ProductType.Attraction:
                    r = (Region)Int16.Parse(ddlRegion.SelectedValue);
                    exportBody = exportBs.ExportAttractions(r, ddlLanguage.SelectedValue);
                    break;
                case ProductType.Campground:
                    r = (Region)Int16.Parse(ddlRegion.SelectedValue);
                    exportBody = exportBs.ExportCampgrounds(r, ddlLanguage.SelectedValue);
                    break;
                case ProductType.FineArts:
                    r = (Region)Int16.Parse(ddlRegion.SelectedValue);
                    exportBody = exportBs.ExportFineArts(r, ddlLanguage.SelectedValue);
                    //exportBody = exportBs;
                    break;
                case ProductType.Outdoors:
                    r = (Region)Int16.Parse(ddlRegion.SelectedValue);
                    exportBody = exportBs.ExportOutdoors(r, ddlLanguage.SelectedValue);
                    break;
                case ProductType.Restaurants:
                    r = (Region)Int16.Parse(ddlRegion.SelectedValue);
                    exportBody = exportBs.ExportRestaurants(r, ddlLanguage.SelectedValue);
                    break;
                case ProductType.TourOps:
                    exportBody = exportBs.ExportTourOps(ddlLanguage.SelectedValue);
                    break;
                case ProductType.Trails:
                    r = (Region)Int16.Parse(ddlRegion.SelectedValue);
                    exportBody = exportBs.ExportTrails(r,ddlLanguage.SelectedValue);
                    break;
                default:
                    break;
            }

            sb.Append(exportBody);

            string productLabel = ResourceUtils.GetProductTypeLabel((ProductType)productTypeId);
            
            productLabel = productLabel.Replace(" ", "_");

            string fileName = String.Format("{0}{1}_{2}_{3}.exp", productLabel, ((int)r == 0) ? "" : String.Format("_{0}",ResourceUtils.GetRegionLabel(r).Replace(" ", "_")), ddlLanguage.SelectedValue, DateTime.Now.ToShortDateString().Replace(" ", "_"));

            Response.AddHeader("content-disposition", String.Format("attachment; filename={0}", fileName));
            Response.ContentType = "text/plain";
            Response.Write(sb.ToString());

            Response.Flush();
            Response.Close();

        }
    }
}