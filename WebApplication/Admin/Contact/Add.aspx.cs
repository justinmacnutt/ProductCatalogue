using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;

namespace WebApplication.Admin.Contact
{
    public partial class Add : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlAddressType.DataSource = EnumerationUtils.GetAddressTypeListItems();
                ddlAddressType.DataTextField = "Text";
                ddlAddressType.DataValueField = "Value";
                ddlAddressType.DataBind();

                ddlBusinessContactType.DataSource = EnumerationUtils.GetBusinessContactTypeListItems();
                ddlBusinessContactType.DataTextField = "Text";
                ddlBusinessContactType.DataValueField = "Value";
                ddlBusinessContactType.DataBind();
            }
        }

 

        protected void btnContactSubmit_onClick(object sender, EventArgs e)
        {
            BusinessBs businessBs = new BusinessBs();

            int businessId = businessBs.GetBusinessId(tbBusinessName.Text);
            byte businessContactTypeId = byte.Parse(ddlBusinessContactType.SelectedValue);

            if (businessId > 0)
            {
                ProductCatalogue.DataAccess.Contact c = businessBs.AddContact(businessId, businessContactTypeId, tbFirstName.Text, tbLastName.Text, tbJobTitle.Text, tbEmail.Text, tbComment.Text, HttpContext.Current.User.Identity.Name);

                string otherRegion;
                string provinceStateId;
                if (ddlCountry.SelectedValue == "CA" || ddlCountry.SelectedValue == "US")
                {
                    provinceStateId = ddlProvinceState.SelectedValue;
                    otherRegion = null;
                }
                else
                {
                    provinceStateId = null;
                    otherRegion = tbOtherRegion.Text;
                }

                businessBs.AddAddress(c, byte.Parse(ddlAddressType.SelectedValue), tbLine1.Text,
                                      tbLine2.Text, tbLine3.Text, tbCity.Text,
                                      provinceStateId,
                                      tbPostalCode.Text, otherRegion, ddlCountry.SelectedValue, HttpContext.Current.User.Identity.Name);

                if (tbPrimaryPhone.Text != "")
                {
                    businessBs.AddPhone(c, (int)PhoneType.Primary, tbPrimaryPhone.Text, "", HttpContext.Current.User.Identity.Name);
                }

                if (tbMobile.Text != "")
                {
                    businessBs.AddPhone(c, (int)PhoneType.Mobile, tbMobile.Text, "", HttpContext.Current.User.Identity.Name);
                }
                if (tbHomePhone.Text != "")
                {
                    businessBs.AddPhone(c, (int)PhoneType.Home, tbHomePhone.Text, "", HttpContext.Current.User.Identity.Name);
                }
                if (tbOffSeason.Text != "")
                {
                    businessBs.AddPhone(c, (int)PhoneType.OffSeason, tbOffSeason.Text, "", HttpContext.Current.User.Identity.Name);
                }
                if (tbFax.Text != "")
                {
                    businessBs.AddPhone(c, (int)PhoneType.Fax, tbFax.Text, "", HttpContext.Current.User.Identity.Name);
                }

                Response.Redirect("Edit.aspx?id=" + c.id);
            }
            else
                cvBusinessName.Validate();
        }

        /// <summary>
        /// Populate address dropdown on click.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnGetAddresses_onClick(object sender, EventArgs e)
        {
            BusinessBs businessBs = new BusinessBs();

            int businessId = businessBs.GetBusinessId(tbBusinessName.Text);

            if (businessId > 0)
            {
                List<ProductCatalogue.DataAccess.Address> al = businessBs.GetBusinessAddresses(businessId).ToList();

                ddlCopyAddress.Items.Clear();

                foreach (ProductCatalogue.DataAccess.Address a in al)
                {

                    ListItem li = new ListItem();
                    li.Text = String.Format("{0} - {1}", a.line1, a.city);
                    li.Value = a.id.ToString();

                    ddlCopyAddress.Items.Add(li);
                }

                if (ddlCopyAddress.Items.Count > 0)
                {
                    dvAddressSelect.Visible = true;
                    dvNoContacts.Visible = false;
                    dvNoBusiness.Visible = false;
                }
                else
                {
                    dvAddressSelect.Visible = false;
                    dvNoContacts.Visible = true;
                    dvNoBusiness.Visible = false;
                }
            }
            else
            {
                dvAddressSelect.Visible = false;
                dvNoContacts.Visible = false;
                dvNoBusiness.Visible = true;
                cvBusinessName.Validate();
            }
        }

        /// <summary>
        /// Load address textboxes with values from currently selected address.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lbCopyAddress_onClick(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(ddlCopyAddress.SelectedValue))
            {
                int addressId = Int32.Parse(ddlCopyAddress.SelectedValue);
                BusinessBs businessBs = new BusinessBs();

                ProductCatalogue.DataAccess.Address a = businessBs.GetAddress(addressId);

                ddlAddressType.SelectedValue = a.addressTypeId.ToString();
                tbLine1.Text = a.line1;
                tbLine2.Text = a.line2;
                tbLine3.Text = a.line3;
                tbCity.Text = a.city;
                ddlProvinceState.SelectedValue = a.provinceStateId;
                ddlCountry.SelectedValue = a.countryId;
                tbPostalCode.Text = a.postalCode;

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