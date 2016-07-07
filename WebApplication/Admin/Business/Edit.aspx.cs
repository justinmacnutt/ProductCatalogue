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
using PrimaryContactListItem = WebApplication.ValueObjects.ListItemVos.PrimaryContactListItem;
using ProductListItem = WebApplication.ValueObjects.ListItemVos.ProductListItem;

namespace WebApplication.Admin.Business
{
    public partial class Edit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;

            if (IsPostBack)
            {
                id = Int32.Parse(hdnBusinessId.Value);
            }
            else
            {
                id = Int32.Parse(Request.QueryString["id"]);
                hdnBusinessId.Value = id.ToString();
            }

            BusinessBs businessBs = new BusinessBs();
            ProductBs productBs = new ProductBs();


            //  CurrentProduct = accommodationBs.GetProduct(id);
            ProductCatalogue.DataAccess.Business b = businessBs.GetBusiness(id);

            if (!IsPostBack)
            {
                tbBusinessName.Text = b.businessName;
                tbDescription.Text = b.description;

                ddlBusinessContactType.DataSource = EnumerationUtils.GetBusinessContactTypeListItems();
                ddlBusinessContactType.DataTextField = "Text";
                ddlBusinessContactType.DataValueField = "Value";
                ddlBusinessContactType.DataBind();

                ddlAddressType.DataSource = EnumerationUtils.GetAddressTypeListItems();
                ddlAddressType.DataTextField = "Text";
                ddlAddressType.DataValueField = "Value";
                ddlAddressType.DataBind();

                ddlContactAddressType.DataSource = EnumerationUtils.GetAddressTypeListItems();
                ddlContactAddressType.DataTextField = "Text";
                ddlContactAddressType.DataValueField = "Value";
                ddlContactAddressType.DataBind();
                ddlContactAddressType.SelectedIndex = 0;

                ddlProductType.DataSource = EnumerationUtils.GetProductTypeListItems();
                ddlProductType.DataTextField = "Text";
                ddlProductType.DataValueField = "Value";
                ddlProductType.DataBind();

                ddlProductCommunity.DataSource = productBs.GetAllCommunities();
                ddlProductCommunity.DataTextField = "communityName";
                ddlProductCommunity.DataValueField = "id";
                ddlProductCommunity.SelectedValue = "";
                ddlProductCommunity.DataBind();

                ddlSourceAddress.DataSource = GetSourceAddressListItems(id);
                ddlSourceAddress.DataTextField = "Text";
                ddlSourceAddress.DataValueField = "Value";
                ddlSourceAddress.DataBind();

                ddlBusinessContactType.DataSource = 

                rptAddress.DataSource = GenerateBusinessAddressList(id);
                rptAddress.DataBind();

                //IQueryable<ProductCatalogue.DataAccess.Contact> cq  = businessBs.GetBusinessContacts(id);
                List<ListItemVos.BusinessContactListItem> contactList = GenerateBusinessContactList(id);
                rptContact.DataSource = contactList;
                rptContact.DataBind();

                if (contactList.Count() > 0)
                {
                    lbDeleteBusinessTop.Enabled = false;
                    lbDeleteBusiness.Enabled = false;
                }

                GenerateProductList(b);
                //rptProduct.DataSource = productBs.GetProducts(b);
                //rptProduct.DataBind();

                rptNote.DataSource = businessBs.GetBusinessNotes(id);
                rptNote.DataBind();

                GeneratePrimaryContactList(id);
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

        private List<ListItemVos.BusinessContactListItem> GenerateBusinessContactList(int businessId)
        {
            BusinessBs businessBs = new BusinessBs();
            ProductBs productBs = new ProductBs();
            List<ProductCatalogue.DataAccess.Contact> cl = businessBs.GetBusinessContacts(businessId).ToList();

            List<ListItemVos.BusinessContactListItem> bclil = new List<ListItemVos.BusinessContactListItem>();

            foreach (ProductCatalogue.DataAccess.Contact c in cl)
            {
                ListItemVos.BusinessContactListItem bcli = new ListItemVos.BusinessContactListItem();

                bcli.contactId = c.id.ToString();
                bcli.contactType = ResourceUtils.GetBusinessContactTypeLabel((BusinessContactType)c.contactTypeId);
                bcli.email = c.email;
                bcli.enableDelete = productBs.GetProducts(c).Count() > 0 ? false : true;
                bcli.firstName = c.firstName;
                bcli.jobTitle = c.jobTitle;
                bcli.lastName = c.lastName;
                bcli.isPrimary = (c.isPrimary) ? "1" : "0";
                
                bclil.Add(bcli);
            }

            return bclil;
        }

        private List<ListItemVos.AddressListItem> GenerateBusinessAddressList(int businessId)
        {
            BusinessBs businessBs = new BusinessBs();
            List<Address> al = businessBs.GetBusinessAddresses(businessId).ToList();

            List<ListItemVos.AddressListItem> balil = new List<ListItemVos.AddressListItem>();

            foreach (ProductCatalogue.DataAccess.Address a in al)
            {
                ListItemVos.AddressListItem bali = new ListItemVos.AddressListItem();
                
                bali.addressId = a.id.ToString();
                bali.city = a.city;
                bali.provinceRegion = a.provinceStateId ?? a.otherRegion;
                bali.addressType = ResourceUtils.GetAddressTypeLabel((AddressType)a.addressTypeId);
                bali.line1 = a.line1;
                bali.country = a.countryId;
                bali.postalCode = a.postalCode;

                balil.Add(bali);
            }

            return balil;
        }

        private void GenerateProductList(ProductCatalogue.DataAccess.Business b)
        {
            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();
            List<ProductCatalogue.DataAccess.Product> pl = productBs.GetProducts(b).ToList();

            List<ProductListItem> productList = new List<ProductListItem>();

            foreach (ProductCatalogue.DataAccess.Product p in pl)
            {
                ProductCatalogue.DataAccess.Contact c = businessBs.GetPrimaryContact(p);
                ProductListItem pli = new ProductListItem();
                
                pli.productId = p.id.ToString();
                pli.productName = p.productName;
                
                pli.productContactName = String.Format("{0} {1}",c.firstName ,c.lastName);
                pli.productType = ResourceUtils.GetProductTypeLabel((ProductType)p.productTypeId);

                if (p.communityId != null)
                {
                    pli.productCommunity = p.refCommunity.communityName;
                    pli.productRegion = p.refCommunity.refRegion.regionName;
                }

                productList.Add(pli);
            }

            rptProduct.DataSource = productList;
            rptProduct.DataBind();
            
        }

        private void GeneratePrimaryContactList(int businessId)
        {
            BusinessBs businessBs = new BusinessBs();

            List<ProductCatalogue.DataAccess.Contact> cl = businessBs.GetBusinessContacts(businessId).ToList();

            ddlPrimaryContact.Items.Clear();
            ddlPrimaryContact.Items.Add(EnumerationUtils.GetDefaultListItem());
            
            foreach (ProductCatalogue.DataAccess.Contact c in cl)
            {

                ListItem li = new ListItem();
                li.Text = String.Format("{0} {1}", c.firstName, c.lastName);
                li.Value = c.id.ToString();

                ddlPrimaryContact.Items.Add(li);
            }
        }

        

        protected void btnAddressSubmit_onClick(object sender, EventArgs e)
        {
            int businessId = Int32.Parse(hdnBusinessId.Value);
            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Business b = businessBs.GetBusiness(businessId);

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
                businessBs.AddAddress(b, byte.Parse(ddlAddressType.SelectedValue), tbLine1.Text, tbLine2.Text,
                                      tbLine3.Text,
                                      tbCity.Text, provinceStateId, otherRegion, tbPostalCode.Text,
                                      ddlCountry.SelectedValue, HttpContext.Current.User.Identity.Name);
            }

            ddlSourceAddress.DataSource = GetSourceAddressListItems(businessId);
            ddlSourceAddress.DataTextField = "Text";
            ddlSourceAddress.DataValueField = "Value";
            ddlSourceAddress.DataBind();

            rptAddress.DataSource = GenerateBusinessAddressList(businessId);
            rptAddress.DataBind();
            ClearAddressForm();
        }

        private void ClearAddressForm()
        {
            ddlAddressType.SelectedValue = "";
            tbLine1.Text = "";
            tbLine2.Text = "";
            tbLine3.Text = "";
            tbCity.Text = "";
            tbOtherRegion.Text = "";
            ddlProvinceState.SelectedValue = "NS";
            ddlCountry.SelectedValue = "CA";
            tbPostalCode.Text = "";
            

            hdnAddressId.Value = "";
        }

        protected void btnEditAddress_onClick(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            
            hdnAddressId.Value = lb.CommandArgument;

            int addressId = Int32.Parse(lb.CommandArgument);
            
            BusinessBs businessBs = new BusinessBs();
            Address a = businessBs.GetAddress(addressId);

            ddlAddressType.SelectedValue = a.addressTypeId.ToString();
           
            tbLine1.Text = a.line1;
            tbLine2.Text = a.line2;
            tbLine3.Text = a.line3;
            tbCity.Text = a.city;
            tbPostalCode.Text = a.postalCode;

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

        protected void btnContactSubmit_onClick(object sender, EventArgs e)
        {
            int businessId = Int32.Parse(hdnBusinessId.Value);
            byte businessContactTypeId = byte.Parse(ddlBusinessContactType.SelectedValue);
            BusinessBs businessBs = new BusinessBs();
            string otherRegion;
            string provinceStateId;

            if (ddlContactCountry.SelectedValue == "CA" || ddlContactCountry.SelectedValue == "US")
            {
                provinceStateId = ddlContactProvinceState.SelectedValue;
                otherRegion = null;
            }
            else
            {
                provinceStateId = null;
                otherRegion = tbContactOtherRegion.Text;
            }

            ProductCatalogue.DataAccess.Contact c = businessBs.AddContact(businessId, businessContactTypeId, tbFirstName.Text, tbLastName.Text, tbJobTitle.Text, tbEmail.Text, tbComment.Text, HttpContext.Current.User.Identity.Name);
           
            businessBs.AddAddress(c, byte.Parse(ddlContactAddressType.SelectedValue), tbContactLine1.Text,
                                  tbContactLine2.Text, tbContactLine3.Text, tbContactCity.Text,
                                  provinceStateId, tbContactPostalCode.Text,
                                  otherRegion, ddlContactCountry.SelectedValue, HttpContext.Current.User.Identity.Name);

            businessBs.AddPhone(c, (int)PhoneType.Primary, tbWorkPhone.Text, "", HttpContext.Current.User.Identity.Name);
            
            if (tbMobile.Text != "")
            {
                businessBs.AddPhone(c, (int)PhoneType.Mobile, tbMobile.Text, "", HttpContext.Current.User.Identity.Name);
            }
            if (tbFax.Text != "")
            {
                businessBs.AddPhone(c, (int)PhoneType.Fax, tbFax.Text, "", HttpContext.Current.User.Identity.Name);
            }
            

            GeneratePrimaryContactList(businessId);

            List<ListItemVos.BusinessContactListItem> contactList = GenerateBusinessContactList(businessId);
            rptContact.DataSource = contactList;
            rptContact.DataBind();

            ClearContactForm();
        }

        protected void btnProductSubmit_onClick(object sender, EventArgs e)
        {
            ProductBs productBs = new ProductBs();
            BusinessBs businessBs = new BusinessBs();

            short myShort;

            short? communityId = short.TryParse(ddlProductCommunity.SelectedValue, out myShort) ? myShort : (short?)null;

            int businessId = Int32.Parse(hdnBusinessId.Value);
            ProductCatalogue.DataAccess.Business b = businessBs.GetBusiness(businessId);

            string web = (!String.IsNullOrEmpty(tbProductWebsite.Text) &&
                          Regex.IsMatch(tbProductWebsite.Text.Trim().ToLower(), "^https?://"))
                             ? tbProductWebsite.Text.Trim()
                             : String.IsNullOrEmpty(tbProductWebsite.Text) ? "" : String.Concat("http://", tbProductWebsite.Text.Trim());
            
            ProductCatalogue.DataAccess.Product product = productBs.AddProduct(Int32.Parse(ddlPrimaryContact.SelectedValue), tbProductName.Text, byte.Parse(ddlProductType.SelectedValue), tbProductLine1.Text, tbProductLine2.Text, tbProductLine3.Text, communityId, tbProductPostalCode.Text,tbProductProprietor.Text,tbProductEmail.Text, web, tbProductTelephone.Text,tbProductTollfree.Text, tbProductFax.Text, HttpContext.Current.User.Identity.Name);
            
            productBs.LogProductVersion(product.id, ProductCatalogue.DataAccess.Enumerations.Action.Add, HttpContext.Current.User.Identity.Name);

            GenerateProductList(b);
            ClearProductForm();

        }

        private void ClearContactForm()
        {
            tbFirstName.Text = "";
            tbLastName.Text = "";
            tbJobTitle.Text = "";
            tbEmail.Text = "";
            tbComment.Text = "";
            tbContactCity.Text = "";
            tbContactLine1.Text = "";
            tbContactLine2.Text = "";
            tbContactLine3.Text = "";
            tbContactPostalCode.Text = "";
            tbContactOtherRegion.Text = "";
            tbWorkPhone.Text = "";
            tbMobile.Text = "";
            tbFax.Text = "";
            ddlContactProvinceState.SelectedValue = "NS";
            ddlContactCountry.SelectedValue = "CA";
            ddlContactAddressType.SelectedValue = "";
            hdnDisplayContactForm.Value = "";
       
            
        }

        private void ClearNoteForm()
        {
            tbNote.Text = "";
            tbNoteReminderDate.Text = "";
            
        }

        private void ClearProductForm()
        {
            ddlPrimaryContact.SelectedValue = "";

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


        protected void btnEditContact_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;

            Response.Redirect("../Contact/Edit.aspx?id=" + b.CommandArgument);
            
        }

        protected void btnEditProduct_onClick(object sender, EventArgs e)
        {
            LinkButton b = (LinkButton)sender;

            Response.Redirect("../Product/Edit.aspx?id=" + b.CommandArgument);

        }

        protected void btnSubmit_onClick(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                UpdateBusiness();

                // Reload the current page.
                Response.Redirect(Request.RawUrl);
            }
        }

        private void UpdateBusiness()
        {
            int id = Int32.Parse(hdnBusinessId.Value);
            
            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Business b = businessBs.GetBusiness(id);

            b.businessName = tbBusinessName.Text;
            b.description = tbDescription.Text;

            b.lastModifiedBy = HttpContext.Current.User.Identity.Name;
            b.lastModifiedDate = DateTime.Now;

            if (hdnPrimaryContactId.Value != "")
            {
                int primaryContactId = Int32.Parse(hdnPrimaryContactId.Value);
                businessBs.SetBusinessPrimaryContact(id,primaryContactId);
            }
            
            businessBs.Save();
        }

        protected void btnNoteSubmit_onClick(object sender, EventArgs e)
        {
            int id = Int16.Parse(hdnBusinessId.Value);
            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Business b = businessBs.GetBusiness(id);

            DateTime? dt = null;
            try
            {
                dt = DateTime.ParseExact(tbNoteReminderDate.Text, "dd-MM-yyyy", null);    
            }
            catch(Exception exc)
            {
                //do nothing
            }


            businessBs.AddNote(b, tbNote.Text, dt, HttpContext.Current.User.Identity.Name);

            rptNote.DataSource = businessBs.GetBusinessNotes(id);
            rptNote.DataBind();
            ClearNoteForm();
        }

        protected void btnCancelReminder_onClick(object sender, EventArgs e)
        {
            int id = Int16.Parse(hdnBusinessId.Value);
            LinkButton b = (LinkButton)sender;

            int noteId = Int32.Parse(b.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            businessBs.CancelNoteReminder(noteId);
            rptNote.DataSource = businessBs.GetBusinessNotes(id);
            rptNote.DataBind();
        }

        protected void btnCopyAddress_onClick(object sender, EventArgs e)
        {
            BusinessBs businessBs = new BusinessBs();
            int addressId = Int32.Parse(ddlSourceAddress.SelectedValue);

            ProductCatalogue.DataAccess.Address a = businessBs.GetAddress(addressId);

            hdnDisplayContactForm.Value = "1";

            ddlContactAddressType.SelectedValue = a.addressTypeId.ToString();
            tbContactLine1.Text = a.line1;
            tbContactLine2.Text = a.line2;
            tbContactLine3.Text = a.line3;
            tbContactCity.Text = a.city;
            tbContactPostalCode.Text = a.postalCode;
            tbContactOtherRegion.Text = a.otherRegion;

            if (a.provinceStateId != null)
            {
                ddlContactProvinceState.SelectedValue = a.provinceStateId;
                ddlContactCountry.SelectedValue = a.refProvinceState.countryId;    
            }
            else
            {
                ddlContactCountry.SelectedValue = a.countryId;
                tbContactOtherRegion.Text = a.otherRegion;
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
            int businessId = Int32.Parse(hdnBusinessId.Value);
            LinkButton lb = (LinkButton)sender;
            int addressId = Int32.Parse(lb.CommandArgument);

            BusinessBs businessBs = new BusinessBs();
            businessBs.DeleteBusinessAddress(addressId);

            if (hdnAddressId.Value == addressId.ToString())
            {
                ClearAddressForm();
            }

            ddlSourceAddress.DataSource = GetSourceAddressListItems(businessId);
            ddlSourceAddress.DataTextField = "Text";
            ddlSourceAddress.DataValueField = "Value";
            ddlSourceAddress.DataBind();

            rptAddress.DataSource = GenerateBusinessAddressList(businessId);
            rptAddress.DataBind();
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
            args.IsValid = businessId <= 0 || hdnBusinessId.Value == businessId.ToString();

            if (args.IsValid)
                plcBusiness.Visible = false;
            else
            {
                plcBusiness.Visible = true;
                lnkBusiness.Text = tbBusinessName.Text;
                lnkBusiness.NavigateUrl = String.Concat("Edit.aspx?id=", businessId);
            }
        }

        protected void lbDeleteBusiness_onClick(object sender, EventArgs e)
        {
            int businessId = Int32.Parse(hdnBusinessId.Value);
            BusinessBs businessBs = new BusinessBs();
            businessBs.DeleteBusiness(businessId, HttpContext.Current.User.Identity.Name);

            Response.Redirect("Index.aspx");
        }

        protected void btnDeleteContact_onClick(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            int businessId = Int32.Parse(hdnBusinessId.Value);
            int contactId = Int32.Parse(lb.CommandArgument);
            BusinessBs businessBs = new BusinessBs();
            businessBs.DeleteContact(contactId, HttpContext.Current.User.Identity.Name);

            List<ListItemVos.BusinessContactListItem> contactList = GenerateBusinessContactList(businessId);
            rptContact.DataSource = contactList;
            rptContact.DataBind();

            
        }

        protected void btnDeleteProduct_onClick(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            int productId = Int32.Parse(lb.CommandArgument);
            int businessId = Int32.Parse(hdnBusinessId.Value);

            BusinessBs businessBs = new BusinessBs();
            ProductCatalogue.DataAccess.Business b = businessBs.GetBusiness(businessId);

            ProductBs productBs = new ProductBs();
            productBs.DeleteProduct(productId, HttpContext.Current.User.Identity.Name);

            GenerateProductList(b);

            List<ListItemVos.BusinessContactListItem> contactList = GenerateBusinessContactList(businessId);
            rptContact.DataSource = contactList;
            rptContact.DataBind();
        }
    }
}
