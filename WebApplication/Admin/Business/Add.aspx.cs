using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;


namespace WebApplication.Admin.Business
{
    public partial class Add : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
            if (IsValid)
            {
                BusinessBs businessBs = new BusinessBs();
                ProductCatalogue.DataAccess.Business b = businessBs.AddBusiness(tbBusinessName.Text, tbDescription.Text, HttpContext.Current.User.Identity.Name);
                Response.Redirect("Edit.aspx?id=" + b.id);
            }
        }

        /// <summary>
        /// Checks for unique business name.
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void cvBusinessName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            BusinessBs businessBs = new BusinessBs();
            int businessId = businessBs.GetBusinessId(tbBusinessName.Text.Trim());
            args.IsValid = businessId <= 0;

            if (args.IsValid)
                plcBusiness.Visible = false;
            else
            {
                plcBusiness.Visible = true;
                lnkBusiness.Text = tbBusinessName.Text;
                lnkBusiness.NavigateUrl = String.Concat("Edit.aspx?id=", businessId);
            }
        }
    }
}