using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication.Utilities;
using ProductCatalogue.DataAccess;
using ProductCatalogue.BusinessServices;

using Action = ProductCatalogue.DataAccess.Enumerations.Action;

namespace WebApplication.Admin.Product
{
    public partial class Add : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();

            if (!IsPostBack)
            {
                ddlProductType.DataSource = EnumerationUtils.GetProductTypeListItems();
                ddlProductType.DataTextField = "Text";
                ddlProductType.DataValueField = "Value";
                ddlProductType.DataBind();

                ddlCommunity.DataSource = productBs.GetAllCommunities();
                ddlCommunity.DataTextField = "communityName";
                ddlCommunity.DataValueField = "id";
                ddlCommunity.DataBind();
            }
            else
            {
                if (!String.IsNullOrEmpty(tbProductName.Text))
                {
                    IQueryable<ProductCatalogue.DataAccess.Product> products = productBs.GetProductsByName(tbProductName.Text);
                    if (products.Count() > 1)
                    {
                        plcProductsExist.Visible = true;
                        plcProductExists.Visible = false;
                    }
                    else if (products.Count() == 1)
                    {
                        plcProductsExist.Visible = false;
                        plcProductExists.Visible = true;

                        lnkViewProduct.NavigateUrl = String.Concat("Edit.aspx?id=", products.First().id);
                    }
                    else
                    {
                        plcProductsExist.Visible = false;
                        plcProductExists.Visible = false;
                    }
                }
                else
                {
                    plcProductsExist.Visible = false;
                    plcProductExists.Visible = false;
                }
            }

        }

        
        protected void btnProductSubmit_onClick(object sender, EventArgs e)
        {   
            ProductBs productBs = new ProductBs();

            short myShort;

            short? communityId = short.TryParse(ddlCommunity.SelectedValue, out myShort) ? myShort : (short?)null;

            string web = (!String.IsNullOrEmpty(tbWebsite.Text) &&
                          Regex.IsMatch(tbWebsite.Text.Trim().ToLower(), "^https?://"))
                             ? tbWebsite.Text.Trim()
                             : String.IsNullOrEmpty(tbWebsite.Text) ? "" : String.Concat("http://", tbWebsite.Text.Trim());

            string postalCode = (tbPostalCode.Text.Length == 6) ? String.Format("{0} {1}", tbPostalCode.Text.Substring(0, 3), tbPostalCode.Text.Substring(3, 3)) : tbPostalCode.Text;

            ProductCatalogue.DataAccess.Product p = productBs.AddProduct(Int32.Parse(ddlContact.SelectedValue), tbProductName.Text,
                                 byte.Parse(ddlProductType.SelectedValue), tbLine1.Text, tbLine2.Text, tbLine3.Text,
                                 communityId, postalCode, tbProprietor.Text,
                                 tbEmail.Text, web, tbTelephone.Text, tbTollFree.Text, tbFax.Text, HttpContext.Current.User.Identity.Name);

            productBs.LogProductVersion(p.id, Action.Add, HttpContext.Current.User.Identity.Name);

            MySessionVariables.SearchParameters.Clear();

            Response.Redirect("Edit.aspx?id=" + p.id);
        }

        
        protected void btnGetContacts_onClick(object sender, EventArgs e)
        {
            BusinessBs businessBs = new BusinessBs();
            
            int businessId = businessBs.GetBusinessId(tbBusinessName.Text);

            if (businessId > 0)
            {
                List<ProductCatalogue.DataAccess.Contact> cl = businessBs.GetBusinessContacts(businessId).ToList();

                ddlContact.Items.Clear();

                foreach (ProductCatalogue.DataAccess.Contact c in cl)
                {
                    ListItem li = new ListItem();
                    li.Text = String.Format("{0} {1}", c.firstName, c.lastName);
                    li.Value = c.id.ToString();

                    ddlContact.Items.Add(li);
                }

                if (ddlContact.Items.Count > 0)
                {
                    dvContactSelect.Visible = true;
                    dvNoContacts.Visible = false;
                    dvNoBusiness.Visible = false;
                }
                else
                {
                    dvContactSelect.Visible = false;
                    dvNoContacts.Visible = true;
                    dvNoBusiness.Visible = false;
                }
            }
            else
            {
                dvContactSelect.Visible = false;
                dvNoContacts.Visible = false;
                dvNoBusiness.Visible = true;
                cvBusinessName.Validate();
            }
        }

        /// <summary>
        /// Ensures business exists before adding.
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void cvBusinessName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            BusinessBs businessBs = new BusinessBs();
            args.IsValid = businessBs.GetBusinessId(tbBusinessName.Text.Trim()) > 0;
        }
    }
}
