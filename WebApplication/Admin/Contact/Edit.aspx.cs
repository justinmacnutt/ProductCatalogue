using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProductCatalogue.BusinessServices;
using ProductCatalogue.DataAccess;
using ProductCatalogue.DataAccess.Enumerations;
using WebApplication.Utilities;
using WebApplication.ValueObjects;
using ProductListItem = WebApplication.ValueObjects.ListItemVos.ProductListItem;

namespace WebApplication.Admin.Contact
{
    public partial class Edit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;

            if (IsPostBack)
            {
                id = Int32.Parse(hdnContactId.Value);
            }
            else
            {
                id = Int32.Parse(Request.QueryString["id"]);
                hdnContactId.Value = id.ToString();
            }

            BusinessBs businessBs = new BusinessBs();
            ProductBs productBs = new ProductBs();
            //  CurrentProduct = accommodationBs.GetProduct(id);
            ProductCatalogue.DataAccess.Contact c = businessBs.GetContact(id);

            if (!IsPostBack)
            {
                tbFirstName.Text = c.firstName;
                tbLastName.Text = c.lastName;
                tbJobTitle.Text = c.jobTitle;
                tbEmail.Text = c.email;
                tbComment.Text = c.comment;

                litContactName.Text = String.Format("{0} {1}", c.firstName, c.lastName);

                ProductCatalogue.DataAccess.Business b = businessBs.GetBusiness(c.businessId);

                litParentBusinessName.Text = String.Format("<a href='../Business/Edit.aspx?id={0}'>{1}</a>", b.id,
                                                           b.businessName);

                ddlAddressType.DataSource = EnumerationUtils.GetAddressTypeListItems();
                ddlAddressType.DataTextField = "Text";
                ddlAddressType.DataValueField = "Value";
                ddlAddressType.DataBind();

                ddlPhoneType.DataSource = EnumerationUtils.GetPhoneTypeListItems();
                ddlPhoneType.DataTextField = "Text";
                ddlPhoneType.DataValueField = "Value";
                ddlPhoneType.DataBind();

                ddlProductType.DataSource = EnumerationUtils.GetProductTypeListItems();
                ddlProductType.DataTextField = "Text";
                ddlProductType.DataValueField = "Value";
                ddlProductType.DataBind();

                ddlBusinessContactType.DataSource = EnumerationUtils.GetBusinessContactTypeListItems();
                ddlBusinessContactType.DataTextField = "Text";
                ddlBusinessContactType.DataValueField = "Value";
                ddlBusinessContactType.DataBind();
                ddlBusinessContactType.SelectedValue = c.contactTypeId.ToString();

                ddlSourceAddress.DataSource = GetSourceAddressListItems(c.businessId);
                ddlSourceAddress.DataTextField = "Text";
                ddlSourceAddress.DataValueField = "Value";
                ddlSourceAddress.DataBind();

                ddlProductCommunity.DataSource = productBs.GetAllCommunities();
                ddlProductCommunity.DataTextField = "communityName";
                ddlProductCommunity.DataValueField = "id";
                ddlProductCommunity.SelectedValue = "";
                ddlProductCommunity.DataBind();

                rptAddress.DataSource = GenerateContactAddressList(id);
                rptAddress.DataBind();

                rptPhone.DataSource = GeneratePhoneList(id);
                rptPhone.DataBind();

                //rptProduct.DataSource = productBs.GetProducts(c);
                //rptProduct.DataBind();

                List<ProductListItem> pli = GenerateProductList(c);

                rptProduct.DataSource = pli;
                rptProduct.DataBind();

                rptNote.DataSource = businessBs.GetContactNotes(id);
                rptNote.DataBind();

                if (pli.Count() > 0)
                {
                    lbDeleteContactTop.OnClientClick = "return false";
                    lbDeleteContactTop.Enabled = false;
                    lbDeleteContact.OnClientClick = "return false";
                    lbDeleteContact.Enabled = false;
                }
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

                        lnkViewProduct.NavigateUrl = String.Concat("../Product/Edit.aspx?id=", products.First().id);
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

        protected void btnAddressSubmit_onClick(object sender, EventArgs e)
        {
            int contactId = Int32.Parse(hdnContactId.Value);
            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Contact c = businessBs.GetContact(contactId);

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

            if (hdnAddressId.Value != "")
            {
                int addressId = Int32.Parse(hdnAddressId.Value);
                Address a = businessBs.GetAddress(addressId);
                a.line1 = tbLine1.Text;
                a.line2 = tbLine2.Text;
                a.line3 = tbLine3.Text;
                a.city = tbCity.Text;
                a.otherRegion = otherRegion;
                a.provinceStateId = provinceStateId;
                a.postalCode = tbPostalCode.Text;
                a.countryId = ddlCountry.SelectedValue;
                a.addressTypeId = byte.Parse(ddlAddressType.SelectedValue);

                a.lastModifiedBy = HttpContext.Current.User.Identity.Name;
                a.lastModifiedDate = DateTime.Now;

                businessBs.Save();
            }
            else
            {
                //businessBs.AddAddress(c, Int32.Parse(ddlAddressType.SelectedValue), tbLine1.Text, tbLine2.Text, tbLine3.Text, tbCity.Text, "NS", tbPostalCode.Text, "", "");
                businessBs.AddAddress(c, byte.Parse(ddlAddressType.SelectedValue), tbLine1.Text, tbLine2.Text,
                                      tbLine3.Text,
                                      tbCity.Text, provinceStateId, tbPostalCode.Text, otherRegion,
                                      ddlCountry.SelectedValue, HttpContext.Current.User.Identity.Name);
            }
        
            rptAddress.DataSource = GenerateContactAddressList(contactId);
            rptAddress.DataBind();

            //ddlSourceAddress.DataSource = GetSourceAddressListItems(c.businessId);
            //ddlSourceAddress.DataTextField = "Text";
            //ddlSourceAddress.DataValueField = "Value";
            //ddlSourceAddress.DataBind();

            ClearAddressForm();
        }

        private List<ProductListItem> GenerateProductList(ProductCatalogue.DataAccess.Contact c)
        {
            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();
            List<ProductCatalogue.DataAccess.Product> pl = productBs.GetProducts(c).ToList();

            List<ProductListItem> productList = new List<ProductListItem>();

            foreach (ProductCatalogue.DataAccess.Product p in pl)
            {
                ProductListItem pli = new ProductListItem();

                //mli.mediaPath = System.Web.Configuration.WebConfigurationManager.AppSettings["ManagedMediaUploadRelativePath"] + m.id + "." + GetFileExtension(m.fileName);
                pli.productId = p.id.ToString();
                pli.productName = p.productName;
                
                if (p.communityId != null)
                {
                    pli.productCommunity = p.refCommunity.communityName;
                    pli.productRegion = p.refCommunity.refRegion.regionName;
                }
                
                pli.productType = ResourceUtils.GetProductTypeLabel((ProductType)p.productTypeId);
                productList.Add(pli);
            }

            return productList;
        }

        private void ClearAddressForm()
        {
            tbLine1.Text = "";
            tbLine2.Text = "";
            tbLine3.Text = "";
            tbCity.Text = "";
            tbPostalCode.Text = "";
            ddlAddressType.SelectedValue = "";
            ddlProvinceState.SelectedValue = "NS";
            ddlCountry.SelectedValue = "CA";

            hdnAddressId.Value = "";
            hdnDisplayAddressForm.Value = "";
        }

        private void ClearPhoneForm()
        {
            tbPhoneNumber.Text = "";
            tbPhoneComment.Text = "";
            ddlPhoneType.SelectedValue = "";

            hdnPhoneId.Value = "";
        }

        private List<ListItemVos.AddressListItem> GenerateContactAddressList(int contactId)
        {
            BusinessBs businessBs = new BusinessBs();
            List<Address> al = businessBs.GetContactAddresses(contactId).ToList();

            List<ListItemVos.AddressListItem> balil = new List<ListItemVos.AddressListItem>();

            foreach (ProductCatalogue.DataAccess.Address a in al)
            {
                ListItemVos.AddressListItem bali = new ListItemVos.AddressListItem();

                bali.addressId = a.id.ToString();
                bali.city = a.city;
                bali.provinceRegion = a.provinceStateId ?? a.otherRegion;
                bali.addressType = ResourceUtils.GetAddressTypeLabel((AddressType)a.addressTypeId);
                bali.line1 = a.line1;
                bali.postalCode = a.postalCode;
                bali.country = a.countryId;

                balil.Add(bali);
            }

            return balil;
        }

        private List<ListItemVos.PhoneListItem> GeneratePhoneList(int contactId)
        {
            BusinessBs businessBs = new BusinessBs();
            List<Phone> pl = businessBs.GetContactPhones(contactId).ToList();

            List<ListItemVos.PhoneListItem> plil = new List<ListItemVos.PhoneListItem>();

            foreach (ProductCatalogue.DataAccess.Phone p in pl)
            {
                ListItemVos.PhoneListItem pli = new ListItemVos.PhoneListItem();

                pli.phoneId = p.id.ToString();
                pli.phoneNumber = p.phoneNumber;
                pli.phoneType = ResourceUtils.GetPhoneTypeLabel((PhoneType) p.phoneTypeId);
                
                plil.Add(pli);
            }

            return plil;
        }

        protected void btnEditAddress_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;

            hdnAddressId.Value = b.CommandArgument;

            int addressId = Int32.Parse(b.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            Address a = businessBs.GetAddress(addressId);

            ddlAddressType.SelectedValue = a.addressTypeId.ToString();

            tbLine1.Text = a.line1;
            tbLine2.Text = a.line2;
            tbLine3.Text = a.line3;
            tbCity.Text = a.city;
            tbPostalCode.Text = a.postalCode;

    //        ddlProvinceState.SelectedValue = a.provinceStateId ?? "";


            if (a.provinceStateId != null)
            {
                ddlProvinceState.SelectedValue = a.provinceStateId;
                ddlCountry.SelectedValue = a.refProvinceState.countryId;
            }
            else
            {
                ddlCountry.SelectedValue = a.countryId;
                tbOtherRegion.Text = a.otherRegion;
            }

        }

        
        protected void btnPhoneSubmit_onClick(object sender, EventArgs e)
        {
            int contactId = Int32.Parse(hdnContactId.Value);
            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Contact c = businessBs.GetContact(contactId);

            if (hdnPhoneId.Value != "")
            {
                int phoneId = Int32.Parse(hdnPhoneId.Value);
                Phone p = businessBs.GetPhone(phoneId);
                p.phoneNumber = tbPhoneNumber.Text;
                p.comment = tbPhoneComment.Text;
                p.phoneTypeId = byte.Parse(ddlPhoneType.SelectedValue);

                p.lastModifiedBy = HttpContext.Current.User.Identity.Name;
                p.lastModifiedDate = DateTime.Now;

                businessBs.Save();
            }
            else
            {
                businessBs.AddPhone(c, byte.Parse(ddlPhoneType.SelectedValue), tbPhoneNumber.Text, tbPhoneComment.Text, HttpContext.Current.User.Identity.Name);
            }

            rptPhone.DataSource = GeneratePhoneList(contactId); 
            rptPhone.DataBind();
            ClearPhoneForm();
        }

        protected void btnEditPhone_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;

            hdnPhoneId.Value = b.CommandArgument;

            int phoneId = Int32.Parse(b.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            Phone p = businessBs.GetPhone(phoneId);

            
            ddlPhoneType.SelectedValue = p.phoneTypeId.ToString();
            //ddlAddressType.DataBind();

            tbPhoneNumber.Text = p.phoneNumber;
            tbPhoneComment.Text = p.comment;
            ddlPhoneType.SelectedValue = p.phoneTypeId.ToString();
            
        }

        protected void btnProductSubmit_onClick(object sender, EventArgs e)
        {
            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();

            int contactId = Int32.Parse(hdnContactId.Value);
            ProductCatalogue.DataAccess.Contact c = businessBs.GetContact(contactId);

            short myShort;
            short? communityId = short.TryParse(ddlProductCommunity.SelectedValue, out myShort) ? myShort : (short?)null;

            string web = (!String.IsNullOrEmpty(tbProductWebsite.Text) &&
                          Regex.IsMatch(tbProductWebsite.Text.Trim().ToLower(), "^https?://"))
                             ? tbProductWebsite.Text.Trim()
                             : String.IsNullOrEmpty(tbProductWebsite.Text) ? "" : String.Concat("http://", tbProductWebsite.Text.Trim());

            //ProductCatalogue.DataAccess.Product product = productBs.AddProduct(contactId, tbProductName.Text, byte.Parse(ddlProductType.SelectedValue), tbProductLine1.Text, tbProductLine2.Text, tbProductLine3.Text, communityId, tbProductPostalCode.Text, "", "", web, "", "", "", HttpContext.Current.User.Identity.Name);
            ProductCatalogue.DataAccess.Product product = productBs.AddProduct(contactId, tbProductName.Text, byte.Parse(ddlProductType.SelectedValue), tbProductLine1.Text, tbProductLine2.Text, tbProductLine3.Text, communityId, tbProductPostalCode.Text, tbProductProprietor.Text, tbProductEmail.Text, web, tbProductTelephone.Text, tbProductTollfree.Text, tbProductFax.Text, HttpContext.Current.User.Identity.Name);

            productBs.LogProductVersion(product.id, ProductCatalogue.DataAccess.Enumerations.Action.Add, HttpContext.Current.User.Identity.Name);
            //rptProduct.DataSource = productBs.GetProducts(c);
            //rptProduct.DataBind();

            rptProduct.DataSource = GenerateProductList(c);
            rptProduct.DataBind();

            ClearProductForm();
        }

        private void ClearProductForm()
        {
            tbProductName.Text = "";
            ddlProductType.SelectedValue = "";
            tbProductLine1.Text = "";
            tbProductLine2.Text = "";
            tbProductLine3.Text = "";
            tbProductPostalCode.Text = "";
            ddlProductCommunity.SelectedValue = "";
            
            tbProductWebsite.Text = "";
            tbProductEmail.Text = "";
            tbProductFax.Text = "";
            tbProductProprietor.Text = "";
            tbProductTollfree.Text = "";
            tbProductTelephone.Text = "";

        }

            
        protected void btnEditProduct_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;

            Response.Redirect("../Product/Edit.aspx?id=" + b.CommandArgument);
            
        }

        protected void btnSubmit_onClick(object sender, EventArgs e)
        {
            UpdateContact();

            // Reload the current page.
            Response.Redirect(Request.RawUrl);
        }

        private void UpdateContact()
        {
            int id = Int16.Parse(hdnContactId.Value);
            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Contact c = businessBs.GetContact(id);

            if (tbNewBusinessName.Text != "")
            {
                int newBusinessId = businessBs.GetBusinessId(tbNewBusinessName.Text.Trim());
                if (newBusinessId < 0)
                {
                    cvNewBusinessName.IsValid = false;
                    return;
                }
                c.businessId = newBusinessId;
                c.contactTypeId = (businessBs.GetBusinessContacts(newBusinessId).Count() > 0) ? (byte)ContactType.Secondary : (byte)ContactType.Primary;
                
                litParentBusinessName.Text = String.Format("<a href='../Business/Edit.aspx?id={0}'>{1}</a>", newBusinessId, tbNewBusinessName.Text.Trim());
                tbNewBusinessName.Text = "";
            }

            c.firstName = tbFirstName.Text;
            c.lastName = tbLastName.Text;
            c.email = tbEmail.Text;
            c.jobTitle = tbJobTitle.Text;
            c.comment = tbComment.Text;
            c.contactTypeId = byte.Parse(ddlBusinessContactType.SelectedValue);

            c.lastModifiedBy = HttpContext.Current.User.Identity.Name;
            c.lastModifiedDate = DateTime.Now;

            businessBs.Save();

        }

        protected void btnNoteSubmit_onClick(object sender, EventArgs e)
        {
            int id = Int16.Parse(hdnContactId.Value);
            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Contact c = businessBs.GetContact(id);

            DateTime? dt = null;
            try
            {
                dt = DateTime.ParseExact(tbNoteReminderDate.Text, "dd-MM-yyyy", null);
            }
            catch (Exception exc)
            {
                //do nothing
            }

            businessBs.AddNote(c, tbNote.Text, dt, HttpContext.Current.User.Identity.Name);

            rptNote.DataSource = businessBs.GetContactNotes(id);
            rptNote.DataBind();
            ClearNoteForm();
        }

        private void ClearNoteForm()
        {
            tbNote.Text = "";
            tbNoteReminderDate.Text = "";
        }

        protected void btnCancelReminder_onClick(object sender, EventArgs e)
        {
            int id = Int16.Parse(hdnContactId.Value);
            LinkButton b = (LinkButton)sender;

            int noteId = Int32.Parse(b.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            businessBs.CancelNoteReminder(noteId);
            rptNote.DataSource = businessBs.GetContactNotes(id);
            rptNote.DataBind();
        }

        protected void btnCopyAddress_onClick(object sender, EventArgs e)
        {
            BusinessBs businessBs = new BusinessBs();
            int addressId = Int32.Parse(ddlSourceAddress.SelectedValue);

            ProductCatalogue.DataAccess.Address a = businessBs.GetAddress(addressId);

            ddlAddressType.SelectedValue = a.addressTypeId.ToString();
            tbLine1.Text = a.line1;
            tbLine2.Text = a.line2;
            tbLine3.Text = a.line3;
            tbCity.Text = a.city;
            tbPostalCode.Text = a.postalCode;
            tbOtherRegion.Text = a.otherRegion;
            hdnDisplayAddressForm.Value = "1";

            if (a.provinceStateId != null)
            {
                ddlProvinceState.SelectedValue = a.provinceStateId;
                ddlCountry.SelectedValue = a.refProvinceState.countryId;
            }
            else
            {
                ddlCountry.SelectedValue = a.countryId;
                tbOtherRegion.Text = a.otherRegion;
            }
        }

        private List<ListItem> GetSourceAddressListItems(int id)
        {
            BusinessBs businessBs = new BusinessBs();
            List<ListItem> l = new List<ListItem>();

            List<ProductCatalogue.DataAccess.Address> al = businessBs.GetBusinessAddresses(id).ToList();
            foreach (var a in al)
            {
                ListItem li = new ListItem(String.Format("{0}, {1}", a.line1, a.city), a.id.ToString());
                l.Add(li);
            }
            return l;
        }

        protected void btnDeleteAddress_onClick(object sender, EventArgs e)
        {
            int contactId = Int32.Parse(hdnContactId.Value);
            LinkButton b = (LinkButton)sender;
            int addressId = Int32.Parse(b.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            businessBs.DeleteContactAddress(addressId);

            if (hdnAddressId.Value == addressId.ToString())
            {
                ClearAddressForm();
            }

            rptAddress.DataSource = businessBs.GetContactAddresses(contactId);
            rptAddress.DataBind();
        }

        protected void btnDeletePhone_onClick(object sender, EventArgs e)
        {
            int contactId = Int32.Parse(hdnContactId.Value);
            LinkButton b = (LinkButton)sender;
            int phoneId = Int32.Parse(b.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            businessBs.DeleteContactPhone(phoneId);

            if (hdnPhoneId.Value == phoneId.ToString())
            {
                ClearPhoneForm();
            }

            rptPhone.DataSource = GeneratePhoneList(contactId);
            rptPhone.DataBind();
        }

        protected void lbDeleteContact_onClick(object sender, EventArgs e)
        {
            int contactId = Int32.Parse(hdnContactId.Value);
            BusinessBs businessBs = new BusinessBs();
            businessBs.DeleteContact(contactId, HttpContext.Current.User.Identity.Name);

            Response.Redirect("Index.aspx");
        }

        protected void btnDeleteProduct_onClick(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            int productId = Int32.Parse(lb.CommandArgument);
            int contactId = Int32.Parse(hdnContactId.Value);

            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Contact c = businessBs.GetContact(contactId);

            ProductBs productBs = new ProductBs();
            productBs.DeleteProduct(productId, HttpContext.Current.User.Identity.Name);

            rptProduct.DataSource = GenerateProductList(c);
            rptProduct.DataBind();
        }

        protected void cvNewBusinessName_ServerValidate(object source, ServerValidateEventArgs args)
        {
            BusinessBs businessBs = new BusinessBs();
            args.IsValid = businessBs.GetBusinessId(tbNewBusinessName.Text.Trim()) > 0;
        }
    }
}
